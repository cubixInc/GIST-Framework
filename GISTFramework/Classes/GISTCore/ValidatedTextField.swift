//
//  ValidatedTextField.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 06/09/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit

@objc public protocol ValidatedTextFieldDelegate {
    @objc optional func validatedTextFieldInvalidSignDidTap(_ validatedTextField:ValidatedTextField, sender:UIButton);
} //P.E.

open class ValidatedTextField: BaseUITextField {
    
    @IBInspectable var validateEmpty:Bool = false;
    
    @IBInspectable var validateEmail:Bool = false;
    @IBInspectable var validatePhone:Bool = false;
    @IBInspectable var validateURL:Bool = false;
    @IBInspectable var validateNumeric:Bool = false;
    @IBInspectable var validateAlphabetic:Bool = false;
    @IBInspectable var validateRegex:String = "";
    
    @IBInspectable var minChar:Int = 0;
    @IBInspectable var maxChar:Int = 0;
    
    @IBInspectable var invalidSign:UIImage? = nil {
        didSet {
            invalidSignBtn.setImage(invalidSign, for: UIControlState());
        }
    } //P.E.
    
    private var _validityMsg:String?
    @IBInspectable open var validityMsg:String {
        get {
            return _validityMsg ?? "Invalid";
        }
        
        set {
            _validityMsg = SyncedText.text(forKey: newValue);
        }
        
    }
    
    private lazy var invalidSignBtn:CustomUIButton =  {
        let cBtn:CustomUIButton = CustomUIButton(type: UIButtonType.custom);
        cBtn.isHidden = true;
        cBtn.frame = CGRect(x: self.frame.size.width - self.frame.size.height, y: 0, width: self.frame.size.height, height: self.frame.size.height);
        cBtn.contentMode = UIViewContentMode.right;
        cBtn.containtOffSet = GISTUtility.convertPointToRatio(CGPoint(x: 10, y: 0));
        
        cBtn.addTarget(self, action: #selector(invalidSignBtnHandler(_:)), for: UIControlEvents.touchUpInside);
        
        self.addSubview(cBtn);
        return cBtn;
    } ();
    
    private var _isEmpty:Bool = false;
    
    private var _isValid:Bool = false;
    open var isValid:Bool {
        get {
            let cValid:Bool = (_isValid && (!validateEmpty || !_isEmpty));
            
            self.invalidSignBtn.isHidden = cValid;
            
            return cValid;
        }
    } //F.E.
    
    open override var text: String? {
        didSet {
            self.validateText();
        }
    } //P.E.
    
    private func validateText() {
        _isEmpty = self.isEmpty();
        
        _isValid =
            (!validateEmail || self.isValidEmail()) &&
            (!validatePhone || self.isValidPhoneNo()) &&
            (!validateURL || self.isValidUrl()) &&
            (!validateNumeric || self.isNumeric()) &&
            (!validateAlphabetic || self.isAlphabetic()) &&
            ((minChar == 0) || self.isValidForMinChar(minChar)) &&
            ((maxChar == 0) || self.isValidForMaxChar(maxChar)) &&
            ((validateRegex == "") || self.isValidForRegex(validateRegex));
        
        
        self.invalidSignBtn.isHidden = (_isValid || _isEmpty);
    } //F.E.
    
    open override func textFieldDidEndEditing(_ textField: UITextField) {
        super.textFieldDidEndEditing(textField);
        //--
        self.validateText();
    } //F.E.
    
    open func isEmpty()->Bool {
        return GISTUtility.isEmpty(self.text);
    } //F.E.
    
    private func isValidEmail()->Bool {
        return GISTUtility.isValidEmail(self.text);
    } //F.E.
    
    private func isValidUrl() -> Bool {
        return GISTUtility.isValidUrl(self.text);
    } //F.E.
    
    private func isValidPhoneNo() -> Bool {
        return GISTUtility.isValidPhoneNo(self.text);
    } //F.E.
    
    private func isNumeric() -> Bool {
        return GISTUtility.isNumeric(self.text);
    } //F.E.
    
    private func isAlphabetic() -> Bool {
        return GISTUtility.isAlphabetic(self.text);
    } //F.E.
    
    private func isValidForMinChar(_ noOfChar:Int) -> Bool {
        return GISTUtility.isValidForMinChar(self.text, noOfChar: noOfChar);
    } //F.E.
    
    private func isValidForMaxChar(_ noOfChar:Int) -> Bool {
        return GISTUtility.isValidForMaxChar(self.text, noOfChar: noOfChar);
    } //F.E.
    
    private func isValidForRegex(_ regex:String)->Bool {
        return GISTUtility.isValidForRegex(self.text, regex: regex);
    } //F.E.
    
    open override func layoutSubviews() {
        super.layoutSubviews();
        //--
        self.invalidSignBtn.frame = CGRect(x: self.frame.size.width - self.frame.size.height, y: 0, width: self.frame.size.height, height: self.frame.size.height);
    } //F.E.
    
    func invalidSignBtnHandler(_ sender:UIButton) {
        (self.delegate as? ValidatedTextFieldDelegate)?.validatedTextFieldInvalidSignDidTap?(self, sender: sender)
    } //F.E.
} //CLS END
