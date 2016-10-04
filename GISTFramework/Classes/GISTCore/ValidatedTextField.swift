//
//  ValidatedTextField.swift
//  Tst1
//
//  Created by Shoaib Abdul on 06/09/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit

@objc public protocol ValidatedTextFieldDelegate {
    optional func validatedTextFieldInvalidSignDidTap(validatedTextField:ValidatedTextField, sender:UIButton);
} //P.E.

public class ValidatedTextField: BaseUITextField {
    
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
            invalidSignBtn.setImage(invalidSign, forState: UIControlState.Normal);
        }
    } //P.E.
    
    private var _validityMsg:String?
    @IBInspectable public var validityMsg:String {
        get {
            return _validityMsg ?? "Invalid";
        }
        
        set {
            _validityMsg = SyncedText.text(forKey: newValue);
        }
        
    }
    
    private lazy var invalidSignBtn:CustomUIButton =  {
        let cBtn:CustomUIButton = CustomUIButton(type: UIButtonType.Custom);
        cBtn.hidden = true;
        cBtn.frame = CGRect(x: self.frame.size.width - self.frame.size.height, y: 0, width: self.frame.size.height, height: self.frame.size.height);
        cBtn.contentMode = UIViewContentMode.Right;
        cBtn.containtOffSet = GISTUtility.convertPointToRatio(CGPoint(x: 10, y: 0));
        
        cBtn.addTarget(self, action: #selector(invalidSignBtnHandler(_:)), forControlEvents: UIControlEvents.TouchUpInside);
        
        self.addSubview(cBtn);
        return cBtn;
    } ();
    
    private var _isEmpty:Bool = false;
    
    private var _isValid:Bool = false;
    public var isValid:Bool {
        get {
            let cValid:Bool = (_isValid && (!validateEmpty || !_isEmpty));
            
            self.invalidSignBtn.hidden = cValid;
            
            return cValid;
        }
    } //F.E.
    
    public override var text: String? {
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
        
        
        self.invalidSignBtn.hidden = (_isValid || _isEmpty);
    } //F.E.
    
    public override func textFieldDidEndEditing(textField: UITextField) {
        super.textFieldDidEndEditing(textField);
        //--
        self.validateText();
    } //F.E.
    
    public func isEmpty()->Bool {
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
    
    private func isValidForMinChar(noOfChar:Int) -> Bool {
        return GISTUtility.isValidForMinChar(self.text, noOfChar: noOfChar);
    } //F.E.
    
    private func isValidForMaxChar(noOfChar:Int) -> Bool {
        return GISTUtility.isValidForMaxChar(self.text, noOfChar: noOfChar);
    } //F.E.
    
    private func isValidForRegex(regex:String)->Bool {
        return GISTUtility.isValidForRegex(self.text, regex: regex);
    } //F.E.
    
    public override func layoutSubviews() {
        super.layoutSubviews();
        //--
        self.invalidSignBtn.frame = CGRect(x: self.frame.size.width - self.frame.size.height, y: 0, width: self.frame.size.height, height: self.frame.size.height);
    } //F.E.
    
    func invalidSignBtnHandler(sender:UIButton) {
        (self.delegate as? ValidatedTextFieldDelegate)?.validatedTextFieldInvalidSignDidTap?(self, sender: sender)
    } //F.E.
} //CLS END
