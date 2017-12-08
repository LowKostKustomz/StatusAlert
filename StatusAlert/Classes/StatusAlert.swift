//
//  StatusAlert
//  Copyright © 2017 Yegor Miroshnichenko. Licensed under the MIT license.
//

import UIKit

public class StatusAlert: UIView {
    
    // MARK: - Public fields -
    
    /// - Note: Do not change to save system look
    /// - Note: Changes while showing will have no effect
    public var titleFont: UIFont = Appearance.titleFont {
        didSet {
            isPrepared = false
        }
    }
    
    /// - Note: Do not change to save system look
    /// - Note: Changes while showing will have no effect
    public var messageFont: UIFont = Appearance.messageFont {
        didSet {
            isPrepared = false
        }
    }
    
    /// - Note: Do not change to save system look
    /// - Note: Changes while showing will have no effect
    public var contentColor: UIColor = Appearance.contentColor {
        didSet {
            isPrepared = false
        }
    }
    
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
    
    private var isPrepared: Bool = false
    
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
    public static func instantiate(withImage image: UIImage?,
                                   title: String?,
                                   message: String?,
                                   canBePickedOrDismissed: Bool = false) -> StatusAlert {
        let statusAlert = StatusAlert()
        
        statusAlert.image = image
        statusAlert.title = title
        statusAlert.message = message
        statusAlert.canBePickedOrDismissed = canBePickedOrDismissed
        
        return statusAlert
    }
    
    // MARK: - Public methods -
    
    /// Must be called before the `StatusAlert` presenting
    public func prepare() {
        assertIsMainThread()
        
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
        
        isPrepared = true
    }
    
    /// Shows `StatusAlert` in `presenter`
    ///
    /// - Parameters:
    ///   - presenter: view present `StatusAlert` in
    ///   - verticalPosition: `StatusAlert` position in `presenter`
    public func show(in presenter: UIView = UIApplication.shared.keyWindow ?? UIView(),
                     withVerticalPosition verticalPosition: VerticalPosition = .center(offset: nil)) {
        guard canBeShowed
            else {
                return
        }
        position(inPresenter: presenter,
                 withVerticalPosition: verticalPosition)
        present()
    }
    
    // MARK: - Private methods -
    
    // MARK: Creation methods
    
    private func position(inPresenter presenter: UIView,
                          withVerticalPosition verticalPosition: VerticalPosition) {
        assertIsMainThread()
        
        presenter.addSubview(self)
        
        centerXAnchor
            .constraint(equalTo: presenter.centerXAnchor)
            .isActive = true
        
        switch verticalPosition {
        case .center(let offset):
            centerYAnchor
                .constraint(equalTo: presenter.centerYAnchor,
                            constant: offset ?? 0)
                .isActive = true
        case .top(let offset):
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
        case .bottom(let offset):
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
        if #available(iOS 11, *) {
            contentView.effect = blurEffect
            alpha = 0
        } else {
            contentView.contentView.alpha = 0
        }
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = SizesAndDistances.defaultCornerRadius
        addSubview(contentView)
        
        contentView
            .translatesAutoresizingMaskIntoConstraints = false
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
            pickGesture = UILongPressGestureRecognizer(target: self,
                                                       action: #selector(pick))
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
        
        stackView
            .translatesAutoresizingMaskIntoConstraints = false
        stackView
            .leftAnchor
            .constraint(equalTo: contentView.leftAnchor, constant: SizesAndDistances.stackViewSideSpace)
            .isActive = true
        stackView
            .rightAnchor
            .constraint(equalTo: contentView.rightAnchor, constant: -SizesAndDistances.stackViewSideSpace)
            .isActive = true
        stackView
            .bottomAnchor
            .constraint(greaterThanOrEqualTo: contentView.bottomAnchor, constant: -SizesAndDistances.minimumStackViewBottomSpace)
            .isActive = true
        stackView
            .centerXAnchor
            .constraint(equalTo: contentView.centerXAnchor)
            .isActive = true
        
        if image != nil
            && (title != nil
                || message != nil) {
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
                .constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: SizesAndDistances.minimumStackViewTopSpace)
                .isActive = true
            stackView
                .centerYAnchor
                .constraint(equalTo: contentView.centerYAnchor, constant: (SizesAndDistances.minimumStackViewTopSpace - SizesAndDistances.minimumStackViewBottomSpace) / 2)
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
                .constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: SizesAndDistances.minimumStackViewBottomSpace)
                .isActive = true
            stackView
                .centerYAnchor
                .constraint(equalTo: contentView.centerYAnchor)
                .isActive = true
        }
        return stackView
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
        imageView.tintColor = contentColor
        
        imageView
            .translatesAutoresizingMaskIntoConstraints = false
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
        titleLabel.font = titleFont
        
        let attributedText = NSAttributedString(string: title,
                                                attributes: [NSAttributedStringKey.kern : 0.01])
        titleLabel.attributedText = attributedText
        
        return titleLabel
    }
    
    private func createMessageLabelIfPossible() -> UILabel? {
        guard let message = message
            else {
                return nil
        }
        
        let messageLabel = createBaseLabel()
        messageLabel.font = messageFont
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 3
        paragraphStyle.alignment = .center
        let attributedText = NSAttributedString(string: message,
                                                attributes: [NSAttributedStringKey.kern : 0.01,
                                                             NSAttributedStringKey.paragraphStyle : paragraphStyle])
        messageLabel.attributedText = attributedText
        
        return messageLabel
    }
    
    private func createBaseLabel() -> UILabel {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = contentColor
        return label
    }
    
    // MARK: Presentation methods
    
    private func present() {
        assertIsMainThread()
        assertIsPrepared()
        
        if !StatusAlert.isPresenting {
            StatusAlert.isPresenting = true
            
            let scale: CGFloat = SizesAndDistances.defaultInitialScale
            timer = Timer
                .scheduledTimer(
                    timeInterval: defaultDisappearTimerTimeInterval - defaultFadeAnimationDuration,
                    target: self,
                    selector: #selector(dismiss),
                    userInfo: nil,
                    repeats: false)
            if let timer = timer {
                RunLoop
                    .main
                    .add(timer,
                         forMode: RunLoopMode.commonModes)
            }
            contentView.transform = CGAffineTransform.identity.scaledBy(x: scale, y: scale)
            
            UIView
                .animate(
                    withDuration: defaultFadeAnimationDuration,
                    delay: 0,
                    options: UIViewAnimationOptions.curveEaseOut,
                    animations: {
                        if #available(iOS 11, *) {
                            self.alpha = 1
                        } else {
                            self.contentView.contentView.alpha = 1
                            self.contentView.effect = self.blurEffect
                        }
                        self.contentView.transform = CGAffineTransform.identity
                },
                    completion: nil)
        }
    }
    
    @objc private func dismiss() {
        let scale: CGFloat = SizesAndDistances.defaultInitialScale
        timer?.invalidate()
        
        if pickGesture?.state != .changed
            && pickGesture?.state != .began {
            isUserInteractionEnabled = false
            StatusAlert.isPresenting = false
            UIView
                .animate(
                    withDuration: defaultFadeAnimationDuration,
                    delay: 0,
                    options: UIViewAnimationOptions.curveEaseOut,
                    animations: {
                        if #available(iOS 11, *) {
                            self.alpha = 0
                        } else {
                            self.alpha = 0
                            self.contentView.contentView.alpha = 0
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
    
    private func assertIsPrepared() {
        precondition(isPrepared, "You must call the `prepare` function before presenting the `StatusAlert`.")
    }
}
