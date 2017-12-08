//
//  StatusAlert
//  Copyright © 2017 Yegor Miroshnichenko. Licensed under the MIT license.
//

import Foundation

extension StatusAlert {
    public enum Appearance {
        /// - Note: Do not change to save system look
        public static var titleFont: UIFont = UIFont.systemFont(ofSize: 22, weight: UIFont.Weight.semibold)
        
        /// - Note: Do not change to save system look
        public static var messageFont: UIFont = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.regular)
        
        /// - Note: Do not change to save system look
        public static var contentColor: UIColor = UIColor.darkGray
    }
    
    public enum VerticalPosition {
        case center(offset: CGFloat?)
        case top(offset: CGFloat?)
        case bottom(offset: CGFloat?)
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
