//
//  StatusAlert
//  Copyright © 2017-2018 Yegor Miroshnichenko. Licensed under the MIT license.
//

import UIKit

@objc public final class StatusAlert: UIView {
    
    // MARK: - Public fields -
    
    /// - Note: Do not change to save system look
    /// - Note: Changes while showing will have no effect
    @objc public var appearance: Appearance = Appearance.common
    
    /// Announced to VoiceOver when the alert gets presented
    @objc public var accessibilityAnnouncement: String? = nil
    
    // MARK: - Private fields -
    
    /// Used to present only one `StatusAlert` at once
    private static var isPresenting: Bool = false
    
    private let defaultDisappearTimerTimeInterval: TimeInterval = 2
    private let defaultFadeAnimationDuration: TimeInterval = TimeInterval(UINavigationControllerHideShowBarDuration)
    private let blurEffect: UIBlurEffect = UIBlurEffect(style: .light)
    
    /// @1x should be 90*90
    private var image: UIImage?
    private var title: String?
    private var message: String?
    
    private var contentView: UIVisualEffectView!
    
    private var timer: Timer?
    
    /// Determines whether `StatusAlert` can be showed
    private var canBeShowed: Bool {
        if StatusAlert.isPresenting {
            return false
        }
        if image == nil,
            title == nil,
            message == nil {
            return false
        }
        return true
    }
    
    /// Determines whether blur is available
    private var isBlurAvailable: Bool {
        return UIDevice.current.isBlurAvailable
    }
    
    /// Determines wether `StatusAlert` can be picked or dismissed by tap
    private var canBePickedOrDismissed: Bool = false
    private var pickGesture: UILongPressGestureRecognizer? {
        didSet {
            pickGesture?.allowableMovement = CGFloat.greatestFiniteMagnitude
            pickGesture?.minimumPressDuration = 0
            pickGesture?.cancelsTouchesInView = true
        }
    }
    
    // MARK: - Interaction methods
    
    @objc private func pick() {
        guard canBePickedOrDismissed
            else {
                return
        }
        if pickGesture?.state == .cancelled
            || pickGesture?.state == .ended
            || pickGesture?.state == .failed {
            dismiss()
        }
    }
    
    // MARK: - Static methods -
    
    /// Instantiates `StatusAlert`
    ///
    /// - Parameters:
    ///   - image: @1x should be 90*90, optional
    ///   - title: displayed beyond image
    ///   - message: displayed beyond title or
    ///   - canBePickedOrDismissed: determines wether StatusAlert can be picked or dismissed by tap
    /// - Returns: `StatusAlert` instance
    @objc(statusAlertWithImage:title:message:canBePickedOrDismissed:)
    public static func instantiate(withImage image: UIImage?,
                                   title: String?,
                                   message: String?,
                                   canBePickedOrDismissed: Bool = false) -> StatusAlert {
        let statusAlert = StatusAlert()
        
        NotificationCenter
            .default
            .addObserver(statusAlert,
                         selector: #selector(setupContentViewBackground),
                         name: NSNotification.Name.UIAccessibilityReduceTransparencyStatusDidChange,
                         object: nil)
        
        statusAlert.image = image
        statusAlert.title = title
        statusAlert.message = message
        statusAlert.canBePickedOrDismissed = canBePickedOrDismissed
        
        return statusAlert
    }
    
    // MARK: - Show methods -
    
    /// Shows `StatusAlert` in the center of the `keyWindow`
    /// - Note: must be called from the main thread only
    @objc public func showInKeyWindow() {
        show()
    }
    
    /// Shows `StatusAlert` in the center of `presenter`
    ///
    /// - Parameters:
    ///   - presenter: view present `StatusAlert` in
    /// - Note: must be called from the main thread only
    @objc(showInView:)
    public func show(in presenter: UIView) {
        show(inPresenter: presenter)
    }
    
    /// Shows `StatusAlert` in `keyWindow`
    ///
    /// - Parameters:
    ///   - verticalPosition: `StatusAlert` position in `keyWindow`
    /// - Note: must be called from the main thread only
    @objc(showWithVerticalPosition:)
    public func show(withVerticalPosition verticalPosition: VerticalPosition) {
        show(with: verticalPosition,
             offset: 0)
    }
    
    /// Shows `StatusAlert` in the center of `keyWindow` with `offset`
    ///
    /// - Parameters:
    ///   - offset: offset from center of `keyWindow`
    /// - Note: must be called from the main thread only
    @objc(showWithOffset:)
    public func show(withOffset offset: CGFloat) {
        show(offset: offset)
    }
    
