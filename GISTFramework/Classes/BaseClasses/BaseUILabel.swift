//
//  BaseLabel.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 14/06/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit

public class BaseUILabel: UILabel, BaseView {
    
    @IBInspectable public var sizeForIPad:Bool = false;
    
    @IBInspectable public var bgColorStyle:String? = nil {
        didSet {
            self.backgroundColor = SyncedColors.color(forKey: bgColorStyle);
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
    
    @IBInspectable public var underlinedText:Bool = false {
        didSet {
            if (underlinedText) {
                let attString:NSMutableAttributedString=NSMutableAttributedString(string: (self.text?.capitalizedString)! as String)
                attString.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.StyleSingle.rawValue , range: NSRange(location: 0, length: attString.length))
                self.attributedText = attString
            } else {
                // TO HANDLER
            }
        }
    }
    
    @IBInspectable public var fontName:String = "fontRegular" {
        didSet {
            self.font = UIFont.font(fontName, fontStyle: fontStyle, sizedForIPad: self.sizeForIPad);
        }
    }
    
    @IBInspectable public var fontStyle:String = "medium" {
        didSet {
            self.font = UIFont.font(fontName, fontStyle: fontStyle, sizedForIPad: self.sizeForIPad);
        }
    }
    
    @IBInspectable public var fontColorStyle:String? = nil {
        didSet {
            self.textColor = SyncedColors.color(forKey: fontColorStyle);
        }
    }
    
    private var _textKey: String?
    override public var text: String? {
        get {
            return super.text;
        }
        
        set {
            if let key:String = newValue where key.hasPrefix("#") == true {
                _textKey = key; // holding key for using later
                
                super.text = SyncedText.text(forKey: key);
            } else {
                super.text = newValue;
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
    } //C.E.
    
    override public func awakeFromNib() {
        super.awakeFromNib();
        //--
        self.commontInit();
    } //F.E.
    
    private func commontInit() {
        self.font = UIFont.font(fontName, fontStyle: fontStyle, sizedForIPad: self.sizeForIPad);
        
        //Updating text with synced data
        if let txt:String = self.text where txt.hasPrefix("#") == true {
            self.text = txt; // Assigning again to set value from synced data
        } else if _textKey != nil {
            self.text = _textKey;
        }
    } //F.E.
    
    public func updateView() {
        self.font = UIFont.font(fontName, fontStyle: fontStyle, sizedForIPad: self.sizeForIPad);
        
        if let bgCStyle:String = self.bgColorStyle {
            self.bgColorStyle = bgCStyle;
        }
        
        if let boarderCStyle:String = self.boarderColorStyle {
            self.boarderColorStyle = boarderCStyle;
        }
        
        if let fntClrStyle = self.fontColorStyle {
            self.fontColorStyle = fntClrStyle;
        }
        
        if let txtKey:String = _textKey {
            self.text = txtKey;
        }
    } //F.E.
    
    override public func layoutSubviews() {
        super.layoutSubviews();
        //--
        //Referesh on update layout
        if rounded {
            self.rounded = true;
        }
    } //F.E.
    
} //CLS END
