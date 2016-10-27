//
//  BaseView.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 14/06/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit

open class BaseUIView: UIView, BaseView {
    
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
    
    override open func awakeFromNib() {
        super.awakeFromNib()
    } //F.E.
    
    open func updateView(){
        if let bgCStyle:String = self.bgColorStyle {
            self.bgColorStyle = bgCStyle;
        }
        
        if let borderCStyle:String = self.borderColorStyle {
            self.borderColorStyle = borderCStyle;
        }
    } //F.E.
    
    override open func layoutSubviews() {
        super.layoutSubviews();
        //--
        if rounded {
            self.addRoundedCorners();
        }
    } //F.E.
    
} //CLS END
