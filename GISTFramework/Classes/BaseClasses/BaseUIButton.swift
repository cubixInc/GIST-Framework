//
//  BaseButton.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 14/06/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit

public class BaseUIButton: UIButton, BaseView {
    @IBInspectable public var bgColorStyle:String! = nil;
    @IBInspectable public var bgSelectedColorStyle:String! = nil;

    @IBInspectable public var boarder:Int = 0;
    @IBInspectable public var boarderColorStyle:String! = nil;
    
    @IBInspectable public var cornerRadius:Int = 0;
    
    @IBInspectable public var rounded:Bool = false;
    
    @IBInspectable public var fontName:String = "fontRegular";
    
    @IBInspectable public var fontStyle:String = "medium";
    @IBInspectable public var fontColorStyle:String! = nil;
    @IBInspectable public var fontSelectedColorStyle:String! = nil;
    
    @IBInspectable public var hasDropShadow:Bool = false;
    
    @IBInspectable public var sizeForIPad:Bool = false ;
    
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
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        //--
        self.updateView()
        //--
//        self.contentMode = UIViewContentMode.ScaleAspectFit;  //this is needed for some reason, won't work without it.
        
        self.exclusiveTouch = true;
        //--
        self.imageView?.contentMode = UIViewContentMode.ScaleAspectFit;
        
        for view:UIView in self.subviews {
            view.contentMode = UIViewContentMode.ScaleAspectFit;
        }
    } //F.E.
    
    public func updateView() {
        
        self.titleLabel?.font = UIFont(name: SyncedConstants.constant(forKey: fontName) ?? self.titleLabel!.font.fontName, size: UIView.convertFontSizeToRatio(self.titleLabel!.font.pointSize, fontStyle: fontStyle, sizedForIPad:self.sizeForIPad));
        
        if (fontColorStyle != nil) {
            self.setTitleColor(SyncedColors.color(forKey: fontColorStyle), forState: UIControlState.Normal);
        }
        
        if (fontSelectedColorStyle != nil) {
            self.setTitleColor(SyncedColors.color(forKey: fontSelectedColorStyle), forState: UIControlState.Selected);
        }
        
        if let txt:String = self.titleLabel?.text where txt.hasPrefix("#") == true {
            self.setTitle(txt, forState: state); // Assigning again to set value from synced data
        } else if _titleKey != nil {
            self.setTitle(_titleKey, forState: state);
        }
        
        if (boarder > 0) {
            self.addBorder(SyncedColors.color(forKey: boarderColorStyle), width: boarder)
        }
        
        if (bgColorStyle != nil) {
            self.backgroundColor = SyncedColors.color(forKey: bgColorStyle);
        }
        
        if (cornerRadius != 0) {
            self.addRoundedCorners(UIView.convertToRatio(CGFloat(cornerRadius), sizedForIPad: sizeForIPad));
        }
        
        if (hasDropShadow) {
            self.addDropShadow();
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
