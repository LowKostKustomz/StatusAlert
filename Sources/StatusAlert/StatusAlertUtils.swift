//
//  StatusAlert
//  Copyright © 2017-2018 Yegor Miroshnichenko. Licensed under the MIT license.
//

import UIKit

@objc extension StatusAlert {
    
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
        /// - Note: Do not change to save system look
        @objc public var backgroundColor: UIColor = UIColor.groupTableViewBackground
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
    
    enum SizesAndDistances {
        static let defaultInitialScale: CGFloat = 0.9
        static let defaultCornerRadius: CGFloat = 10
        
        static let defaultTopOffset: CGFloat = 32
        static let defaultBottomOffset: CGFloat = 32
        
        static let defaultImageWidth: CGFloat = 90
        static let defaultAlertWidth: CGFloat = 258
        static let minimumAlertHeight: CGFloat = 240
        
        static let minimumStackViewTopSpace: CGFloat = 44
        static let minimumStackViewBottomSpace: CGFloat = 24
        static let stackViewSideSpace: CGFloat = 24
        
        static let defaultImageBottomSpace: CGFloat = 30
        static let defaultTitleBottomSpace: CGFloat = 5
    }
}

// Compatibility

#if swift(>=4.0)
    private let UIFontWeightSemibold = UIFont.Weight.semibold
    private let UIFontWeightRegular = UIFont.Weight.regular
#endif
