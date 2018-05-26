//
//  StatusAlert
//  Copyright © 2017-2018 Yegor Miroshnichenko. Licensed under the MIT license.
//

import UIKit

@objc public final class StatusAlert: UIView {
    
    // MARK: - Public fields -
    
    /// - Note: Do not change to save system look
    /// - Note: Changes while showing will have no effect
    @objc public var appearance: Appearance = Appearance.copyCommon()
    
    /// - Note: Do not change to save system look
    /// - Note: Changes while showing will have no effect
    @objc public var sizesAndDistances: SizesAndDistances = SizesAndDistances.copyCommon()
    
    /// Announced to VoiceOver when the alert gets presented
    @objc public var accessibilityAnnouncement: String? = nil
    
    /// How long StatusAlert should be on screen.
    ///
    /// - Note: This time should include fade animation duration (which is `UINavigationControllerHideShowBarDuration`)
    /// - Note: Changes while showing will have no effect
    @objc public var alertShowingDuration: TimeInterval = 2
    
    /// If multiple alerts can be on screen at once
    @objc public static var shouldShowMultipleAlertsSimultaneously: Bool = false
    
    // MARK: - Private fields -
    
    /// Used to present only one `StatusAlert` at once if `shouldShowMultipleAlertsSimultaneously` is `false`
    private static var isPresenting: Bool = false
    
    private let defaultFadeAnimationDuration: TimeInterval = TimeInterval(UINavigationControllerHideShowBarDuration)
    private let blurEffect: UIBlurEffect = UIBlurEffect(style: .light)
    
    /// @1x should be 90*90 by default
    private var image: UIImage?
    private var title: String?
    private var message: String?
    
    private var contentView: UIVisualEffectView!
    
    private var timer: Timer?
    
        if !StatusAlert.shouldShowMultipleAlertsSimultaneously
            && StatusAlert.isPresenting {
    /// Determines whether `StatusAlert` can be shown
    private var canBeShown: Bool {
            return false
        }
        if self.image == nil,
            self.title == nil,
            self.message == nil {
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
            self.pickGesture?.allowableMovement = CGFloat.greatestFiniteMagnitude
            self.pickGesture?.minimumPressDuration = 0
            self.pickGesture?.cancelsTouchesInView = true
        }
    }
    
    // MARK: - Interaction methods
    
    @objc private func pick() {
        guard self.canBePickedOrDismissed
            else {
                return
        }
        if self.pickGesture?.state == .cancelled
            || self.pickGesture?.state == .ended
            || self.pickGesture?.state == .failed {

            self.dismiss(completion: nil)
        }
    }
    
    // MARK: - Static methods -
    
    /// Instantiates `StatusAlert`
    ///
    /// - Parameters:
    ///   - image: @1x should be 90*90 by default, optional
    ///   - title: displayed beyond image
    ///   - message: displayed beyond title or
    ///   - canBePickedOrDismissed: determines wether StatusAlert can be picked or dismissed by tap
    /// - Returns: `StatusAlert` instance
    @objc(statusAlertWithImage:title:message:canBePickedOrDismissed:)
    public static func instantiate(
        withImage image: UIImage?,
        title: String?,
        message: String?,
        canBePickedOrDismissed: Bool = false
        ) -> StatusAlert {
        
        let statusAlert = StatusAlert()
        
        NotificationCenter.default.addObserver(
            statusAlert,
            selector: #selector(statusAlert.reduceTransparencyStatusDidChange),
            name: NSNotification.Name.UIAccessibilityReduceTransparencyStatusDidChange,
            object: nil
        )
        
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
        self.show()
    }
    
    /// Shows `StatusAlert` in the center of `presenter`
    ///
    /// - Parameters:
    ///   - presenter: view present `StatusAlert` in
    /// - Note: must be called from the main thread only
    @objc(showInView:)
    public func show(in presenter: UIView) {

        self.show(inPresenter: presenter)
    }
    
    /// Shows `StatusAlert` in `keyWindow`
    ///
    /// - Parameters:
    ///   - verticalPosition: `StatusAlert` position in `keyWindow`
    /// - Note: must be called from the main thread only
    @objc(showWithVerticalPosition:)
    public func show(withVerticalPosition verticalPosition: VerticalPosition) {

        self.show(with: verticalPosition, offset: 0)
    }
    