    /// Shows `StatusAlert` in `presenter`
    ///
    /// - Parameters:
    ///   - presenter: view present `StatusAlert` in
    ///   - verticalPosition: `StatusAlert` position in `presenter`
    /// - Note: must be called from the main thread only
    @objc(showInView:withVerticalPosition:)
    public func show(in presenter: UIView,
                     withVerticalPosition verticalPosition: VerticalPosition) {
        show(inPresenter: presenter,
             with: verticalPosition)
    }
    
    /// Shows `StatusAlert` in the center of `presenter`
    ///
    /// - Parameters:
    ///   - presenter: view present `StatusAlert` in
    ///   - offset: offset from center in `presenter`
    /// - Note: must be called from the main thread only
    @objc(showInView:withOffset:)
    public func show(in presenter: UIView,
                     withOffset offset: CGFloat) {
        show(inPresenter: presenter,
             offset: offset)
    }
    
    /// Shows `StatusAlert` in `keyWindow`
    ///
    /// - Parameters:
    ///   - verticalPosition: `StatusAlert` position in `keyWindow`
    ///   - offset: offset for `verticalPosition` in `keyWindow`
    /// - Note: must be called from the main thread only
    @objc(showWithVerticalPosition:offset:)
    public func show(withVerticalPosition verticalPosition: VerticalPosition,
                     offset: CGFloat) {
        show(with: verticalPosition,
             offset: offset)
    }
    
    /// Shows `StatusAlert` in `presenter`
    ///
    /// - Parameters:
    ///   - presenter: view present `StatusAlert` in
    ///   - verticalPosition: `StatusAlert` position in `presenter`
    ///   - offset: offset for `verticalPosition` in `presenter`. To use default offset see the same method but without offset parameter.
    /// - Note: must be called from the main thread only
    @objc(showInView:withVerticalPosition:offset:)
    public func show(in presenter: UIView,
                     withVerticalPosition verticalPosition: VerticalPosition,
                     offset: CGFloat) {
        show(inPresenter: presenter,
             with: verticalPosition,
             offset: offset)
    }
    
    // MARK: - Private methods -
    
    private func show(inPresenter presenter: UIView = UIApplication.shared.keyWindow ?? UIView(),
                      with verticalPosition: VerticalPosition = .center,
                      offset: CGFloat? = nil) {
        guard canBeShowed
            else {
                return
        }
        prepare()
        position(inPresenter: presenter,
                 withVerticalPosition: verticalPosition,
                 offset: offset)
        present()
    }
    
    // MARK: Creation methods
    
    /// Must be called before the `StatusAlert` presenting
    private func prepare() {
        assertIsMainThread()
        
        isAccessibilityElement = false
        accessibilityTraits = UIAccessibilityTraitNone
        
        let stackView = createStackView()
        
        if let imageView = createImageViewIfPossible() {
            let customSpace: CGFloat
            
            if title != nil && message != nil {
                customSpace = SizesAndDistances.defaultImageBottomSpace
            } else {
                customSpace = SizesAndDistances.defaultTitleBottomSpace
            }
            
            stackView.addArrangedSubview(imageView)
            if #available(iOS 11.0, *) {
                stackView.setCustomSpacing(customSpace, after: imageView)
            } else if title != nil || message != nil {
                let spaceView = createSpaceView(withHeight: customSpace)
                stackView.addArrangedSubview(spaceView)
            }
        }
        
