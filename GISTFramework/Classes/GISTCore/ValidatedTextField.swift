//
//  ValidatedTextField.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 06/09/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit

/// ValidatedTextField Protocol to receive events.
@objc public protocol ValidatedTextFieldDelegate {
    @objc optional func validatedTextFieldInvalidSignDidTap(_ validatedTextField:ValidatedTextField, sender:UIButton);
} //P.E.

/// ValidatedTextField is subclass of BaseUITextField with extra proporties to validate text input.
open class ValidatedTextField: BaseUITextField {
    
    //MARK: - Properties
    
    /// Bool flag for validating an empty text.
    @IBInspectable open var validateEmpty:Bool = false;
    
    /// Bool flag for validating a valid email text.
    @IBInspectable open var validateEmail:Bool = false;
    
    /// Bool flag for validating a valid phone number text.
    @IBInspectable open var validatePhone:Bool = false;
    
    /// Bool flag for validating a valid url text.
    @IBInspectable open var validateURL:Bool = false;
    
    /// Bool flag for validating a valid numaric input.
    @IBInspectable open var validateNumeric:Bool = false;
    
    /// Bool flag for validating a valid alphabetic input.
    @IBInspectable open var validateAlphabetic:Bool = false;
    
    /// Bool flag for validating a valid alphabetic input.
    @IBInspectable open var validateRegex:String = "";
    
    /// Validats minimum character limit.
    @IBInspectable open var minChar:Int = 0;
    
    /// Validats maximum character limit.
    @IBInspectable open var maxChar:Int = 0;
    
    /// Inspectable property for invalid sign image.
    @IBInspectable open var invalidSign:UIImage? = nil {
        didSet {
            invalidSignBtn.setImage(invalidSign, for: UIControlState());
        }
    } //P.E.
    
    private var _validityMsg:String?
    
    /**
     Validity msg for invalid input text. - Default text is 'Invalid'
     The msg can be a key of SyncEngine with a prefix '#'
     */
    @IBInspectable open var validityMsg:String {
        get {
            return _validityMsg ?? "Invalid";
        }
        
        set {
            _validityMsg = SyncedText.text(forKey: newValue);
        }
        
    }
    
    /// Lazy Button instance for invalid sign.
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
    
    /// Flag for whether the input is valid or not.
    open var isValid:Bool {
        get {
            let cValid:Bool = (_isValid && (!validateEmpty || !_isEmpty));
            
            self.invalidSignBtn.isHidden = cValid;
            
            return cValid;
        }
    } //F.E.
    
    /// Overridden property to get text changes.
    open override var text: String? {
        didSet {
            self.validateText();
        }
    } //P.E.
    
    //MARK: - Overridden Methods
    
    /// Overridden methed to update layout.
    open override func layoutSubviews() {
        super.layoutSubviews();
         
        self.invalidSignBtn.frame = CGRect(x: self.frame.size.width - self.frame.size.height, y: 0, width: self.frame.size.height, height: self.frame.size.height);
    } //F.E.
    
    /// Overridden property to get text changes.
    ///
    /// - Parameter textField: UITextField
    open override func textFieldDidEndEditing(_ textField: UITextField) {
        super.textFieldDidEndEditing(textField);
         
        self.validateText();
    } //F.E.
    
    //MARK: - Methods
    
    /// Validating in input and updating the flags of isValid and isEmpty.
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
    
    /// Validats for an empty text
    ///
    /// - Returns: Bool flag for a valid input.
    open func isEmpty()->Bool {
        return GISTUtility.isEmpty(self.text);
    } //F.E.
    
    /// Validats for a valid email text
    ///
    /// - Returns: Bool flag for a valid input.
    private func isValidEmail()->Bool {
        return GISTUtility.isValidEmail(self.text);
    } //F.E.
    
    /// Validats for a valid url text
    ///
    /// - Returns: Bool flag for a valid input.
    private func isValidUrl() -> Bool {
        return GISTUtility.isValidUrl(self.text);
    } //F.E.
    
    /// Validats for a valid phone number text
    ///
    /// - Returns: Bool flag for a valid input.
    private func isValidPhoneNo() -> Bool {
        return GISTUtility.isValidPhoneNo(self.text);
    } //F.E.
    
    /// Validats for a valid numeric text
    ///
    /// - Returns: Bool flag for a valid input.
    private func isNumeric() -> Bool {
        return GISTUtility.isNumeric(self.text);
    } //F.E.
    
    /// Validats for a valid alphabetic text
    ///
    /// - Returns: Bool flag for a valid input.
    private func isAlphabetic() -> Bool {
        return GISTUtility.isAlphabetic(self.text);
    } //F.E.
    
    /// Validats for minimum chararacter limit
    ///
    /// - Parameter noOfChar: No. of characters
    /// - Returns: Bool flag for a valid input.
    private func isValidForMinChar(_ noOfChar:Int) -> Bool {
        return GISTUtility.isValidForMinChar(self.text, noOfChar: noOfChar);
    } //F.E.
    
    /// Validats for maximum chararacter limit
    ///
    /// - Parameter noOfChar: No. of characters
    /// - Returns: Bool flag for a valid input.
    private func isValidForMaxChar(_ noOfChar:Int) -> Bool {
        return GISTUtility.isValidForMaxChar(self.text, noOfChar: noOfChar);
    } //F.E.
    
    /// Validats for a regex
    ///
    /// - Parameter regex: Regex
    /// - Returns: Bool flag for a valid input.
    private func isValidForRegex(_ regex:String)->Bool {
        return GISTUtility.isValidForRegex(self.text, regex: regex);
    } //F.E.
    
    /// Method to handle tap event for invalid sign button.
    ///
    /// - Parameter sender: Invalid Sign Button
    func invalidSignBtnHandler(_ sender:UIButton) {
        (self.delegate as? ValidatedTextFieldDelegate)?.validatedTextFieldInvalidSignDidTap?(self, sender: sender)
    } //F.E.
} //CLS END
