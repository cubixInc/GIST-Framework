//
//  UIFont+Utility.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 27/07/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit

public extension UIFont {
// public class func 
    
    public class func font(fontStyle:String? = nil, sizedForIPad:Bool = false) ->UIFont! {
        return self.font("fontRegular", fontStyle: fontStyle, sizedForIPad:sizedForIPad);
    } //F.E.
    
    public class func font(fontNameKey:String?, fontStyle:String?, sizedForIPad:Bool = false) ->UIFont! {
        return UIFont(name: SyncedConstants.constant(forKey: fontNameKey) ?? "Helvetica Neue", size: GISTUtility.convertFontSizeToRatio(22, fontStyle: fontStyle ?? "medium", sizedForIPad:sizedForIPad));
    } //F.E.
    
} //CLS END
