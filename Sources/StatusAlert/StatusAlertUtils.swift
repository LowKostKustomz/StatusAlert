//
//  StatusAlert
//  Copyright © 2017-2018 Yegor Miroshnichenko. Licensed under the MIT license.
//

import UIKit

@objc extension StatusAlert {

    @objc(StatusAlertMultiplePresentationsBehavior)
    public enum MultiplePresentationsBehavior: Int {

        /// Not more than one StatusAlert will be shown at once
        case ignoreIfAlreadyPresenting

        /// Currently presented StatusAlerts will be dismissed before presenting another one
        case dismissCurrentlyPresented

        /// All requested StatusAlerts will be shown
        case showMultiple
    }
    
    @objc(StatusAlertAppearance)
    public final class Appearance: NSObject {
        
        @objc public static let common: Appearance = Appearance()
        
        /// - Note: Do not change to save system look
        @objc public var titleFont: UIFont = UIFont.systemFont(ofSize: 23, weight: UIFontWeightSemibold)
        
        /// - Note: Do not change to save system look
        @objc public var messageFont: UIFont = UIFont.systemFont(ofSize: 16, weight: UIFontWeightRegular)
        
        /// - Note: Do not change to save system look
        @objc public var tintColor: UIColor = UIColor.darkGray
        
        /// Used if device does not support blur or if `Reduce Transparency` toggle
        /// in `General->Accessibility->Increase Contrast` is on
        ///
        /// - Note: Do not change to save system look
        @objc public var backgroundColor: UIColor = UIColor.groupTableViewBackground
        
        @objc public static func copyCommon() -> Appearance {
            let common = Appearance.common
            let copy = Appearance()
            copy.titleFont          = common.titleFont
            copy.messageFont        = common.messageFont
            copy.tintColor          = common.tintColor
            copy.backgroundColor    = common.backgroundColor
            return copy
        }
    }
    
    @objc(StatusAlertVerticalPosition)
    public enum VerticalPosition: Int {
        
        /// Position in the center of the view
        case center
        
        /// Position on the top of the view
        case top
        
        /// Position at the bottom of the view
        case bottom
    }
    
    @objc (StatusAlertSizesAndDistances)
    public final class SizesAndDistances: NSObject {
        
        @objc public static let common: SizesAndDistances = SizesAndDistances()
        
        @objc public var defaultInitialScale: CGFloat = 0.9
        @objc public var defaultCornerRadius: CGFloat = 10
        
        @objc public var defaultTopOffset: CGFloat = 32
        @objc public var defaultBottomOffset: CGFloat = 32
        
        @objc public var defaultImageWidth: CGFloat = 90
        @objc public var defaultAlertWidth: CGFloat = 258
        @objc public var minimumAlertHeight: CGFloat = 240
        
        @objc public var minimumStackViewTopSpace: CGFloat = 44
        @objc public var minimumStackViewBottomSpace: CGFloat = 24
        @objc public var stackViewSideSpace: CGFloat = 24
        
        @objc public var defaultImageBottomSpace: CGFloat = 30
        @objc public var defaultTitleBottomSpace: CGFloat = 5
        @objc public var defaultImageToMessageSpace: CGFloat = 24
        
        @objc public static func copyCommon() -> SizesAndDistances {
            let common = SizesAndDistances.common
            let copy = SizesAndDistances()
            
            copy.defaultInitialScale            = common.defaultInitialScale
            copy.defaultCornerRadius            = common.defaultCornerRadius
            copy.defaultTopOffset               = common.defaultTopOffset
            copy.defaultBottomOffset            = common.defaultBottomOffset
            copy.defaultImageWidth              = common.defaultImageWidth
            copy.defaultAlertWidth              = common.defaultAlertWidth
            copy.minimumAlertHeight             = common.minimumAlertHeight
            copy.minimumStackViewTopSpace       = common.minimumStackViewTopSpace
            copy.minimumStackViewBottomSpace    = common.minimumStackViewBottomSpace
            copy.stackViewSideSpace             = common.stackViewSideSpace
            copy.defaultImageBottomSpace        = common.defaultImageBottomSpace
            copy.defaultTitleBottomSpace        = common.defaultTitleBottomSpace
            copy.defaultImageToMessageSpace     = common.defaultImageToMessageSpace
            return copy
        }
    }
}

// Compatibility

#if swift(>=4.0)
    private let UIFontWeightSemibold = UIFont.Weight.semibold
    private let UIFontWeightRegular = UIFont.Weight.regular
#endif
