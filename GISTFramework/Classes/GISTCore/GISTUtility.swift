//
//  GISTUtility.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 07/09/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit
import PhoneNumberKit

/// Class for Utility methods.
public class GISTUtility: NSObject {
    
    //MARK: - Properties
    
    @nonobjc static var screenHeight:CGFloat  {
        if #available(iOS 11.0, *) {
            let topInset:CGFloat = UIApplication.shared.statusBarFrame.height
            
            guard topInset >= 44 else { return UIScreen.main.bounds.height }
            
            let bottomInset:CGFloat = 34;//rootView.safeAreaInsets.bottom
            
            return UIScreen.main.bounds.height - topInset - bottomInset;
            
        } else {
            return UIScreen.main.bounds.height;
        }
    }
    
    @nonobjc public static let deviceRatio:CGFloat =  screenHeight / 736.0;

    
    @nonobjc public static let deviceRatioWN:CGFloat = (UIScreen.main.bounds.height - 64.0) / (736.0 - 64.0); // Ratio with Navigation
    
    /// Bool flag for device type.
    @nonobjc public static let isIPad:Bool = UIDevice.current.userInterfaceIdiom == .pad;
    
    /// Flag to check user interfce layout direction
    @nonobjc public static var isRTL:Bool  {
        get {
            return GIST_CONFIG.isRTL;
        }
    } //P.E.
    
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
    
    /// Native Phone Call
    ///
    /// - Parameter number: a valid phone number
    public class func nativePhoneCall(at number:String) {
        let phoneNumber: String = "tel://\(number.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))";
        
        if let phoneURL:URL = URL(string: phoneNumber), UIApplication.shared.canOpenURL(phoneURL) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(phoneURL, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(phoneURL);
            }
        }
    } //F.E.
    
    /// Calculate Age
    ///
    /// - Parameter birthday: Date of birth
    /// - Returns: age
    public class func calculateAge (_ dateOfBirth: Date) -> Int {
        let calendar : Calendar = Calendar.current
        let unitFlags : NSCalendar.Unit = [NSCalendar.Unit.year, NSCalendar.Unit.month, NSCalendar.Unit.day]
        let dateComponentNow : DateComponents = (calendar as NSCalendar).components(unitFlags, from: Date())
        let dateComponentBirth : DateComponents = (calendar as NSCalendar).components(unitFlags, from: dateOfBirth)
        
        if ((dateComponentNow.month! < dateComponentBirth.month!) ||
            ((dateComponentNow.month! == dateComponentBirth.month!) && (dateComponentNow.day! < dateComponentBirth.day!))
            ) {
            return dateComponentNow.year! - dateComponentBirth.year! - 1
        } else {
            return dateComponentNow.year! - dateComponentBirth.year!
        }
    }//F.E.
    
    /// Converts value to (value * device ratio) considering navigtion bar fixed height.
    ///
    /// - Parameter value: Value
    /// - Returns: Device specific ratio * value
    public class func convertToRatioSizedForNavi(_ value:CGFloat) ->CGFloat {
        return self.convertToRatio(value, sizedForIPad: false, sizedForNavi:true); // Explicit true for Sized For Navi
    } //F.E.
    
    
    /// Converts value to (value * device ratio).
    ///
    /// - Parameters:
    ///   - value: Value
    ///   - sizedForIPad: Bool flag for sizedForIPad
    ///   - sizedForNavi: Bool flag for sizedForNavi
    /// - Returns: Device specific ratio * value
    public class func convertToRatio(_ value:CGFloat, sizedForIPad:Bool = false, sizedForNavi:Bool = false) -> CGFloat {
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
    public class func convertPointToRatio(_ value:CGPoint, sizedForIPad:Bool = false) ->CGPoint {
        return CGPoint(x:self.convertToRatio(value.x, sizedForIPad: sizedForIPad), y:self.convertToRatio(value.y, sizedForIPad: sizedForIPad));
    } //F.E.
    
    /// Converts CGSize to (size * device ratio).
    ///
    /// - Parameters:
    ///   - value: CGSize value
    ///   - sizedForIPad: Bool flag for sizedForIPad
    /// - Returns: Device specific ratio * size
    public class func convertSizeToRatio(_ value:CGSize, sizedForIPad:Bool = false) ->CGSize {
        return CGSize(width:self.convertToRatio(value.width, sizedForIPad: sizedForIPad), height:self.convertToRatio(value.height, sizedForIPad: sizedForIPad));
    } //F.E.
    
    /// Validate String for Empty
    ///
    /// - Parameter text: String
    /// - Returns: Bool whether the string is empty or not.
    public class func isEmpty(_ text:String?)->Bool {
        guard (text != nil) else {
            return true;
        }
        
        return (text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) == "");
    } //F.E.
    
    /// Validate String for email regex.
    ///
    /// - Parameter text: Sting
    /// - Returns: Bool whether the string is a valid email or not.
    public class func isValidEmail(_ text:String?)->Bool {
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
    public class func isValidUrl(_ text:String?) -> Bool {
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
    public class func isValidPhoneNo(_ text:String?, withRegion region: String = PhoneNumberKit.defaultRegionCode()) -> Bool {
        return self.validatePhoneNumber(text, withRegion:region) != nil;
    } //F.E.
    
    public class func validatePhoneNumber(_ text:String?, withRegion region: String = PhoneNumberKit.defaultRegionCode()) -> PhoneNumber? {
        guard (text != nil) else {
            return nil;
        }
        
        let kit = PhoneNumberKit()
        
        
        var pNumber:String = text!
        
        if pNumber.hasPrefix("0") {
            pNumber.remove(at: pNumber.startIndex);
        }
        
        do {
            let phoneNumber:PhoneNumber = try kit.parse(pNumber, withRegion:region);
            
            print("numberString: \(phoneNumber.numberString) countryCode: \(phoneNumber.countryCode) leadingZero: \(phoneNumber.leadingZero) nationalNumber: \(phoneNumber.nationalNumber) numberExtension: \(String(describing: phoneNumber.numberExtension)) type: \(phoneNumber.type)")
            
            return phoneNumber;
        }
        catch {
            
        }
        
        return nil;
    } //F.E.
    
    /// Validate String for number.
    ///
    /// - Parameter text: Sting
    /// - Returns: Bool whether the string is a valid number or not.
    public class func isNumeric(_ text:String?) -> Bool {
        guard (text != nil) else {
            return false;
        }
        
        return Double(text!) != nil;
    } //F.E.
    
    /// Validate String for alphabetic.
    ///
    /// - Parameter text: Sting
    /// - Returns: Bool whether the string is a valid alphabetic string or not.
    public class func isAlphabetic(_ text:String?) -> Bool {
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
    /// - Parameter text: String
    /// - Parameter noOfChar: Int
    /// - Returns: Bool whether the string is a valid number of characters.
    public class func isValidForMinChar(_ text:String?, noOfChar:Int) -> Bool {
        guard (text != nil) else {
            return false;
        }
        
        return (text!.utf16.count >= noOfChar);
    } //F.E.
    
    /// Validate String for maximum character limit.
    ///
    /// - Parameter text: String?
    /// - Parameter noOfChar: Int
    /// - Returns: Bool whether the string is a valid number of characters.
    public class func isValidForMaxChar(_ text:String?, noOfChar:Int) -> Bool {
        guard (text != nil) else {
            return false;
        }
        
        return (text!.utf16.count <= noOfChar);
    } //F.E.
    
    /// Validate String for mininum value entered.
    ///
    /// - Parameter text: String?
    /// - Parameter value: Int
    /// - Returns: Bool whether the string is valid.
    public class func isValidForMinValue(_ text:String?, value:Int) -> Bool {
        guard (text != nil) else {
            return false;
        }
        
        let amount:Int = Int(text!) ?? 0;
        return amount >= value;
    } //F.E.
    
    /// Validate String for mininum value entered.
    ///
    /// - Parameter text: String
    /// - Parameter value: Int
    /// - Returns: Bool whether the string is valid.
    public class func isValidForMaxValue(_ text:String?, value:Int) -> Bool {
        guard (text != nil) else {
            return false;
        }
        
        let amount:Int = Int(text!) ?? 0;
        return amount <= value;
    } //F.E.
    
    /// Validate String for a regex.
    ///
    /// - Parameters:
    ///   - text: String
    ///   - regex: Ragex String
    /// - Returns: Bool whether the string is a valid regex string.
    public class func isValidForRegex(_ text:String?, regex:String) -> Bool {
        guard (text != nil) else {
            return false;
        }
        
        let predicate:NSPredicate = NSPredicate(format: "SELF MATCHES %@", regex)
        
        return predicate.evaluate(with: text!);
    } //F.E.
    
} //CLS END
