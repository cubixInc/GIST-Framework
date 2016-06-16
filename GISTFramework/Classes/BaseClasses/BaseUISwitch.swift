//
//  BaseUISwitch.swift
//  eGrocery
//
//  Created by Shoaib on 2/25/15.
//  Copyright (c) 2015 cubixlabs. All rights reserved.
//

import UIKit

public class BaseUISwitch: UISwitch, BaseView {
    
    @IBInspectable var onColorStyle:String! = nil;
    //--
    @IBInspectable var thumbColorStyle:String! = nil;
    
    //--
    override public func awakeFromNib() {
        super.awakeFromNib()
        //--
        self.updateView()
    } //F.E.
    
    public func updateView(){
        if (onColorStyle != nil) {
            self.onTintColor = SyncedColors.color(forKey: onColorStyle);
        }
        
        if (thumbColorStyle != nil) {
            self.thumbTintColor = SyncedColors.color(forKey: thumbColorStyle);
        }
    } //F.E.
} //CLS END
