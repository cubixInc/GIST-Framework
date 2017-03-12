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

    
    /// Makes font with SyncEngine fontStyle, keeping fontName key be 'default font'
    ///
    /// - Parameters:
    ///   - fontStyle: Font Style/Size key from SyncEngine
    ///   - sizedForIPad: Flag for font sized for iPad
    /// - Returns: UIFont instance using SyncEngine params
    public class func font(_ fontStyle:String?, sizedForIPad:Bool = false) ->UIFont! {
        return self.font(GIST_GLOBAL.fontName, fontStyle: fontStyle, sizedForIPad:sizedForIPad);
    } //F.E.
    
    /// Makes font with SyncEngine fontNameKey, fontStyle
    ///
    /// - Parameters:
    ///   - fontNameKey: Font Name key from SyncEngine
    ///   - fontStyle: Font Style/Size key from SyncEngine
    ///   - sizedForIPad: Flag for font sized for iPad
    /// - Returns: UIFont instance using SyncEngine params
    public class func font(_ fontNameKey:String?, fontStyle:String?, sizedForIPad:Bool = false) ->UIFont! {
        let newValue:CGFloat = CGFloat(SyncedFontStyles.style(forKey: fontStyle ?? GIST_GLOBAL.fontStyle));
        
        return UIFont(name: SyncedConstants.constant(forKey: fontNameKey) ?? "Helvetica Neue", size: GISTUtility.convertToRatio(newValue, sizedForIPad:sizedForIPad));
    } //F.E.
    
} //CLS END
