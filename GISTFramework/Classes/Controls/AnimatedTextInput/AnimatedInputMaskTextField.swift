//
//  AnimatedInputMaskTextField.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 15/08/2017.
//  Copyright © 2017 Social Cubix. All rights reserved.
//

import UIKit
import InputMask
import PhoneNumberKit

class AnimatedInputMaskTextField: UITextField, MaskedTextFieldDelegateListener, MaskedPhoneTextFieldDelegateListener {
    
    open var planText:String?
    open var isValidMask:Bool = false;
    
    public var maskFormat: String? {
        didSet {
            guard maskFormat != oldValue else {
                return;
            }
            
            self.updateMaskFormate();
        }
    } //P.E.
    
    public var sendMaskedText:Bool = false;
    
    public var maskPhone: Bool = false {
        didSet {
            guard maskPhone != oldValue else {
                return;
            }
            
            self.updateMaskFormate();
        }
    } //P.E.
    
    public var phonePrefix: Bool = true;
    
    public var defaultRegion:String = PhoneNumberKit.defaultRegionCode() {
        didSet {
            _maskPhoneTextFieldDelegate?.defaultRegion = defaultRegion;
        }
    } //P.E.
    
    private var _polyMaskTextFieldDelegate:PolyMaskTextFieldDelegate?;
    private var _maskPhoneTextFieldDelegate:MaskedPhoneTextFieldDelegate?;
    
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
    
    //MARK: - Constructors
    
    /// Overridden method to setup/ initialize components.
    ///
    /// - Parameter frame: View Frame
    override public init(frame: CGRect) {
        super.init(frame: frame);
        
        self.commonInit();
    } //C.E.
    
    /// Required constructor implemented.
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    } //C.E.
    
    //MARK: - Overridden Methods
    
    /// Overridden method to setup/ initialize components.
    override open func awakeFromNib() {
        super.awakeFromNib()
        
        self.commonInit();
    } //F.E.
    
    //MARK: - Methods
    func commonInit() {
        if (self.maskFormat == nil && !self.maskPhone) {
            super.delegate = self;
        }
    } //F.E.
    
    //MARK: - Methods
    open func updateData(_ data: Any?) {
        let dicData:NSMutableDictionary? = data as? NSMutableDictionary;
        
        //Masking
        self.maskFormat = dicData?["maskFormat"] as? String;
        self.sendMaskedText = dicData?["sendMaskedText"] as? Bool ?? false;
        
        self.maskPhone = dicData?["maskPhone"] as? Bool ?? false;
        
        if let defRegion = dicData?["defaultRegion"] as? String {
            self.defaultRegion = defRegion;
        }
        
    } //F.E.
    
    func updateMaskFormate() {
        
        if let mskFormate:String = maskFormat {
            _maskPhoneTextFieldDelegate?.listener = nil;
            _maskPhoneTextFieldDelegate = nil;
            
            if (_polyMaskTextFieldDelegate == nil) {
                _polyMaskTextFieldDelegate = PolyMaskTextFieldDelegate(format: mskFormate);
                _polyMaskTextFieldDelegate!.listener = self;
                
                super.delegate = _polyMaskTextFieldDelegate;
            } else {
                _polyMaskTextFieldDelegate!.maskFormat = mskFormate;
            }
        } else if maskPhone {
            
            _polyMaskTextFieldDelegate?.listener = nil;
            _polyMaskTextFieldDelegate = nil;
            
            if (_maskPhoneTextFieldDelegate == nil) {
                _maskPhoneTextFieldDelegate = MaskedPhoneTextFieldDelegate(self, with:self.phonePrefix);
                _maskPhoneTextFieldDelegate!.listener = self;
                _maskPhoneTextFieldDelegate!.defaultRegion = defaultRegion;
                
                super.delegate = _maskPhoneTextFieldDelegate;
            }
            
        } else {
            _polyMaskTextFieldDelegate?.listener = nil;
            _polyMaskTextFieldDelegate = nil;
            
            _maskPhoneTextFieldDelegate?.listener = nil;
            _maskPhoneTextFieldDelegate = nil;
            
            super.delegate = self;
        }
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
    } //F.E.
    
    open func applyPhoneMaskFormat()  {
        
        if let result = _maskPhoneTextFieldDelegate?.applyMask() {
            super.text = result.formattedText;
            self.planText = result.extractedValue;
        }
        
    } //F.E.
    
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
    
    open func textField(_ textField: UITextField, didFillMandatoryCharacters complete: Bool, didExtractValue value: String) {
        self.planText = value;
        self.isValidMask = complete;
    } //F.E.
    
    public func textField(_ textField: UITextField, didMaskPhoneWithExtractValue value: String) {
        self.planText = value;
    } //F.E.
}
