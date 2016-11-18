//
//  BaseTextField.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 14/06/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit

open class BaseUITextField: UITextField, UITextFieldDelegate, BaseView {
   
    @IBInspectable open var sizeForIPad:Bool = false;
    
    @IBInspectable open var bgColorStyle:String? = nil {
        didSet {
            self.backgroundColor = SyncedColors.color(forKey: bgColorStyle);
        }
    }
    
    @IBInspectable open var border:Int = 0 {
        didSet {
            if let borderCStyle:String = borderColorStyle {
                self.addBorder(SyncedColors.color(forKey: borderCStyle), width: border)
            }
        }
    }
    
    @IBInspectable open var borderColorStyle:String? = nil {
        didSet {
            if let borderCStyle:String = borderColorStyle {
                self.addBorder(SyncedColors.color(forKey: borderCStyle), width: border)
            }
        }
    }
    
    @IBInspectable open var cornerRadius:Int = 0 {
        didSet {
            self.addRoundedCorners(GISTUtility.convertToRatio(CGFloat(cornerRadius), sizedForIPad: sizeForIPad));
        }
    }
    
    @IBInspectable open var rounded:Bool = false {
        didSet {
            if rounded {
                self.addRoundedCorners();
            }
        }
    }
    
    @IBInspectable open var hasDropShadow:Bool = false {
        didSet {
            if (hasDropShadow) {
                self.addDropShadow();
            } else {
                // TO HANDLER
            }
        }
    }
    
    @IBInspectable open var fontName:String = "fontRegular" {
        didSet {
            self.font = UIFont.font(fontName, fontStyle: fontStyle, sizedForIPad: self.sizeForIPad);
        }
    }
    
    @IBInspectable open var fontStyle:String = "medium" {
        didSet {
            self.font = UIFont.font(fontName, fontStyle: fontStyle, sizedForIPad: self.sizeForIPad);
        }
    }
    
    @IBInspectable open var fontColorStyle:String? = nil {
        didSet {
            self.textColor = SyncedColors.color(forKey: fontColorStyle);
        }
    }
    
    @IBInspectable open var placeholderColor:String? = nil {
        didSet {
            if let colorStyl:String = placeholderColor {
                if let plcHolder:String = self.placeholder {
                    self.attributedPlaceholder = NSAttributedString(string:plcHolder, attributes: [NSForegroundColorAttributeName: SyncedColors.color(forKey: colorStyl)!]);
                }
            }
        }
    } //P.E.
    
    @IBInspectable open var verticalPadding:CGFloat=0
    @IBInspectable open var horizontalPadding:CGFloat=0
    
    private var _maxCharLimit: Int = 50;
    @IBInspectable open var maxCharLimit: Int {
        get {
            return _maxCharLimit;
        }
        
        set {
            if (_maxCharLimit != newValue)
            {_maxCharLimit = newValue;}
        }
    } //P.E.
    
    //Maintainig Own delegate
    private weak var _delegate:UITextFieldDelegate?;
    open override weak var delegate: UITextFieldDelegate? {
        get {
            return _delegate;
        }
        
        set {
            _delegate = newValue;
        }
    } //P.E.
    
    private var _placeholderKey:String?
    override open var placeholder: String? {
        get {
            return super.placeholder;
        }
        
        set {
            if let key:String = newValue , key.hasPrefix("#") == true {
                _placeholderKey = key; // holding key for using later
                
                let plcHolder:String = SyncedText.text(forKey: key);
                
                if let colorStyl:String = placeholderColor {
                    self.attributedPlaceholder = NSAttributedString(string:plcHolder, attributes: [NSForegroundColorAttributeName: SyncedColors.color(forKey: colorStyl)!]);
                } else {
                    super.placeholder = plcHolder;
                }
                
            } else {
                super.placeholder = newValue;
            }
        }
    } //P.E.
    
    /// Overridden method to setup/ initialize components.
    override public init(frame: CGRect) {
        super.init(frame: frame);
        //--
        self.commonInit();
    } //C.E.
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    } //C.E.
    
    /// Overridden method to setup/ initialize components.
    override open func awakeFromNib() {
        super.awakeFromNib()
        //--
        self.commonInit();
    } //F.E.
    
    /// A common initializer for sub components.
    private func commonInit() {
        super.delegate = self;
        //--
        self.font = UIFont.font(fontName, fontStyle: fontStyle, sizedForIPad: self.sizeForIPad);
        
        if let placeHoldertxt:String = self.placeholder , placeHoldertxt.hasPrefix("#") == true{
            self.placeholder = placeHoldertxt; // Assigning again to set value from synced data
        }
    } //F.E.
    
    /// Updates layout and contents from SyncEngine. this is a protocol method BaseView that is called when the view is refreshed.
    public func updateView() {
        // Assigning all again to see if there is update from server
        
        self.font = UIFont.font(fontName, fontStyle: fontStyle, sizedForIPad: self.sizeForIPad);
        
        if let bgCStyle:String = self.bgColorStyle {
            self.bgColorStyle = bgCStyle;
        }
        
        if let borderCStyle:String = self.borderColorStyle {
            self.borderColorStyle = borderCStyle;
        }
        
        if let fntClrStyle = self.fontColorStyle {
            self.fontColorStyle = fntClrStyle;
        }

        if let placeHolderKey:String = _placeholderKey {
            self.placeholder = placeHolderKey;
        }
    } //F.E.
    
    /// Overridden methed to update layout.
    override open func layoutSubviews() {
        super.layoutSubviews();
        //--
        if rounded {
            self.addRoundedCorners();
        }
    } //F.E.
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        //??super.textRectForBounds(bounds)
       
        let x:CGFloat = bounds.origin.x + horizontalPadding
        let y:CGFloat = bounds.origin.y + verticalPadding
        let widht:CGFloat = bounds.size.width - (horizontalPadding * 2)
        let height:CGFloat = bounds.size.height - (verticalPadding * 2)
        
        return CGRect(x: x,y: y,width: widht,height: height)
    } //F.E.
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        super.editingRect(forBounds: bounds)
        return self.textRect(forBounds: bounds)
    } //F.E.
    
    open func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return _delegate?.textFieldShouldBeginEditing?(textField) ?? true;
    } //F.E.
    
    open func textFieldDidBeginEditing(_ textField: UITextField) {
        _delegate?.textFieldDidBeginEditing?(textField);
    } //F.E.
    
    open func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return _delegate?.textFieldShouldEndEditing?(textField) ?? true;
    } //F.E.
    
    open func textFieldDidEndEditing(_ textField: UITextField) {
        _delegate?.textFieldDidEndEditing?(textField);
    } //F.E.
    
    open func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let rtn = _delegate?.textField?(textField, shouldChangeCharactersIn:range, replacementString:string) ?? true;
        
        //IF CHARACTERS-LIMIT <= ZERO, MEANS NO RESTRICTIONS ARE APPLIED
        if (self.maxCharLimit <= 0) {
            return rtn;
        }
        
        guard let text = textField.text else { return true }
        
        let newLength = text.utf16.count + string.utf16.count - range.length
        return (newLength <= self.maxCharLimit) && rtn // Bool
    } //F.E.
    
    open func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return _delegate?.textFieldShouldClear?(textField) ?? true;
    } //F.E.
    
    open func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return _delegate?.textFieldShouldReturn?(textField) ?? true;
    } //F.E.
    
} //CLS END
