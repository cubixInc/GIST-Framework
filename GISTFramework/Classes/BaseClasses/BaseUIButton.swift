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
            self.backgroundColor = SyncedColors.color(forKey: (self.selected == true) ? bgSelectedColorStyle:bgColorStyle);
        }
    }
    
    @IBInspectable public var bgSelectedColorStyle:String? = nil {
        didSet {
            self.backgroundColor = SyncedColors.color(forKey: (self.selected == true) ? bgSelectedColorStyle:bgColorStyle);
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
            self.titleLabel?.font = UIFont(name: SyncedConstants.constant(forKey: fontName) ?? self.titleLabel!.font.fontName, size: UIView.convertFontSizeToRatio(self.titleLabel!.font.pointSize, fontStyle: fontStyle, sizedForIPad:self.sizeForIPad));
        }
    }
    
    @IBInspectable public var fontStyle:String = "medium" {
        didSet {
            self.titleLabel?.font = UIFont(name: SyncedConstants.constant(forKey: fontName) ?? self.titleLabel!.font.fontName, size: UIView.convertFontSizeToRatio(self.titleLabel!.font.pointSize, fontStyle: fontStyle, sizedForIPad:self.sizeForIPad));
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
            self.backgroundColor = SyncedColors.color(forKey: (selected == true) ? bgSelectedColorStyle:bgColorStyle);
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
        //--
//        self.contentMode = UIViewContentMode.ScaleAspectFit;  //this is needed for some reason, won't work without it.
        
        
        //--
        /*
         THIS WAS BREAKING THE CONSTRAINTS
         
        self.imageView?.contentMode = UIViewContentMode.ScaleAspectFit;
        
        for view:UIView in self.subviews {
            view.contentMode = UIViewContentMode.ScaleAspectFit;
        }
        */
    } //F.E.
    
    func commontInit() {
        self.exclusiveTouch = true;
        
        self.titleLabel?.font = UIFont(name: SyncedConstants.constant(forKey: fontName) ?? self.titleLabel!.font.fontName, size: UIView.convertFontSizeToRatio(self.titleLabel!.font.pointSize, fontStyle: fontStyle, sizedForIPad:self.sizeForIPad));
        
        //Updating text with synced data
        if let txt:String = self.titleLabel?.text where txt.hasPrefix("#") == true {
            self.setTitle(txt, forState: state); // Assigning again to set value from synced data
        } else if _titleKey != nil {
            self.setTitle(_titleKey, forState: state);
        }
    } //F.E.
    
    public func updateView() {
        self.titleLabel?.font = UIFont(name: SyncedConstants.constant(forKey: fontName) ?? self.titleLabel!.font.fontName, size: UIView.convertFontSizeToRatio(self.titleLabel!.font.pointSize, fontStyle: fontStyle, sizedForIPad:self.sizeForIPad));
        
        if let bgCStyle:String = self.bgColorStyle {
            self.bgColorStyle = bgCStyle;
        }
        
        if let boarderCStyle:String = self.boarderColorStyle {
            self.boarderColorStyle = boarderCStyle;
        }
        
        if let fntClrStyle = self.fontColorStyle {
            self.fontColorStyle = fntClrStyle;
        }
        
        if let fntSelClrStyle = self.fontSelectedColorStyle {
            self.fontSelectedColorStyle = fntSelClrStyle;
        }
        
        if let txtKey:String = _titleKey {
            self.setTitle(txtKey, forState: state);
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
