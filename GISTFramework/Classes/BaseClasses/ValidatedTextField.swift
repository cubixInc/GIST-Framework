//
//  ValidatedTextField.swift
//  Tst1
//
//  Created by Shoaib Abdul on 06/09/2016.
//  Copyright © 2016 Cubix Labs. All rights reserved.
//

import UIKit

public class ValidatedTextField: BaseUITextField {
    
    @IBInspectable var validateEmail:Bool = false;
    @IBInspectable var validateURL:Bool = false;
    @IBInspectable var validateNumeric:Bool = false;
    @IBInspectable var validateAlphabetic:Bool = false;
    @IBInspectable var validateRegix:String?;
    
    
    //??@IBInspectable var continuousValidation:Bool = false;
    
    private var _isValid:Bool = false;
    public var isValid:Bool {
        get {
            return _isValid;
        }
    } //F.E.
    
    private func validateText() {
        _isValid =
            (!validateEmail || self.isValidEmail()) &&
            (!validateURL || self.isValidUrl()) &&
            (!validateNumeric || self.isNumeric()) &&
            (!validateAlphabetic || self.isAlphabetic()) &&
            ((validateRegix == nil) || self.isValidForRegex(validateRegix!));
        
    } //F.E.
    
    public override func textFieldDidEndEditing(textField: UITextField) {
        super.textFieldDidEndEditing(textField);
        //--
        self.validateText();
    } //F.E.
    
} //CLS END
