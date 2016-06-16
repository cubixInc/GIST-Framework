//
//  BaseUISwitch.swift
//  eGrocery
//
//  Created by Shoaib on 2/25/15.
//  Copyright (c) 2015 cubixlabs. All rights reserved.
//

import UIKit

class BaseUISwitch: UISwitch, BaseView {
    
    @IBInspectable var onColorStyle:String! = nil;
    //--
    @IBInspectable var thumbColorStyle:String! = nil;
    
    //--
    override func awakeFromNib() {
        super.awakeFromNib()
        //--
        self.updateView()
    } //F.E.
    
    func updateView(){
        if (onColorStyle != nil) {
            self.onTintColor = SyncedColors.color(forKey: onColorStyle);
        }
        
        if (thumbColorStyle != nil) {
            self.thumbTintColor = SyncedColors.color(forKey: thumbColorStyle);
        }
    } //F.E.
} //CLS END
