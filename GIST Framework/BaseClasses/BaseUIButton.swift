//
//  BaseButton.swift
//  E-Grocery
//
//  Created by Muneeba on 1/12/15.
//  Copyright (c) 2015 cubixlabs. All rights reserved.
//

import UIKit

class BaseUIButton: UIButton, BaseView {
    
    @IBInspectable var bgColorStyle:String! = nil;
    @IBInspectable var bgSelectedColorStyle:String! = nil;

    @IBInspectable var boarder:Int = 0;
    @IBInspectable var boarderColorStyle:String! = nil;
    
    @IBInspectable var cornerRadius:Int = 0;
    
    @IBInspectable var rounded:Bool = false;
    
    @IBInspectable var fontStyle:String = "Medium";
    @IBInspectable var fontColorStyle:String! = nil;
    @IBInspectable var fontSelectedColorStyle:String! = nil;
    
    @IBInspectable var hasDropShadow:Bool = false;
    
    @IBInspectable var sizeForIPad:Bool = false ;
    
    override var selected:Bool {
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
    
    override func awakeFromNib() {
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
    
    func updateView() {
        self.titleLabel?.font = UIFont(name: self.titleLabel!.font.fontName, size: UIView.convertFontSizeToRatio(self.titleLabel!.font.pointSize, fontStyle: fontStyle, sizedForIPad:self.sizeForIPad));
        
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
    
    override func layoutSubviews() {
        super.layoutSubviews();
        //--
        if rounded {
            self.addRoundedCorners();
        }
    } //F.E.
    
    private var _titleKey:String?;
    
    override func setTitle(title: String?, forState state: UIControlState) {
        if let key:String = title where key.hasPrefix("#") == true{
            //--
            _titleKey = key;  // holding key for using later
            super.setTitle(SyncedText.text(forKey: key), forState: state);
        } else {
            super.setTitle(title, forState: state);
        }
    } //F.E.
    
} //CLS END
