//
//  BaseButton.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 14/06/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit

public class BaseUIButton: UIButton, BaseView {
    
    @IBInspectable public var sizeForIPad:Bool = false;
    
    @IBInspectable public var bgColorStyle:String? = nil {
        didSet {
            self.backgroundColor = SyncedColors.color(forKey: ((self.selected == true) && (bgSelectedColorStyle != nil)) ? bgSelectedColorStyle:bgColorStyle);
        }
    }
    
    @IBInspectable public var bgSelectedColorStyle:String? = nil {
        didSet {
            self.backgroundColor = SyncedColors.color(forKey: (self.selected == true) ? bgSelectedColorStyle:bgColorStyle);
        }
    }

    @IBInspectable public var border:Int = 0 {
        didSet {
            if let borderCStyle:String = borderColorStyle {
                self.addBorder(SyncedColors.color(forKey: borderCStyle), width: border)
            }
        }
    }
    
    @IBInspectable public var borderColorStyle:String? = nil {
        didSet {
            if let borderCStyle:String = borderColorStyle {
                self.addBorder(SyncedColors.color(forKey: borderCStyle), width: border)
            }
        }
    }
    
    @IBInspectable public var cornerRadius:Int = 0 {
        didSet {
            self.addRoundedCorners(GISTUtility.convertToRatio(CGFloat(cornerRadius), sizedForIPad: sizeForIPad));
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
            self.titleLabel?.font = UIFont.font(fontName, fontStyle: fontStyle, sizedForIPad: self.sizeForIPad);
        }
    }
    
    @IBInspectable public var fontStyle:String = "medium" {
        didSet {
            self.titleLabel?.font = UIFont.font(fontName, fontStyle: fontStyle, sizedForIPad: self.sizeForIPad);
        }
    }
    
    @IBInspectable public var fontColorStyle:String? = nil {
        didSet {
            self.setTitleColor(SyncedColors.color(forKey: fontColorStyle), forState: UIControlState.Normal);
        }
    }
    
    @IBInspectable public var fontSelectedColorStyle:String? = nil {
        didSet {
            self.setTitleColor(SyncedColors.color(forKey: fontSelectedColorStyle), forState: UIControlState.Selected);
        }
    }
    
    override public var selected:Bool {
        get  {
            return super.selected;
        }
        
        set {
            super.selected = newValue;
            //--
            if (bgColorStyle != nil && bgSelectedColorStyle != nil) {
                self.backgroundColor = SyncedColors.color(forKey: (newValue == true) ? bgSelectedColorStyle:bgColorStyle);
            }
        }
    } //P.E.
    
    public override init(frame: CGRect) {
        super.init(frame: frame);
        //--
        self.commontInit();
    } //C.E.
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        //--
        self.commontInit()
    } //F.E.
    
    func commontInit() {
        self.exclusiveTouch = true;
        
        self.titleLabel?.font = UIFont.font(fontName, fontStyle: fontStyle, sizedForIPad: self.sizeForIPad);
        
        //Updating text with synced data
        if let txt:String = self.titleLabel?.text where txt.hasPrefix("#") == true {
            self.setTitle(txt, forState: UIControlState.Normal); // Assigning again to set value from synced data
        } else if _titleKey != nil {
            self.setTitle(_titleKey, forState: UIControlState.Normal);
        }
    } //F.E.
    
    public func updateView() {
        self.titleLabel?.font = UIFont.font(fontName, fontStyle: fontStyle, sizedForIPad: self.sizeForIPad);
        
        if let bgCStyle:String = self.bgColorStyle {
            self.bgColorStyle = bgCStyle;
        }
        
        if let borderCStyle:String = self.borderColorStyle {
            self.borderColorStyle = borderCStyle;
        }
        
        if let fntClrStyle = self.fontColorStyle {
            self.fontColorStyle = fntClrStyle;
        }
        
        if let fntSelClrStyle = self.fontSelectedColorStyle {
            self.fontSelectedColorStyle = fntSelClrStyle;
        }
        
        if let txtKey:String = _titleKey {
            self.setTitle(txtKey, forState: UIControlState.Normal);
        }
    } //F.E.
    
    override public func layoutSubviews() {
        super.layoutSubviews();
        //--
        if rounded {
            self.addRoundedCorners();
        }
    } //F.E.
    
    private var _titleKey:String?;
    
    override public func setTitle(title: String?, forState state: UIControlState) {
        if let key:String = title where key.hasPrefix("#") == true{
            //--
            _titleKey = key;  // holding key for using later
            super.setTitle(SyncedText.text(forKey: key), forState: state);
        } else {
            super.setTitle(title, forState: state);
        }
    } //F.E.
    
} //CLS END
