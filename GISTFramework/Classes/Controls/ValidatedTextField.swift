//
//  ValidatedTextField.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 06/09/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit
import PhoneNumberKit

/// ValidatedTextField Protocol to receive events.
@objc public protocol ValidatedTextFieldDelegate {
    @objc optional func validatedTextFieldInvalidSignDidTap(_ validatedTextField:ValidatedTextField, sender:UIButton);
} //P.E.

/// ValidatedTextField is subclass of InputMaskTextField with extra proporties to validate text input.
open class ValidatedTextField: InputMaskTextField, ValidatedTextInput {
    
    //MARK: - Properties
    
    /// Bool flag for validating an empty text.
    @IBInspectable open var validateEmpty:Bool = false;
    
    /// Bool flag for validating a valid email text.
    @IBInspectable open var validateEmail:Bool = false;
    
    /// Bool flag for validating a valid phone number text.
    @IBInspectable open var validatePhone:Bool = false;
    
    /// Bool flag for validating a valid email or phone number text.
    @IBInspectable open var validateEmailOrPhone:Bool = false;
    
    /// Bool flag for validating a valid email, phone or non empty number text.
    @IBInspectable open var validateEmailPhoneOrUserName:Bool = false;
    
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
    
    /// Max Character Count Limit for the text field.
    @IBInspectable open var maxCharLimit: Int = 50;
    
    /// Validats minimum character limit.
    @IBInspectable open var minValue:Int = -1;
    
    /// Validats maximum character limit.
    @IBInspectable open var maxValue:Int = -1;
    
    /// Inspectable property for invalid sign image.
    @IBInspectable open var invalidSign:UIImage? = nil {
        didSet {
            invalidSignBtn.setImage(invalidSign, for: UIControlState());
        }
    } //P.E.
    
    /**
     Validity msg for invalid input text. - Default text is 'Invalid'
     The msg can be a key of SyncEngine with a prefix '#'
     */
    @IBInspectable open var validityMsg:String? = nil;
    
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
    
    public var phoneNumber:PhoneNumber?;
    
    private var _data:Any?
    
    /// Holds Data.
    open var data:Any? {
        get {
            return _data;
        }
    } //P.E.
    
    /// Flag for whether the input is valid or not.
    open var isValid:Bool {
        get {
            if (self.isFirstResponder) {
                self.validateText();
            }
            
            let cValid:Bool = (_isValid && (!validateEmpty || !_isEmpty));
            
            self.isInvalidSignHidden = cValid;
            
            return cValid;
        }
    } //F.E.
    
    /// Overridden property to get text changes.
    open override var text: String? {
        didSet {
            if (!self.isFirstResponder) {
                
                if maskFormat != nil {
                    self.applyMaskFormat();
                } else if maskPhone {
                    self.applyPhoneMaskFormat();
                }
                
                self.validateText();
            }
        }
    } //P.E.
    
    open var validText: String?;
    
    open var isInvalidSignHidden:Bool = true {
        didSet {
            self.invalidSignBtn.isHidden = isInvalidSignHidden;
        }
    } //P.E.
    
    public override var defaultRegion: String {
        get {
            return super.defaultRegion;
        }
        
        set {
            super.defaultRegion = newValue;
            
            if (!self.isFirstResponder) {
                self.validateText();
            }
        }
    }
    
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
        
