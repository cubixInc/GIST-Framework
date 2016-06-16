//
//  BaseUISlider.swift
//  eGrocery
//
//  Created by Muneeba on 2/2/15.
//  Copyright (c) 2015 cubixlabs. All rights reserved.
//

import UIKit

class BaseUISlider: UISlider, BaseView {

    @IBInspectable var minColorStyle:String! = nil;
    @IBInspectable var maxColorStyle:String! = nil;
    @IBInspectable var thumbColorStyle:String! = nil;
    
    override func awakeFromNib() {
        super.awakeFromNib();
        //--
        self.updateView();
    } //F.E.
    
    func updateView() {
        
        if (minColorStyle != nil) {
            self.minimumTrackTintColor = SyncedColors.color(forKey: minColorStyle);
        }
        
        if (maxColorStyle != nil) {
            self.maximumTrackTintColor = SyncedColors.color(forKey: maxColorStyle);
        }
        
        if (thumbColorStyle != nil) {
            self.thumbTintColor = SyncedColors.color(forKey: thumbColorStyle);
        }
        
        self.setThumbImage(UIImage(), forState: UIControlState.Normal);
    } //F.E.
    
} //F.E.
