//
//  BaseUISearchBar.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 14/06/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit

extension UISearchBar {
    var textField: UITextField? {
        get {
            return self.value(forKey: "_searchField") as? UITextField
        }
    }
}

open class BaseUISearchBar: UISearchBar, BaseView {
    
    @IBInspectable open var sizeForIPad:Bool = false;
    
    @IBInspectable open var bgColorStyle:String? = nil {
        didSet {
            self.backgroundColor = SyncedColors.color(forKey: bgColorStyle);
        }
    }
    
    @IBInspectable open var fontBgColorStyle:String? = nil {
        didSet {
            if let txtField:UITextField = self.textField {
                txtField.backgroundColor =  SyncedColors.color(forKey: fontBgColorStyle);
            }
        }
    }
    
    @IBInspectable open var tintColorStyle:String? = nil {
        didSet {
            self.tintColor =  SyncedColors.color(forKey: tintColorStyle);
        }
    }
    
    @IBInspectable open var barTintColorStyle:String? = nil {
        didSet {
            self.barTintColor =  SyncedColors.color(forKey: barTintColorStyle);
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
            if let txtField:UITextField = self.textField {
                txtField.font = UIFont.font(fontName, fontStyle: fontStyle, sizedForIPad: self.sizeForIPad);
            }
        }
    }
    
    @IBInspectable open var fontStyle:String = "medium" {
        didSet {
            if let txtField:UITextField = self.textField {
                txtField.font = UIFont.font(fontName, fontStyle: fontStyle, sizedForIPad: self.sizeForIPad);
            }
        }
    }
    
    @IBInspectable open var fontColorStyle:String? = nil {
        didSet {
            if let txtField:UITextField = self.textField {
                txtField.textColor = SyncedColors.color(forKey: fontColorStyle);
            }
        }
    }
    
    @IBInspectable open var searchBarIcon:UIImage? = nil {
        didSet {
            self.setImage(searchBarIcon, for: UISearchBarIcon.search, state: UIControlState());
        }
    } //P.E.
    
    fileprivate var _placeholderKey:String?
    override open var placeholder: String? {
        get {
            return super.placeholder;
        }
        
        set {
            if let key:String = newValue , key.hasPrefix("#") == true{
                _placeholderKey = key; // holding key for using later
                //--
                super.placeholder = SyncedText.text(forKey: key);
            } else {
                super.placeholder = newValue;
            }
        }
    } //P.E.
    
    override public init(frame: CGRect) {
        super.init(frame: frame);
        
        self.commontInit();
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib();
        //--
        self.commontInit();
    } //F.E.
    
    fileprivate func commontInit() {
        if let placeHoldertxt:String = self.placeholder , placeHoldertxt.hasPrefix("#") == true{
            self.placeholder = placeHoldertxt; // Assigning again to set value from synced data
        }
    } //F.E.

    
    open func updateView() {
        if let plcHKey:String = _placeholderKey {
            self.placeholder = plcHKey;
        }
        
        if let bgCStyle:String = self.bgColorStyle {
            self.bgColorStyle = bgCStyle;
        }
        
        if let fBgCStyle:String = self.fontBgColorStyle {
            self.fontBgColorStyle = fBgCStyle;
        }
        
        if let borderCStyle:String = self.borderColorStyle {
            self.borderColorStyle = borderCStyle;
        }
        
        if let tCStyle = self.tintColorStyle {
            self.tintColorStyle = tCStyle;
        }
        
        if let tBCStyle = self.barTintColorStyle {
            self.barTintColorStyle = tBCStyle;
        }
        
        if let fntClrStyle = self.fontColorStyle {
            self.fontColorStyle = fntClrStyle;
        }
    } //F.E.

} //CLS END
