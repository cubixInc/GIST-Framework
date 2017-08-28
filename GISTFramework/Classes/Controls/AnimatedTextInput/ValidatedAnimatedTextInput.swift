//
//  ValidatedAnimatedTextInput.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 12/07/2017.
//  Copyright © 2017 Social Cubix. All rights reserved.
//

import UIKit
import PhoneNumberKit

open class ValidatedAnimatedTextInput: AnimatedTextInput, ValidatedTextInput {

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
    
    @IBInspectable public var maskFormat: String? {
        get {
            return (self.textInput as? AnimatedInputMaskTextField)?.maskFormat;
        }
        
        set {
            (self.textInput as? AnimatedInputMaskTextField)?.maskFormat = newValue;
        }
    } //P.E.
    
    @IBInspectable public var sendMaskedText:Bool {
        get {
            return (self.textInput as? AnimatedInputMaskTextField)?.sendMaskedText ?? false;
        }
        
        set {
            (self.textInput as? AnimatedInputMaskTextField)?.sendMaskedText = newValue;
        }
    } //P.E.
    
    @IBInspectable public var maskPhone: Bool {
        get {
            return (self.textInput as? AnimatedInputMaskTextField)?.maskPhone ?? false;
        }
        
        set {
            (self.textInput as? AnimatedInputMaskTextField)?.maskPhone = newValue;
        }
    } //P.E.
    
    @IBInspectable public var phonePrefix: Bool {
        get {
            return (self.textInput as? AnimatedInputMaskTextField)?.phonePrefix ?? true;
        }
        
        set {
            (self.textInput as? AnimatedInputMaskTextField)?.phonePrefix = newValue;
        }
    } //P.E.
    
    @IBInspectable public var prefix: String? {
        get {
            return (self.textInput as? AnimatedTextField)?.prefix;
        }
        
        set {
            (self.textInput as? AnimatedTextField)?.prefix = newValue;
        }
    } //P.E.
    
    
    @IBInspectable public var defaultRegion:String {
        get {
            return (self.textInput as? AnimatedInputMaskTextField)?.defaultRegion ?? PhoneNumberKit.defaultRegionCode();
        }
        
        set {
            (self.textInput as? AnimatedInputMaskTextField)?.defaultRegion = newValue;
        }
    } //P.E.
    
    open var planText:String? {
        get {
            return (self.textInput as? AnimatedInputMaskTextField)?.planText;
        }
    } //P.E
    
    internal var curText: String? {
        get {
            return (self.maskFormat != nil || self.prefix != nil || maskPhone) ? self.planText:self.text;
        }
    } //P.E.
    
    open var isValidMask:Bool {
        get {
            return (self.textInput as? AnimatedInputMaskTextField)?.isValidMask ?? false;
        }
    } //P.E.
    
    /**
     Validity msg for invalid input text. - Default text is 'Invalid'
     The msg can be a key of SyncEngine with a prefix '#'
     */
    @IBInspectable open var validityMsg:String? = nil;
    
    private var _isEmpty:Bool = false;
    
    private var _isValid:Bool = false;
    
    public var phoneNumber:PhoneNumber?;
    
    open override var text: String? {
        get {
            return super.text;
        }
        set {
            super.text = newValue;
            
            if (!self.isFirstResponder) {
                
                if maskFormat != nil {
                    (self.textInput as? AnimatedInputMaskTextField)?.applyMaskFormat();
                } else if maskPhone {
                    (self.textInput as? AnimatedInputMaskTextField)?.applyPhoneMaskFormat();
                }
                
                if (self.prefix != nil) {
                    (self.textInput as? AnimatedTextField)?.addPrefix();
                }
                
                self.validateText();
            }
        }
    } //P.E.
    
    open var validText: String?;
    
    /// Flag for whether the input is valid or not.
    open var isValid:Bool {
        get {
            if (self.isFirstResponder) {
                self.validateText();
            }
            
            let cValid:Bool = (_isValid && (!validateEmpty || !_isEmpty));
            
            self.isInvalidMsgHidden = cValid;
            
            return cValid;
        }
    } //F.E.
    
    open var isInvalidMsgHidden:Bool = true {
        didSet {
            if isInvalidMsgHidden == false  {
                self.show(error: self.validityMsg ?? "Invalid");
            } else {
                self.clearError();
            }
        }
    } //P.E.
    
    private var _data:Any?
    
    /// Holds Data.
    open var data:Any? {
        get {
            return _data;
        }
    } //P.E.
    
    //MARK: - Methods
    
    open func updateData(_ data: Any?) {
        _data = data;
        
        self.textInput.updateData(data);
        
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
        
        self.maxCharLimit = dicData?["maxCharLimit"] as? Int ?? (self.multilined ? 255 : 50);
        
        if let defRegion = dicData?["defaultRegion"] as? String {
            self.defaultRegion = defRegion;
        }
        
        //Set the text and placeholder
        self.title = dicData?["title"] as? String;
        self.placeholder = dicData?["placeholder"] as? String;
        
        self.text = dicData?["text"] as? String;

        //Set the is password check
        self.isSecureTextEntry = dicData?["isSecureTextEntry"] as? Bool ?? false;
        self.isUserInteractionEnabled = dicData?["isUserInteractionEnabled"] as? Bool ?? true;
        
        if let autocapitalizationTypeStr:String = dicData?["autocapitalizationType"] as? String {
            self.autocapitalizationType = UITextAutocapitalizationType.textAutocapitalizationType(for: autocapitalizationTypeStr);
        }
        
        if let autocorrectionTypeStr:String = dicData?["autocorrectionType"] as? String {
            self.autocorrectionType = UITextAutocorrectionType.textAutocorrectionType(for: autocorrectionTypeStr);
        }
        
        if let keyboardTypeStr:String = dicData?["keyboardType"] as? String {
            self.keyboardType = UIKeyboardType.keyboardType(for: keyboardTypeStr);
        }
        
        if let returnKeyTypeStr:String = dicData?["returnKeyType"] as? String {
            self.returnKeyType = UIReturnKeyType.returnKeyType(for: returnKeyTypeStr);
        }
        
        if let validated:Bool = dicData?["validated"] as? Bool, validated == true {
            self.isInvalidMsgHidden = (_isValid && (!validateEmpty || !_isEmpty));
        }
        
    } //F.E.
    
    /// Validating in input and updating the flags of isValid and isEmpty.  --- Incomplete implementation
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
            ((validateRegex == "") || self.isValidForRegex(validateRegex));
        
        self.isInvalidMsgHidden = (_isValid || _isEmpty);
        
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
    
    /// Overridden property to get text changes.
    open override func textInputDidEndEditing(textInput: TextInput) {
        super.textInputDidEndEditing(textInput: textInput);
        
        //Updating text in the holding dictionary
        let dicData:NSMutableDictionary? = data as? NSMutableDictionary;
        dicData?["text"] = textInput.currentText;
        
        //Validating the input
        self.validateText();
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
    
    /// Validats for a regex
    ///
    /// - Parameter regex: Regex
    /// - Returns: Bool flag for a valid input.
    private func isValidForRegex(_ regex:String)->Bool {
        return GISTUtility.isValidForRegex(self.curText, regex: regex);
    } //F.E.

} //CLS END