    /// Shows `StatusAlert` in the center of `keyWindow` with `offset`
    ///
    /// - Parameters:
    ///   - offset: offset from center of `keyWindow`
    /// - Note: must be called from the main thread only
    @objc(showWithOffset:)
    public func show(withOffset offset: CGFloat) {
        self.show(offset: offset)
    }
    
    /// Shows `StatusAlert` in `presenter`
    ///
    /// - Parameters:
    ///   - presenter: view present `StatusAlert` in
    ///   - verticalPosition: `StatusAlert` position in `presenter`
    /// - Note: must be called from the main thread only
    @objc(showInView:withVerticalPosition:)
    public func show(
        in presenter: UIView,
        withVerticalPosition verticalPosition: VerticalPosition
        ) {
        
        self.show(inPresenter: presenter, with: verticalPosition)
    }
    
    /// Shows `StatusAlert` in the center of `presenter`
    ///
    /// - Parameters:
    ///   - presenter: view present `StatusAlert` in
    ///   - offset: offset from center in `presenter`
    /// - Note: must be called from the main thread only
    @objc(showInView:withOffset:)
    public func show(
        in presenter: UIView,
        withOffset offset: CGFloat
        ) {
        
        self.show(inPresenter: presenter, offset: offset)
    }
    
    /// Shows `StatusAlert` in `keyWindow`
    ///
    /// - Parameters:
    ///   - verticalPosition: `StatusAlert` position in `keyWindow`
    ///   - offset: offset for `verticalPosition` in `keyWindow`
    /// - Note: must be called from the main thread only
    @objc(showWithVerticalPosition:offset:)
    public func show(
        withVerticalPosition verticalPosition: VerticalPosition,
        offset: CGFloat
        ) {
        
        self.show(with: verticalPosition, offset: offset)
    }
    
    /// Shows `StatusAlert` in `presenter`
    ///
    /// - Parameters:
    ///   - presenter: view present `StatusAlert` in
    ///   - verticalPosition: `StatusAlert` position in `presenter`
    ///   - offset: offset for `verticalPosition` in `presenter`. To use default offset see the same method but without offset parameter.
    /// - Note: must be called from the main thread only
    @objc(showInView:withVerticalPosition:offset:)
    public func show(
        in presenter: UIView,
        withVerticalPosition verticalPosition: VerticalPosition,
        offset: CGFloat
        ) {
        
        self.show(
            inPresenter: presenter,
            with: verticalPosition,
            offset: offset
        )
    }
    
    // MARK: - Private methods -
    
    private func show(
        inPresenter presenter: UIView = UIApplication.shared.keyWindow ?? UIView(),
        with verticalPosition: VerticalPosition = .center,
        offset: CGFloat? = nil
        ) {
        
        guard self.canBeShown
            else {
                return
        }
        self.prepare()
        self.position(
            inPresenter: presenter,
            withVerticalPosition: verticalPosition,
            offset: offset
        )
        self.present()
    }
    
    // MARK: Creation methods
    
    /// Must be called before the `StatusAlert` presenting
    private func prepare() {
        self.assertIsMainThread()
        
        self.isAccessibilityElement = false
        self.accessibilityElementsHidden = true
        self.accessibilityTraits = UIAccessibilityTraitNone
        
        let stackView = self.createStackView()
        
        if let imageView = self.createImageViewIfPossible() {
            let customSpace: CGFloat
            
            if self.title != nil && self.message != nil {
                customSpace = self.sizesAndDistances.defaultImageBottomSpace
            } else if self.title == nil {
                customSpace = self.sizesAndDistances.defaultImageToMessageSpace
            } else {
                customSpace = self.sizesAndDistances.defaultTitleBottomSpace
            }
            
            stackView.addArrangedSubview(imageView)
            if #available(iOS 11.0, *) {
                stackView.setCustomSpacing(customSpace, after: imageView)
            } else if self.title != nil || self.message != nil {
                let spaceView = self.createSpaceView(withHeight: customSpace)
                stackView.addArrangedSubview(spaceView)
            }
        }
        
