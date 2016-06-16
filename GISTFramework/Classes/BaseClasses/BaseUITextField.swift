//
//  BaseTextField.swift
//  E-Grocery
//
//  Created by Muneeba on 1/14/15.
//  Copyright (c) 2015 cubixlabs. All rights reserved.
//

import UIKit

class BaseUITextField: UITextField, BaseView {
   
    @IBInspectable var bgColorStyle:String! = nil;
    
    @IBInspectable var boarder:Int = 0;
    @IBInspectable var boarderColorStyle:String! = nil;
    
    @IBInspectable var cornerRadius:Int = 0;
    
    @IBInspectable var rounded:Bool = false;
    
    @IBInspectable var hasDropShadow:Bool = false;
    
    @IBInspectable var verticalPadding:CGFloat=0
    @IBInspectable var horizontalPadding:CGFloat=0
    
    @IBInspectable var fontStyle:String = "Medium";
    @IBInspectable var fontColorStyle:String! = nil;
    
    private var _placeholderKey:String?
    override var placeholder: String? {
        get {
            return super.placeholder;
        }
        
        set {
            if let key:String = newValue where key.hasPrefix("#") == true{
                
                _placeholderKey = key; // holding key for using later
                
                super.placeholder = SyncedText.text(forKey: key);
            } else {
                super.placeholder = newValue;
            }
        }
    } //P.E.
    
    /*
    private var _textKey:String?
    
    override var text: String? {
        get {
            return super.text;
        }
        
        set {
            if let key:String = newValue where key.hasPrefix("#") == true{
                
                _textKey = key; // holding key for using later
                
                super.text = SyncedStrings.string(forKey: key);
            } else {
                super.text = newValue;
            }
        }
    } //P.E.
    */
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //--
        updateView();
    } //F.E.
    
    func updateView() {
        self.font = UIFont(name: self.font!.fontName, size: UIView.convertFontSizeToRatio(self.font!.pointSize, fontStyle: fontStyle));
        
        if (fontColorStyle != nil) {
            self.textColor = SyncedColors.color(forKey: fontColorStyle);
        }
        
        if (boarder > 0) {
            self.addBorder(SyncedColors.color(forKey: boarderColorStyle), width: boarder)
        }
        
        if (bgColorStyle != nil) {
            self.backgroundColor = SyncedColors.color(forKey: bgColorStyle);
        }
        
        if (cornerRadius != 0) {
            self.addRoundedCorners(UIView.convertToRatio(CGFloat(cornerRadius)));
        }
        
        if(hasDropShadow) {
            self.addDropShadow();
        }
        
        if let placeHoldertxt:String = self.placeholder where placeHoldertxt.hasPrefix("#") == true{
            self.placeholder = placeHoldertxt; // Assigning again to set value from synced data
        } else if _placeholderKey != nil {
            self.placeholder = _placeholderKey;
        }
        
        /*
        if let txt:String = self.text where txt.hasPrefix("#") == true{
            self.text = txt; // Assigning again to set value from synced data
        }
         */
    } //F.E.
    
    override func layoutSubviews() {
        super.layoutSubviews();
        //--
        if rounded {
            self.addRoundedCorners();
        }
    } //F.E.
    
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        //??super.textRectForBounds(bounds)
       
        let x:CGFloat = bounds.origin.x + horizontalPadding
        let y:CGFloat = bounds.origin.y + verticalPadding
        let widht:CGFloat = bounds.size.width - (horizontalPadding * 2)
        let height:CGFloat = bounds.size.height - (verticalPadding * 2)
        
        return CGRectMake(x,y,widht,height)
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        super.editingRectForBounds(bounds)
        return self.textRectForBounds(bounds)
    }
    
} //CLS END
