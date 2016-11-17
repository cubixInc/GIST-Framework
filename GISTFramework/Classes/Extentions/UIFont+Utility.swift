//
//  UIFont+Utility.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 27/07/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit

// MARK: - UIFont Utility Extension
public extension UIFont {

    
    /// Makes font with SyncEngine fontStyle, keeping fontName key be 'fontRegular'
    ///
    /// - Parameters:
    ///   - fontStyle: Font Style/Size key from SyncEngine
    ///   - sizedForIPad: Flag for font sized for iPad
    /// - Returns: UIFont instance using SyncEngine params
    public class func font(_ fontStyle:String? = nil, sizedForIPad:Bool = false) ->UIFont! {
        return self.font("fontRegular", fontStyle: fontStyle, sizedForIPad:sizedForIPad);
    } //F.E.
    
    /// Makes font with SyncEngine fontNameKey, fontStyle
    ///
    /// - Parameters:
    ///   - fontNameKey: Font Name key from SyncEngine
    ///   - fontStyle: Font Style/Size key from SyncEngine
    ///   - sizedForIPad: Flag for font sized for iPad
    /// - Returns: UIFont instance using SyncEngine params
    public class func font(_ fontNameKey:String?, fontStyle:String?, sizedForIPad:Bool = false) ->UIFont! {
        return UIFont(name: SyncedConstants.constant(forKey: fontNameKey) ?? "Helvetica Neue", size: GISTUtility.convertFontSizeToRatio(22, fontStyle: fontStyle ?? "medium", sizedForIPad:sizedForIPad));
    } //F.E.
    
} //CLS END
