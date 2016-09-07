//
//  ValidatedTextField.swift
//  Tst1
//
//  Created by Shoaib Abdul on 06/09/2016.
//  Copyright © 2016 Cubix Labs. All rights reserved.
//

import UIKit

public class ValidatedTextField: BaseUITextField {
    
    @IBInspectable var validateEmpty:Bool = false;
    @IBInspectable var validateEmail:Bool = false;
    @IBInspectable var validateURL:Bool = false;
    @IBInspectable var validateNumeric:Bool = false;
    @IBInspectable var validateAlphabetic:Bool = false;
    @IBInspectable var validateRegex:String?;
    
    
    //??@IBInspectable var continuousValidation:Bool = false;
    
    private var _isValid:Bool = false;
    public var isValid:Bool {
        get {
            return _isValid;
        }
    } //F.E.
    
    private func validateText() {
        _isValid =
            (!validateEmpty || !self.isEmpty()) &&
            (!validateEmail || self.isValidEmail()) &&
            (!validateURL || self.isValidUrl()) &&
            (!validateNumeric || self.isNumeric()) &&
            (!validateAlphabetic || self.isAlphabetic()) &&
            ((validateRegex == nil) || self.isValidForRegex(validateRegex!));
        
    } //F.E.
    
    public override func textFieldDidEndEditing(textField: UITextField) {
        super.textFieldDidEndEditing(textField);
        //--
        self.validateText();
    } //F.E.
    
    
    public func isEmpty()->Bool {
        guard (self.text != nil) else {
            return true;
        }
        
        return (self.text! == "");
    } //F.E.
    
    private func isValidEmail()->Bool {
        guard (self.text != nil) else {
            return false;
        }
        
        let emailRegex:String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let predicate:NSPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        
        return predicate.evaluateWithObject(self.text!);
    } //F.E.
    
    private func isValidUrl() -> Bool {
        guard (self.text != nil) else {
            return false;
        }
        
        let regexURL: String = "(http://|https://)?((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+"
        let predicate:NSPredicate = NSPredicate(format: "SELF MATCHES %@", regexURL)
        return predicate.evaluateWithObject(self.text)
    } //F.E.
    
    private func isNumeric() -> Bool {
        guard (self.text != nil) else {
            return false;
        }
        
        return Double(self.text!) != nil;
    } //F.E.
    
    private func isAlphabetic() -> Bool {
        guard (self.text != nil) else {
            return false;
        }
        
        for chr in self.text!.characters {
            if (!(chr >= "a" && chr <= "z") && !(chr >= "A" && chr <= "Z") ) {
                return false
            }
        }
        return true;
    } //F.E.
    
    private func isValidForRegex(regex:String)->Bool {
        guard (self.text != nil) else {
            return false;
        }
        
        let predicate:NSPredicate = NSPredicate(format: "SELF MATCHES %@", regex)
        
        return predicate.evaluateWithObject(self.text!);
    } //F.E.
    
} //CLS END
