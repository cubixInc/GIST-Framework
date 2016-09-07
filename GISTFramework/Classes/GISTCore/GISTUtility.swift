//
//  GISTUtility.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 07/09/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit

public func delay(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
} //F.E.

public class Weak<T: AnyObject> {
    weak var value : T?
    init (value: T) {
        self.value = value
    }
} //CLS END

public class GISTUtility: NSObject {
    @nonobjc static let deviceRatio:CGFloat = UIScreen.mainScreen().bounds.height / 736.0;
    @nonobjc static let deviceRatioWN:CGFloat = (UIScreen.mainScreen().bounds.height - 64.0) / (736.0 - 64.0); // Ratio with Navigation
    
    @nonobjc public static let isIPad:Bool = UIDevice.currentDevice().userInterfaceIdiom == .Pad;
    
    public class func convertToRatioSizedForNavi(value:CGFloat) ->CGFloat {
        return self.convertToRatio(value, sizedForIPad: false, sizedForNavi:true); // Explicit true for Sized For Navi
    } //F.E.
    
    public class func convertToRatio(value:CGFloat, sizedForIPad:Bool = false, sizedForNavi:Bool = false) ->CGFloat {
        /*
         iPhone6 Hight:667   =====  0.90625
         iPhone5 Hight:568  ====== 0.77173913043478
         iPhone4S Hight:480
         iPAd Hight:1024 ===== 1.39130434782609
         //--
         (height/736.0)
         */
        //--
        //??let rRatio = UIScreen.mainScreen().bounds.height / 736.0;
        
        if (GISTUtility.isIPad && !sizedForIPad) {
            return value;
        }
        
        if (sizedForNavi) {
            return value * GISTUtility.deviceRatioWN; // With Navigation
        }
        
        return value * GISTUtility.deviceRatio;
    } //F.E.
    
    public class func convertFontSizeToRatio(value:CGFloat, fontStyle:String?, sizedForIPad:Bool = false) ->CGFloat {
        if (fontStyle == nil)
        {return GISTUtility.convertToRatio(value, sizedForIPad: sizedForIPad);}
        //--
        let newValue:CGFloat = CGFloat(SyncedFontStyles.style(forKey: fontStyle!));
        //--
        return GISTUtility.convertToRatio(newValue, sizedForIPad: sizedForIPad);
    } //F.E.
    
    public class func convertPointToRatio(value:CGPoint, sizedForIPad:Bool = false) ->CGPoint {
        return CGPoint(x:self.convertToRatio(value.x, sizedForIPad: sizedForIPad), y:self.convertToRatio(value.y, sizedForIPad: sizedForIPad));
    } //F.E.
    
    public class func convertSizeToRatio(value:CGSize, sizedForIPad:Bool = false) ->CGSize {
        return CGSize(width:self.convertToRatio(value.width, sizedForIPad: sizedForIPad), height:self.convertToRatio(value.height, sizedForIPad: sizedForIPad));
    } //F.E.

} //CLS END