        //Updating text in the holding dictionary
        let dicData:NSMutableDictionary? = data as? NSMutableDictionary;
        dicData?["text"] = textField.text;
        
        
        //Validating the input
        self.validateText();
    } //F.E.
    
    /// Protocol method of shouldChangeCharactersIn for limiting the character limit. - Default value is true
    ///
    /// - Parameters:
    ///   - textField: Text Field
    ///   - range: Change Characters Range
    ///   - string: Replacement String
    /// - Returns: Bool flag for should change characters in range
    open override func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let rtn = super.textField(textField, shouldChangeCharactersIn:range, replacementString:string);
        
        //IF CHARACTERS-LIMIT <= ZERO, MEANS NO RESTRICTIONS ARE APPLIED
        if (self.maxCharLimit <= 0) {
            return rtn;
        }
        
        guard let text = textField.text else { return true }
        
        let newLength = text.utf16.count + string.utf16.count - range.length
        return (newLength <= self.maxCharLimit) && rtn // Bool
    } //F.E.
    
    //MARK: - Methods
    
    open override func updateData(_ data: Any?) {
        super.updateData(data);
        
        _data = data;
        
        let dicData:NSMutableDictionary? = data as? NSMutableDictionary;
        
        //First set the validations
        self.validateEmpty = dicData?["validateEmpty"] as? Bool ?? false;
        self.validateEmail = dicData?["validateEmail"] as? Bool ?? false;
        self.validatePhone = dicData?["validatePhone"] as? Bool ?? false;
        self.validateEmailOrPhone = dicData?["validateEmailOrPhone"] as? Bool ?? false;
        self.validateEmailPhoneOrUserName = dicData?["validateEmailPhoneOrUserName"] as? Bool ?? false;
        self.validityMsg = dicData?["validityMsg"] as? String;
        
        self.validateURL = dicData?["validateURL"] as? Bool ?? false;
        self.validateNumeric = dicData?["validateNumeric"] as? Bool ?? false;
        self.validateAlphabetic = dicData?["validateAlphabetic"] as? Bool ?? false;
        self.validateRegex = dicData?["validateRegex"] as? String ?? "";
        
        //Set the character Limit
        self.minChar = dicData?["minChar"] as? Int ?? 0;
        self.maxChar = dicData?["maxChar"] as? Int ?? 0;
        
        //Set the Value Limit
        self.minValue = dicData?["minValue"] as? Int ?? 0;
        self.maxValue = dicData?["maxValue"] as? Int ?? 0;
        
        self.maxCharLimit = dicData?["maxCharLimit"] as? Int ?? 50;
        
        //Set the text and placeholder
        self.text = dicData?["text"] as? String;
        self.placeholder = dicData?["placeholder"] as? String;
        
        //Set the is password check
        self.isSecureTextEntry = dicData?["isSecureTextEntry"] as? Bool ?? false;
        self.isUserInteractionEnabled = dicData?["isUserInteractionEnabled"] as? Bool ?? true;
        
        if let keyboardTypeStr:String = dicData?["keyboardType"] as? String {
            self.keyboardType = UIKeyboardType.keyboardType(for: keyboardTypeStr);
        }
        
        if let returnKeyTypeStr:String = dicData?["returnKeyType"] as? String {
            self.returnKeyType = UIReturnKeyType.returnKeyType(for: returnKeyTypeStr);
        }
        
        if let validated:Bool = dicData?["validated"] as? Bool, validated == true {
            self.isInvalidSignHidden = (_isValid && (!validateEmpty || !_isEmpty));
        }
    } //F.E.
    
    /// Validating in input and updating the flags of isValid and isEmpty.
    private func validateText() {
        _isEmpty = self.isEmpty();
        
        _isValid =
            ((maskFormat == nil) || self.isValidMask) &&
            (!validateEmail || self.isValidEmail()) &&
            (!validatePhone || self.isValidPhoneNo()) &&
            (!validateEmailOrPhone || (self.isValidEmail() || self.isValidPhoneNo())) &&
            (!validateEmailPhoneOrUserName || (self.isValidEmail() || self.isValidPhoneNo() || !_isEmpty)) &&
            (!validateURL || self.isValidUrl()) &&
            (!validateNumeric || self.isNumeric()) &&
            (!validateAlphabetic || self.isAlphabetic()) &&
            ((minChar == 0) || self.isValidForMinChar(minChar)) &&
            ((maxChar == 0) || self.isValidForMaxChar(maxChar)) &&
            ((minValue == -1) || self.isValidForMinValue(minValue)) &&
            ((maxValue == -1) || self.isValidForMaxValue(maxValue)) &&
            ((validateRegex == "") || self.isValidForRegex(validateRegex));
        
        self.isInvalidSignHidden = (_isValid || _isEmpty);
        
        let valid:Bool = (_isValid && (!validateEmpty || !_isEmpty));
        
        if valid {
            if let pNumber:PhoneNumber = self.phoneNumber {
                self.validText = "+\(pNumber.countryCode)-\(pNumber.nationalNumber)";
            } else {
                self.validText = (self.sendMaskedText) ? self.text : self.curText;
            }
        } else {
            self.validText = nil;
        }
        
        if let dicData:NSMutableDictionary = self.data as? NSMutableDictionary {
            dicData["isValid"] = valid;
            
            dicData["validText"] = self.validText;
        }
        
    } //F.E.
    
    /// Validats for an empty text
    ///
    /// - Returns: Bool flag for a valid input.
    open func isEmpty()->Bool {
        return GISTUtility.isEmpty(self.curText);
    } //F.E.
    
    /// Validats for a valid email text
    ///
    /// - Returns: Bool flag for a valid input.
    private func isValidEmail()->Bool {
        return GISTUtility.isValidEmail(self.curText);
    } //F.E.
    
    /// Validats for a valid url text
    ///
    /// - Returns: Bool flag for a valid input.
    private func isValidUrl() -> Bool {
        return GISTUtility.isValidUrl(self.curText);
    } //F.E.
    
    /// Validats for a valid phone number text
    ///
    /// - Returns: Bool flag for a valid input.
    private func isValidPhoneNo() -> Bool {
        self.phoneNumber = GISTUtility.validatePhoneNumber(self.curText, withRegion: self.defaultRegion);
        return self.phoneNumber != nil;
    } //F.E.
    
    /// Validats for a valid numeric text
    ///
    /// - Returns: Bool flag for a valid input.
    private func isNumeric() -> Bool {
        return GISTUtility.isNumeric(self.curText);
    } //F.E.
    
    /// Validats for a valid alphabetic text
    ///
    /// - Returns: Bool flag for a valid input.
    private func isAlphabetic() -> Bool {
        return GISTUtility.isAlphabetic(self.curText);
    } //F.E.
    
    /// Validats for minimum chararacter limit
    ///
    /// - Parameter noOfChar: No. of characters
    /// - Returns: Bool flag for a valid input.
    private func isValidForMinChar(_ noOfChar:Int) -> Bool {
        return GISTUtility.isValidForMinChar(self.curText, noOfChar: noOfChar);
    } //F.E.
    
    /// Validats for maximum chararacter limit
    ///
    /// - Parameter noOfChar: No. of characters
    /// - Returns: Bool flag for a valid input.
    private func isValidForMaxChar(_ noOfChar:Int) -> Bool {
        return GISTUtility.isValidForMaxChar(self.curText, noOfChar: noOfChar);
    } //F.E.
    
    
    private func isValidForMinValue(_ value:Int) -> Bool {
        return GISTUtility.isValidForMinValue(self.curText, value: value);
    } //F.E.
    
    private func isValidForMaxValue(_ value:Int) -> Bool {
        return GISTUtility.isValidForMaxValue(self.curText, value: value);
    } //F.E.
    
    /// Validats for a regex
    ///
    /// - Parameter regex: Regex
    /// - Returns: Bool flag for a valid input.
    private func isValidForRegex(_ regex:String)->Bool {
        return GISTUtility.isValidForRegex(self.curText, regex: regex);
    } //F.E.
    
    
    /// Method to handle tap event for invalid sign button.
    ///
    /// - Parameter sender: Invalid Sign Button
    func invalidSignBtnHandler(_ sender:UIButton) {
        (self.delegate as? ValidatedTextFieldDelegate)?.validatedTextFieldInvalidSignDidTap?(self, sender: sender)
    } //F.E.
} //CLS END
