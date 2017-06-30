//
//  InputMaskTextField.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 17/05/2017.
//  Copyright © 2017 Social Cubix. All rights reserved.
//

import UIKit
import InputMask

open class InputMaskTextField: BaseUITextField, MaskedTextFieldDelegateListener {

    open var planText:String?
    open var isValidMask:Bool = false;
    
    @IBInspectable public var maskFormat: String? {
        didSet {
            guard maskFormat != oldValue else {
                return;
            }
            
            guard let mskFormate:String = maskFormat else {
                _polyMaskTextFieldDelegate?.listener = nil;
                _polyMaskTextFieldDelegate = nil;
                
                super.delegate = self;
                return;
            }
            
            if (_polyMaskTextFieldDelegate == nil) {
                _polyMaskTextFieldDelegate = PolyMaskTextFieldDelegate(format: mskFormate);
                _polyMaskTextFieldDelegate!.listener = self;
                
                super.delegate = _polyMaskTextFieldDelegate;
            } else {
                _polyMaskTextFieldDelegate!.maskFormat = mskFormate;
            }
        }
    } //P.E.
    
    @IBInspectable public var sendMaskedText:Bool = false;
    
    
    var curText: String? {
        get {
            return (self.maskFormat != nil) ? self.planText:self.text;
        }
    } //P.E.
    
    
    private var _polyMaskTextFieldDelegate:PolyMaskTextFieldDelegate?;
    
    ///Maintainig Own delegate.
    private weak var _delegate:UITextFieldDelegate?;
    open override weak var delegate: UITextFieldDelegate? {
        get {
            return _delegate;
        }
        
        set {
            _delegate = newValue;
        }
    } //P.E.
    
    override func commonInit() {
        super.commonInit();
        
        if (self.maskFormat == nil) {
            super.delegate = self;
        }
    } //F.E.
    
    //MARK: - Methods
    
    open func updateData(_ data: Any?) {
        let dicData:NSMutableDictionary? = data as? NSMutableDictionary;
        
        //Masking
        self.maskFormat = dicData?["maskFormat"] as? String;
        self.sendMaskedText = dicData?["sendMaskedText"] as? Bool ?? false;
        
    } //F.E.
    
    open func applyMaskFormat()  {
        let mask: Mask = try! Mask(format: self.maskFormat!)
        let input: String = self.text!
        let result: Mask.Result = mask.apply(
            toText: CaretString(
                string: input,
                caretPosition: input.endIndex
            ),
            autocomplete: true // you may consider disabling autocompletion for your case
        )
        
        self.isValidMask = result.complete;
        self.planText = result.extractedValue;
        
        super.text = result.formattedText.string;
    }
    
    //Mark: - UITextField Delegate Methods
    
    /// Protocol method of textFieldShouldBeginEditing.
    ///
    /// - Parameter textField: Text Field
    /// - Returns: Bool flag for should begin edititng
    open func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return _delegate?.textFieldShouldBeginEditing?(textField) ?? true;
    } //F.E.
    
    /// Protocol method of textFieldDidBeginEditing.
    ///
    /// - Parameter textField: Text Field
    open func textFieldDidBeginEditing(_ textField: UITextField) {
        _delegate?.textFieldDidBeginEditing?(textField);
    } //F.E.
    
    
    /// Protocol method of textFieldShouldEndEditing. - Default value is true
    ///
    /// - Parameter textField: Text Field
    /// - Returns: Bool flag for should end edititng
    open func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return _delegate?.textFieldShouldEndEditing?(textField) ?? true;
    } //F.E.
    
    /// Protocol method of textFieldDidEndEditing
    ///
    /// - Parameter textField: Text Field
    open func textFieldDidEndEditing(_ textField: UITextField) {
        _delegate?.textFieldDidEndEditing?(textField);
    } //F.E.
    
    
    /// Protocol method of shouldChangeCharactersIn range
    ///
    /// - Parameters:
    ///   - textField: Text Field
    ///   - range: Change Characters Range
    ///   - string: Replacement String
    /// - Returns: Bool flag for should change characters in range
    open func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return _delegate?.textField?(textField, shouldChangeCharactersIn:range, replacementString:string) ?? true;
    } //F.E.
    
    /// Protocol method of textFieldShouldClear. - Default value is true
    ///
    /// - Parameter textField: Text Field
    /// - Returns: Bool flag for should clear text field
    open func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return _delegate?.textFieldShouldClear?(textField) ?? true;
    } //F.E.
    
    
    /// Protocol method of textFieldShouldReturn. - Default value is true
    ///
    /// - Parameter textField: Text Field
    /// - Returns: Bool flag for text field should return.
    open func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return _delegate?.textFieldShouldReturn?(textField) ?? true;
    } //F.E.
    
    public func textField(_ textField: UITextField, didFillMandatoryCharacters complete: Bool, didExtractValue value: String) {
        self.planText = value;
        self.isValidMask = complete;
    } //F.E.

} //CLS END