        if let titleLabel = self.createTitleLabelIfPossible() {
            stackView.addArrangedSubview(titleLabel)
            if #available(iOS 11.0, *) {
                stackView.setCustomSpacing(self.sizesAndDistances.defaultTitleBottomSpace, after: titleLabel)
            } else if self.message != nil {
                let spaceView = self.createSpaceView(withHeight: self.sizesAndDistances.defaultTitleBottomSpace)
                stackView.addArrangedSubview(spaceView)
            }
        }
        
        if let messageLabel = self.createMessageLabelIfPossible() {
            stackView.addArrangedSubview(messageLabel)
        }
    }
    
    private func position(
        inPresenter presenter: UIView,
        withVerticalPosition verticalPosition: VerticalPosition,
        offset: CGFloat?
        ) {
        
        self.assertIsMainThread()
        
        presenter.addSubview(self)
        
        self.centerXAnchor.constraint(equalTo: presenter.centerXAnchor).isActive = true
        
        switch verticalPosition {
        case .center:
            self.centerYAnchor.constraint(
                equalTo: presenter.centerYAnchor,
                constant: offset ?? 0
                ).isActive = true
        case .top:
            if #available(iOS 11, *) {
                self.topAnchor.constraint(
                    equalTo: presenter.safeAreaLayoutGuide.topAnchor,
                    constant: offset ?? self.sizesAndDistances.defaultTopOffset
                    ).isActive = true
            } else {
                self.topAnchor.constraint(
                    equalTo: presenter.topAnchor,
                    constant: offset ?? self.sizesAndDistances.defaultTopOffset
                    ).isActive = true
            }
        case .bottom:
            if #available(iOS 11, *) {
                self.bottomAnchor.constraint(
                    equalTo: presenter.safeAreaLayoutGuide.bottomAnchor,
                    constant: offset ?? -self.sizesAndDistances.defaultBottomOffset
                    ).isActive = true
            } else {
                self.bottomAnchor.constraint(
                    equalTo: presenter.bottomAnchor,
                    constant: offset ?? -self.sizesAndDistances.defaultBottomOffset
                    ).isActive = true
            }
        }
    }
    
    private func createStackView() -> UIStackView {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.contentView = UIVisualEffectView()
        self.setupContentView()
        self.addSubview(self.contentView)
        
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.contentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        self.isUserInteractionEnabled = self.canBePickedOrDismissed
        if self.canBePickedOrDismissed {
            self.pickGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.pick))
            if let gesture = self.pickGesture {
                self.contentView.addGestureRecognizer(gesture)
            }
        }
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 0
        
        self.contentView.contentView.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leftAnchor.constraint(
            equalTo: self.contentView.leftAnchor,
            constant: self.sizesAndDistances.stackViewSideSpace
            ).isActive = true
        stackView.rightAnchor.constraint(
            equalTo: self.contentView.rightAnchor,
            constant: -self.sizesAndDistances.stackViewSideSpace
            ).isActive = true
        stackView.bottomAnchor.constraint(
            greaterThanOrEqualTo: self.contentView.bottomAnchor,
            constant: -self.sizesAndDistances.minimumStackViewBottomSpace
            ).isActive = true
        stackView.centerXAnchor.constraint(
            equalTo: self.contentView.centerXAnchor
            ).isActive = true
        
        if self.image != nil
            && (self.title != nil || self.message != nil) {
            self.contentView.heightAnchor.constraint(
                greaterThanOrEqualToConstant: self.sizesAndDistances.minimumAlertHeight
                ).isActive = true
            self.contentView.widthAnchor.constraint(
                equalToConstant: self.sizesAndDistances.defaultAlertWidth
                ).isActive = true
            stackView.topAnchor.constraint(
                greaterThanOrEqualTo: self.contentView.topAnchor,
                constant: self.sizesAndDistances.minimumStackViewTopSpace
                ).isActive = true
            stackView.centerYAnchor.constraint(
                equalTo: self.contentView.centerYAnchor,
                constant: (self.sizesAndDistances.minimumStackViewTopSpace - self.sizesAndDistances.minimumStackViewBottomSpace) / 2
                ).isActive = true
        } else {
            if self.image == nil {
                self.contentView.widthAnchor.constraint(
                    equalToConstant: self.sizesAndDistances.defaultAlertWidth
                    ).isActive = true
            }
            stackView.topAnchor.constraint(
                greaterThanOrEqualTo: self.contentView.topAnchor,
                constant: self.sizesAndDistances.minimumStackViewBottomSpace
                ).isActive = true
            stackView.centerYAnchor.constraint(
                equalTo: self.contentView.centerYAnchor
                ).isActive = true
        }
        return stackView
    }

    @objc private func reduceTransparencyStatusDidChange() {
        self.setupContentViewBackground()
    }
    
    private func setupContentViewBackground() {
        if self.isBlurAvailable {
            self.contentView.backgroundColor = nil
            if #available(iOS 11, *) {
                self.contentView.effect = self.blurEffect
            } else if StatusAlert.currentlyPresentedStatusAlerts.contains(self) {
                self.contentView.effect = self.blurEffect
            }
        } else {
            self.contentView.effect = nil
            self.contentView.backgroundColor = self.appearance.backgroundColor
        }
    }
    
    private func setupContentView() {
        self.setupContentViewBackground()
        
        if self.isBlurAvailable {
            if #available(iOS 11, *) {
                self.alpha = 0
            } else {
                self.contentView.contentView.alpha = 0
            }
        } else {
            self.alpha = 0
        }
        
        self.contentView.clipsToBounds = true
        self.contentView.layer.cornerRadius = self.sizesAndDistances.defaultCornerRadius
    }
    
    private func createSpaceView(
        withHeight height: CGFloat
        ) -> UIView {

        let spaceView = UIView()
        spaceView.backgroundColor = UIColor.clear
        spaceView.translatesAutoresizingMaskIntoConstraints = false
        spaceView.heightAnchor.constraint(equalToConstant: height).isActive = true
        return spaceView
    }
    
    private func createImageViewIfPossible() -> UIImageView? {
        guard let image = self.image
            else {
                return nil
        }
        
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = self.appearance.tintColor
        imageView.isAccessibilityElement = false
        imageView.accessibilityTraits = UIAccessibilityTraitNone
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: sizesAndDistances.defaultImageWidth).isActive = true
        
        return imageView
    }
    
    private func createTitleLabelIfPossible() -> UILabel? {
        guard let title = self.title
            else {
                return nil
        }
        
        let titleLabel = self.createBaseLabel()
        titleLabel.font = self.appearance.titleFont
        
        let attributedText = NSAttributedString(
            string: title,
            attributes: [NSKernAttributeName : 0.01])
        titleLabel.attributedText = attributedText
        
        return titleLabel
    }
    
    private func createMessageLabelIfPossible() -> UILabel? {
        guard let message = self.message
            else {
                return nil
        }
        
        let messageLabel = self.createBaseLabel()
        messageLabel.font = self.appearance.messageFont
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 3
        paragraphStyle.alignment = .center
        let attributedText = NSAttributedString(
            string: message,
            attributes: [
                NSKernAttributeName : 0.01,
                NSParagraphStyleAttributeName : paragraphStyle])
        messageLabel.attributedText = attributedText
        
        return messageLabel
    }
    
    private func createBaseLabel() -> UILabel {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = self.appearance.tintColor
        label.isAccessibilityElement = false
        label.accessibilityTraits = UIAccessibilityTraitNone
        return label
    }
    
    // MARK: Presentation methods
    
    private func present() {
        assertIsMainThread()
        
        if canBeShowed {
            StatusAlert.isPresenting = true
            
            let scale: CGFloat = sizesAndDistances.defaultInitialScale
            timer = Timer.scheduledTimer(
                timeInterval: alertShowingDuration - defaultFadeAnimationDuration,
                target: self,
                selector: #selector(dismiss),
                userInfo: nil,
                repeats: false)
            if let timer = timer {
                RunLoop.main.add(
                    timer,
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
        let scale: CGFloat = sizesAndDistances.defaultInitialScale
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
