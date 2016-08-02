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
            return self.valueForKey("_searchField") as? UITextField
        }
    }
}

public class BaseUISearchBar: UISearchBar, BaseView {
    
    @IBInspectable public var sizeForIPad:Bool = false;
    
    @IBInspectable public var bgColorStyle:String? = nil {
        didSet {
            self.backgroundColor = SyncedColors.color(forKey: bgColorStyle);
        }
    }
    
    @IBInspectable public var fontBgColorStyle:String? = nil {
        didSet {
            if let txtField:UITextField = self.textField {
                txtField.backgroundColor =  SyncedColors.color(forKey: fontBgColorStyle);
            }
        }
    }
    
    @IBInspectable public var tintColorStyle:String? = nil {
        didSet {
            self.tintColor =  SyncedColors.color(forKey: tintColorStyle);
        }
    }
    
    @IBInspectable public var barTintColorStyle:String? = nil {
        didSet {
            self.barTintColor =  SyncedColors.color(forKey: barTintColorStyle);
        }
    }
    
    @IBInspectable public var boarder:Int = 0 {
        didSet {
            if let boarderCStyle:String = boarderColorStyle {
                self.addBorder(SyncedColors.color(forKey: boarderCStyle), width: boarder)
            }
        }
    }
    
    @IBInspectable public var boarderColorStyle:String? = nil {
        didSet {
            if let boarderCStyle:String = boarderColorStyle {
                self.addBorder(SyncedColors.color(forKey: boarderCStyle), width: boarder)
            }
        }
    }
    
    @IBInspectable public var cornerRadius:Int = 0 {
        didSet {
            self.addRoundedCorners(UIView.convertToRatio(CGFloat(cornerRadius), sizedForIPad: sizeForIPad));
        }
    }
    
    @IBInspectable public var rounded:Bool = false {
        didSet {
            if rounded {
                self.addRoundedCorners();
            }
        }
    }
    
    @IBInspectable public var hasDropShadow:Bool = false {
        didSet {
            if (hasDropShadow) {
                self.addDropShadow();
            } else {
                // TO HANDLER
            }
        }
    }

    @IBInspectable public var fontName:String = "fontRegular" {
        didSet {
            if let txtField:UITextField = self.textField {
                txtField.font = UIFont(name: SyncedConstants.constant(forKey: fontName) ?? txtField.font!.fontName, size: UIView.convertFontSizeToRatio(txtField.font!.pointSize, fontStyle: fontStyle, sizedForIPad:self.sizeForIPad));
            }
        }
    }
    
    @IBInspectable public var fontStyle:String = "medium" {
        didSet {
            if let txtField:UITextField = self.textField {
                txtField.font = UIFont(name: SyncedConstants.constant(forKey: fontName) ?? txtField.font!.fontName, size: UIView.convertFontSizeToRatio(txtField.font!.pointSize, fontStyle: fontStyle, sizedForIPad:self.sizeForIPad));
            }
        }
    }
    
    @IBInspectable public var fontColorStyle:String? = nil {
        didSet {
            if let txtField:UITextField = self.textField {
                txtField.textColor = SyncedColors.color(forKey: fontColorStyle);
            }
        }
    }
    
    @IBInspectable public var searchBarIcon:UIImage? = nil {
        didSet {
            self.setImage(searchBarIcon, forSearchBarIcon: UISearchBarIcon.Search, state: UIControlState.Normal);
        }
    } //P.E.
    
    private var _placeholderKey:String?
    override public var placeholder: String? {
        get {
            return super.placeholder;
        }
        
        set {
            if let key:String = newValue where key.hasPrefix("#") == true{
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
    
    override public func awakeFromNib() {
        super.awakeFromNib();
        //--
        self.commontInit();
    } //F.E.
    
    private func commontInit() {
        if let placeHoldertxt:String = self.placeholder where placeHoldertxt.hasPrefix("#") == true{
            self.placeholder = placeHoldertxt; // Assigning again to set value from synced data
        }
    } //F.E.

    
    public func updateView() {
        if let plcHKey:String = _placeholderKey {
            self.placeholder = plcHKey;
        }
        
        if let bgCStyle:String = self.bgColorStyle {
            self.bgColorStyle = bgCStyle;
        }
        
        if let fBgCStyle:String = self.fontBgColorStyle {
            self.fontBgColorStyle = fBgCStyle;
        }
        
        if let boarderCStyle:String = self.boarderColorStyle {
            self.boarderColorStyle = boarderCStyle;
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
