//
//  BaseTextField.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 14/06/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit

/// BaseUITextField is a subclass of UITextField and implements UITextFieldDelegate, BaseView. It has some extra proporties and support for SyncEngine.
open class BaseUITextField: UITextField, BaseView {
   
    //MARK: - Properties
    
    /// Flag for whether to resize the values for iPad.
    @IBInspectable open var sizeForIPad:Bool = GIST_CONFIG.sizeForIPad;
    
    /// Background color key from Sync Engine.
    @IBInspectable open var bgColorStyle:String? = nil {
        didSet {
            self.backgroundColor = SyncedColors.color(forKey: bgColorStyle);
        }
    }
    
    /// Width of View Border.
    @IBInspectable open var border:Int = 0 {
        didSet {
            if let borderCStyle:String = borderColorStyle {
                self.addBorder(SyncedColors.color(forKey: borderCStyle), width: border)
            }
        }
    }
    
    /// Border color key from Sync Engine.
    @IBInspectable open var borderColorStyle:String? = nil {
        didSet {
            if let borderCStyle:String = borderColorStyle {
                self.addBorder(SyncedColors.color(forKey: borderCStyle), width: border)
            }
        }
    }
    
    /// Corner Radius for View.
    @IBInspectable open var cornerRadius:Int = 0 {
        didSet {
            self.addRoundedCorners(GISTUtility.convertToRatio(CGFloat(cornerRadius), sizedForIPad: sizeForIPad));
        }
    }
    
    /// Flag for making circle/rounded view.
    @IBInspectable open var rounded:Bool = false {
        didSet {
            if rounded {
                self.addRoundedCorners();
            }
        }
    }
    
    /// Flag for Drop Shadow.
    @IBInspectable open var hasDropShadow:Bool = false {
        didSet {
            if (hasDropShadow) {
                self.addDropShadow();
            } else {
                // TO HANDLER
            }
        }
    }
    
    /// Font name key from Sync Engine.
    @IBInspectable open var fontName:String = GIST_CONFIG.fontName {
        didSet {
            self.font = UIFont.font(fontName, fontStyle: fontStyle, sizedForIPad: self.sizeForIPad);
        }
    }
    
    /// Font size/style key from Sync Engine.
    @IBInspectable open var fontStyle:String = GIST_CONFIG.fontStyle {
        didSet {
            self.font = UIFont.font(fontName, fontStyle: fontStyle, sizedForIPad: self.sizeForIPad);
        }
    }
    
    /// Font color key from Sync Engine.
    @IBInspectable open var fontColorStyle:String? = nil {
        didSet {
            self.textColor = SyncedColors.color(forKey: fontColorStyle);
        }
    }
    
    /// Placeholder Text Font color key from SyncEngine.
    @IBInspectable open var placeholderColor:String? = nil {
        didSet {
            if let colorStyl:String = placeholderColor {
                if let plcHolder:String = self.placeholder {
                    self.attributedPlaceholder = NSAttributedString(string:plcHolder, attributes: [NSForegroundColorAttributeName: SyncedColors.color(forKey: colorStyl)!]);
                }
            }
        }
    } //P.E.
    
    
    /// Text Vertical Padding - Default Value is Zero
    @IBInspectable open var verticalPadding:CGFloat = 0
    
    /// Text Horizontal Padding - Default Value is Zero
    @IBInspectable open var horizontalPadding:CGFloat = 0
    
    
    private var _placeholderKey:String?
    
    /// Overridden property to set placeholder text from SyncEngine (Hint '#' prefix).
    override open var placeholder: String? {
        get {
            return super.placeholder;
        }
        
        set {
            guard let key:String = newValue else {
                _placeholderKey = nil;
                super.placeholder = newValue;
                return;
            }
            
            let newPlaceHolder:String;
            
            if (key.hasPrefix("#") == true) {
                _placeholderKey = key; // holding key for using later
                
                newPlaceHolder = SyncedText.text(forKey: key);
            } else {
                _placeholderKey = nil;
                
                newPlaceHolder = key;
            }
            
            if let colorStyl:String = placeholderColor {
                self.attributedPlaceholder = NSAttributedString(string:newPlaceHolder, attributes: [NSForegroundColorAttributeName: SyncedColors.color(forKey: colorStyl)!]);
            } else {
                super.placeholder = newPlaceHolder;
            }
        }
    } //P.E.
    
    /// Parameter key for service - Default Value is nil
    @IBInspectable open var paramKey:String?;
    
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
    
    /// Overridden methed to update layout.
    override open func layoutSubviews() {
        super.layoutSubviews();
         
        if rounded {
            self.addRoundedCorners();
        }
        
        if (hasDropShadow) {
            self.addDropShadow();
        }
    } //F.E.
    
    /// Overridden method to handle text paddings
    ///
    /// - Parameter bounds: Text Bounds
    /// - Returns: Calculated bounds with paddings.
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        
        guard (self.horizontalPadding < 0 && self.verticalPadding < 0) else {
            return super.textRect(forBounds: bounds);
        }
        
        let x:CGFloat = bounds.origin.x + horizontalPadding
        let y:CGFloat = bounds.origin.y + verticalPadding
        let widht:CGFloat = bounds.size.width - (horizontalPadding * 2)
        let height:CGFloat = bounds.size.height - (verticalPadding * 2)
        
        return CGRect(x: x,y: y,width: widht,height: height)
    } //F.E.
    
    /// Overridden method to handle text paddings when editing.
    ///
    /// - Parameter bounds: Text Bounds
    /// - Returns: Calculated bounds with paddings.
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        super.editingRect(forBounds: bounds)
        return self.textRect(forBounds: bounds)
    } //F.E.
    
    //MARK: - Methods
    
    /// A common initializer to setup/initialize sub components.
    func commonInit() {
        self.font = UIFont.font(fontName, fontStyle: fontStyle, sizedForIPad: self.sizeForIPad);
        
        if let placeHoldertxt:String = self.placeholder , placeHoldertxt.hasPrefix("#") == true{
            self.placeholder = placeHoldertxt; // Assigning again to set value from synced data
        }
    } //F.E.
    
    /// Updates layout and contents from SyncEngine. this is a protocol method BaseView that is called when the view is refreshed.
    func updateView() {
        //Setting font
        self.font = UIFont.font(fontName, fontStyle: fontStyle, sizedForIPad: self.sizeForIPad);
        
        //Re-assigning if there are any changes from server
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
    
} //CLS END