        if let titleLabel = createTitleLabelIfPossible() {
            stackView.addArrangedSubview(titleLabel)
            if #available(iOS 11.0, *) {
                stackView.setCustomSpacing(SizesAndDistances.defaultTitleBottomSpace, after: titleLabel)
            } else if message != nil {
                let spaceView = createSpaceView(withHeight: SizesAndDistances.defaultTitleBottomSpace)
                stackView.addArrangedSubview(spaceView)
            }
        }
        
        if let messageLabel = createMessageLabelIfPossible() {
            stackView.addArrangedSubview(messageLabel)
        }
    }
    
    private func position(inPresenter presenter: UIView,
                          withVerticalPosition verticalPosition: VerticalPosition,
                          offset: CGFloat?) {
        assertIsMainThread()
        
        presenter.addSubview(self)
        
        centerXAnchor
            .constraint(equalTo: presenter.centerXAnchor)
            .isActive = true
        
        switch verticalPosition {
        case .center:
            centerYAnchor
                .constraint(equalTo: presenter.centerYAnchor,
                            constant: offset ?? 0)
                .isActive = true
        case .top:
            if #available(iOS 11, *) {
                topAnchor
                    .constraint(equalTo: presenter.safeAreaLayoutGuide.topAnchor,
                                constant: offset ?? SizesAndDistances.defaultTopOffset)
                    .isActive = true
            } else {
                topAnchor
                    .constraint(equalTo: presenter.topAnchor,
                                constant: offset ?? SizesAndDistances.defaultTopOffset)
                    .isActive = true
            }
        case .bottom:
            if #available(iOS 11, *) {
                bottomAnchor
                    .constraint(equalTo: presenter.safeAreaLayoutGuide.bottomAnchor,
                                constant: offset ?? -SizesAndDistances.defaultBottomOffset)
                    .isActive = true
            } else {
                bottomAnchor
                    .constraint(equalTo: presenter.bottomAnchor,
                                constant: offset ?? -SizesAndDistances.defaultBottomOffset)
                    .isActive = true
            }
        }
    }
    
    private func createStackView() -> UIStackView {
        translatesAutoresizingMaskIntoConstraints = false
        contentView = UIVisualEffectView()
        setupContentView()
        addSubview(contentView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView
            .leadingAnchor
            .constraint(equalTo: leadingAnchor)
            .isActive = true
        contentView
            .trailingAnchor
            .constraint(equalTo: trailingAnchor)
            .isActive = true
        contentView
            .topAnchor
            .constraint(equalTo: topAnchor)
            .isActive = true
        contentView
            .bottomAnchor
            .constraint(equalTo: bottomAnchor)
            .isActive = true
        
        isUserInteractionEnabled = canBePickedOrDismissed
        if canBePickedOrDismissed {
            pickGesture = UILongPressGestureRecognizer(target: self, action: #selector(pick))
            if let gesture = pickGesture {
                contentView.addGestureRecognizer(gesture)
            }
        }
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 0
        
        contentView.contentView.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView
            .leftAnchor
            .constraint(equalTo: contentView.leftAnchor,
                        constant: SizesAndDistances.stackViewSideSpace)
            .isActive = true
        stackView
            .rightAnchor
            .constraint(equalTo: contentView.rightAnchor,
                        constant: -SizesAndDistances.stackViewSideSpace)
            .isActive = true
        stackView
            .bottomAnchor
            .constraint(greaterThanOrEqualTo: contentView.bottomAnchor,
                        constant: -SizesAndDistances.minimumStackViewBottomSpace)
            .isActive = true
        stackView
            .centerXAnchor
            .constraint(equalTo: contentView.centerXAnchor)
            .isActive = true
        
        if image != nil
            && (title != nil || message != nil) {
            contentView
                .heightAnchor
                .constraint(greaterThanOrEqualToConstant: SizesAndDistances.minimumAlertHeight)
                .isActive = true
            contentView
                .widthAnchor
                .constraint(equalToConstant: SizesAndDistances.defaultAlertWidth)
                .isActive = true
            stackView
                .topAnchor
                .constraint(greaterThanOrEqualTo: contentView.topAnchor,
                            constant: SizesAndDistances.minimumStackViewTopSpace)
                .isActive = true
            stackView
                .centerYAnchor
                .constraint(equalTo: contentView.centerYAnchor,
                            constant: (SizesAndDistances.minimumStackViewTopSpace - SizesAndDistances.minimumStackViewBottomSpace) / 2)
                .isActive = true
        } else {
            if image == nil {
                contentView
                    .widthAnchor
                    .constraint(equalToConstant: SizesAndDistances.defaultAlertWidth)
                    .isActive = true
            }
            stackView
                .topAnchor
                .constraint(greaterThanOrEqualTo: contentView.topAnchor,
                            constant: SizesAndDistances.minimumStackViewBottomSpace)
                .isActive = true
            stackView
                .centerYAnchor
                .constraint(equalTo: contentView.centerYAnchor)
                .isActive = true
        }
        return stackView
    }
    
    @objc private func setupContentViewBackground() {
        if isBlurAvailable {
            if #available(iOS 11, *) {
                contentView.effect = blurEffect
            } else if StatusAlert.isPresenting {
                contentView.effect = blurEffect
            }
        } else {
            contentView.backgroundColor = appearance.backgroundColor
        }
    }
    
    private func setupContentView() {
        setupContentViewBackground()
        
        if isBlurAvailable {
            if #available(iOS 11, *) {
                alpha = 0
            } else {
                contentView.contentView.alpha = 0
            }
        } else {
            alpha = 0
        }
        
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = SizesAndDistances.defaultCornerRadius
    }
    
    private func createSpaceView(withHeight height: CGFloat) -> UIView {
        let spaceView = UIView()
        spaceView.backgroundColor = UIColor.clear
        spaceView.translatesAutoresizingMaskIntoConstraints = false
        spaceView
            .heightAnchor
            .constraint(equalToConstant: height)
            .isActive = true
        return spaceView
    }
    
    private func createImageViewIfPossible() -> UIImageView? {
        guard let image = image
            else {
                return nil
        }
        
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = appearance.tintColor
        imageView.isAccessibilityElement = false
        imageView.accessibilityTraits = UIAccessibilityTraitNone
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView
            .widthAnchor
            .constraint(equalTo: imageView.heightAnchor)
            .isActive = true
        imageView
            .widthAnchor
            .constraint(equalToConstant: SizesAndDistances.defaultImageWidth)
            .isActive = true
        
        return imageView
    }
    
    private func createTitleLabelIfPossible() -> UILabel? {
        guard let title = title
            else {
                return nil
        }
        
        let titleLabel = createBaseLabel()
        titleLabel.font = appearance.titleFont
        
        let attributedText = NSAttributedString(
            string: title,
            attributes: [NSKernAttributeName : 0.01])
        titleLabel.attributedText = attributedText
        
        return titleLabel
    }
    
    private func createMessageLabelIfPossible() -> UILabel? {
        guard let message = message
            else {
                return nil
        }
        
        let messageLabel = createBaseLabel()
        messageLabel.font = appearance.messageFont
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 3
        paragraphStyle.alignment = .center
        let attributedText = NSAttributedString(
            string: message,
            attributes: [NSKernAttributeName : 0.01,
                         NSParagraphStyleAttributeName : paragraphStyle])
        messageLabel.attributedText = attributedText
        
        return messageLabel
    }
    
    private func createBaseLabel() -> UILabel {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = appearance.tintColor
        label.isAccessibilityElement = false
        label.accessibilityTraits = UIAccessibilityTraitNone
        return label
    }
    
    // MARK: Presentation methods
    
    private func present() {
        assertIsMainThread()
        
        if !StatusAlert.isPresenting {
            StatusAlert.isPresenting = true
            
            let scale: CGFloat = SizesAndDistances.defaultInitialScale
            timer = Timer.scheduledTimer(
                timeInterval: defaultDisappearTimerTimeInterval - defaultFadeAnimationDuration,
                target: self,
                selector: #selector(dismiss),
                userInfo: nil,
                repeats: false)
            if let timer = timer {
                RunLoop.main.add(timer,
                                 forMode: RunLoopMode.commonModes)
            }
            contentView.transform = CGAffineTransform.identity.scaledBy(x: scale, y: scale)
            
            UIView.animate(
                withDuration: defaultFadeAnimationDuration,
                delay: 0,
                options: UIViewAnimationOptions.curveEaseOut,
                animations: {
                    if self.isBlurAvailable {
                        if #available(iOS 11, *) {
                            self.alpha = 1
                        } else {
                            self.contentView.contentView.alpha = 1
                            self.contentView.effect = self.blurEffect
                        }
                    } else {
                        self.alpha = 1
                    }
                    self.contentView.transform = CGAffineTransform.identity
            },
                completion: { [weak self] (finished) in
                    UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, self?.accessibilityAnnouncement)
            })
        }
    }
    
    @objc private func dismiss() {
        let scale: CGFloat = SizesAndDistances.defaultInitialScale
        timer?.invalidate()
        
        if pickGesture?.state != .changed
            && pickGesture?.state != .began {
            isUserInteractionEnabled = false
            StatusAlert.isPresenting = false
            UIView.animate(
                withDuration: defaultFadeAnimationDuration,
                delay: 0,
                options: UIViewAnimationOptions.curveEaseOut,
                animations: {
                    if self.isBlurAvailable {
                        if #available(iOS 11, *) {
                            self.alpha = 0
                        } else {
                            self.alpha = 0
                            self.contentView.contentView.alpha = 0
                        }
                    } else {
                        self.alpha = 0
                    }
                    self.contentView.transform = CGAffineTransform.identity.scaledBy(x: scale, y: scale)
            },
                completion: { _ in
                    self.removeFromSuperview()
            })
        }
    }
    
    // MARK: Utils
    
    private func assertIsMainThread() {
        precondition(Thread.isMainThread, "`StatusAlert` must only be used from the main thread.")
    }
}

// Compatibility

#if swift(>=4.0)
    private let NSKernAttributeName = NSAttributedStringKey.kern
    private let NSParagraphStyleAttributeName = NSAttributedStringKey.paragraphStyle
#endif
