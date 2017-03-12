//
//  GISTUtility.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 07/09/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit

/// Class for Utility methods.
open class GISTUtility: NSObject {
    
    //MARK: - Properties
    
    @nonobjc static let deviceRatio:CGFloat = UIScreen.main.bounds.height / 736.0;
    @nonobjc static let deviceRatioWN:CGFloat = (UIScreen.main.bounds.height - 64.0) / (736.0 - 64.0); // Ratio with Navigation
    
    /// Bool flag for device type.
    @nonobjc open static let isIPad:Bool = UIDevice.current.userInterfaceIdiom == .pad;
    
    //MARK: - Methods
    
    /// Function to delay a particular action.
    ///
    /// - Parameters:
    ///   - delay: Delay Time in double.
    ///   - closure: Closure to call after delay.
    public class func delay(_ delay:Double, closure:@escaping () -> Void) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    } //F.E.
    
    /// Converts value to (value * device ratio) considering navigtion bar fixed height.
    ///
    /// - Parameter value: Value
    /// - Returns: Device specific ratio * value
    open class func convertToRatioSizedForNavi(_ value:CGFloat) ->CGFloat {
        return self.convertToRatio(value, sizedForIPad: false, sizedForNavi:true); // Explicit true for Sized For Navi
    } //F.E.
    
    
    /// Converts value to (value * device ratio).
    ///
    /// - Parameters:
    ///   - value: Value
    ///   - sizedForIPad: Bool flag for sizedForIPad
    ///   - sizedForNavi: Bool flag for sizedForNavi
    /// - Returns: Device specific ratio * value
    open class func convertToRatio(_ value:CGFloat, sizedForIPad:Bool = false, sizedForNavi:Bool = false) -> CGFloat {
        /*
         iPhone6 Hight:667   =====  0.90625
         iPhone5 Hight:568  ====== 0.77173913043478
         iPhone4S Hight:480
         iPAd Hight:1024 ===== 1.39130434782609
          
         (height/736.0)
         */
        
        if (GISTUtility.isIPad && !sizedForIPad) {
            return value;
        }
        
        if (sizedForNavi) {
            return value * GISTUtility.deviceRatioWN; // With Navigation
        }
        
        return value * GISTUtility.deviceRatio;
    } //F.E.
    
    /// Converts CGPoint to (point * device ratio).
    ///
    /// - Parameters:
    ///   - value: CGPoint value
    ///   - sizedForIPad: Bool flag for sizedForIPad
    /// - Returns: Device specific ratio * point
    open class func convertPointToRatio(_ value:CGPoint, sizedForIPad:Bool = false) ->CGPoint {
        return CGPoint(x:self.convertToRatio(value.x, sizedForIPad: sizedForIPad), y:self.convertToRatio(value.y, sizedForIPad: sizedForIPad));
    } //F.E.
    
    /// Converts CGSize to (size * device ratio).
    ///
    /// - Parameters:
    ///   - value: CGSize value
    ///   - sizedForIPad: Bool flag for sizedForIPad
    /// - Returns: Device specific ratio * size
    open class func convertSizeToRatio(_ value:CGSize, sizedForIPad:Bool = false) ->CGSize {
        return CGSize(width:self.convertToRatio(value.width, sizedForIPad: sizedForIPad), height:self.convertToRatio(value.height, sizedForIPad: sizedForIPad));
    } //F.E.
    
    /// Validate String for Empty
    ///
    /// - Parameter text: String
    /// - Returns: Bool whether the string is empty or not.
    open class func isEmpty(_ text:String?)->Bool {
        guard (text != nil) else {
            return true;
        }
        
        return (text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) == "");
    } //F.E.
    
    /// Validate String for email regex.
    ///
    /// - Parameter text: Sting
    /// - Returns: Bool whether the string is a valid email or not.
    open class func isValidEmail(_ text:String?)->Bool {
        guard (text != nil) else {
            return false;
        }
        
        let emailRegex:String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let predicate:NSPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        
        return predicate.evaluate(with: text!);
    } //F.E.
    
    /// Validate String for URL regex.
    ///
    /// - Parameter text: Sting
    /// - Returns: Bool whether the string is a valid URL or not.
    open class func isValidUrl(_ text:String?) -> Bool {
        guard (text != nil) else {
            return false;
        }
        
        let regexURL: String = "(http://|https://)?((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+"
        let predicate:NSPredicate = NSPredicate(format: "SELF MATCHES %@", regexURL)
        return predicate.evaluate(with: text)
    } //F.E.
    
    
    /// Validate String for Phone Number regex.
    ///
    /// - Parameter text: Sting
    /// - Returns: Bool whether the string is a valid phone number or not.
    open class func isValidPhoneNo(_ text:String?) -> Bool {
        guard (text != nil) else {
            return false;
        }
        
        let regexURL: String = "^\\d{3}-\\d{3}-\\d{4}$"
        let predicate:NSPredicate = NSPredicate(format: "SELF MATCHES %@", regexURL)
        return predicate.evaluate(with: text)
    } //F.E.
    
    /// Validate String for number.
    ///
    /// - Parameter text: Sting
    /// - Returns: Bool whether the string is a valid number or not.
    open class func isNumeric(_ text:String?) -> Bool {
        guard (text != nil) else {
            return false;
        }
        
        return Double(text!) != nil;
    } //F.E.
    
    /// Validate String for alphabetic.
    ///
    /// - Parameter text: Sting
    /// - Returns: Bool whether the string is a valid alphabetic string or not.
    open class func isAlphabetic(_ text:String?) -> Bool {
        guard (text != nil) else {
            return false;
        }
        
        for chr in text!.characters {
            if (!(chr >= "a" && chr <= "z") && !(chr >= "A" && chr <= "Z") ) {
                return false
            }
        }
        return true;
    } //F.E.
    
    /// Validate String for minimum character limit.
    ///
    /// - Parameter text: Sting
    /// - Returns: Bool whether the string is a valid number of characters.
    open class func isValidForMinChar(_ text:String?, noOfChar:Int) -> Bool {
        guard (text != nil) else {
            return false;
        }
        
        return (text!.utf16.count >= noOfChar);
    } //F.E.
    
    /// Validate String for maximum character limit.
    ///
    /// - Parameter text: Sting
    /// - Returns: Bool whether the string is a valid number of characters.
    open class func isValidForMaxChar(_ text:String?, noOfChar:Int) -> Bool {
        guard (text != nil) else {
            return false;
        }
        
        return (text!.utf16.count <= noOfChar);
    } //F.E.
    
    /// Validate String for Phone Number regex.
    ///
    /// - Parameter text: Sting
    /// - Returns: Bool whether the string is a valid phone number or not.
    
    
    /// Validate String for a regex.
    ///
    /// - Parameters:
    ///   - text: String
    ///   - regex: Ragex String
    /// - Returns: Bool whether the string is a valid regex string.
    open class func isValidForRegex(_ text:String?, regex:String)->Bool {
        guard (text != nil) else {
            return false;
        }
        
        let predicate:NSPredicate = NSPredicate(format: "SELF MATCHES %@", regex)
        
        return predicate.evaluate(with: text!);
    } //F.E.
    

} //CLS END
