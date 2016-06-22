//
//  BaseUISlider.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 14/06/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit

public class BaseUISlider: UISlider, BaseView {

    @IBInspectable var minColorStyle:String! = nil;
    @IBInspectable var maxColorStyle:String! = nil;
    @IBInspectable var thumbColorStyle:String! = nil;
    
    override public func awakeFromNib() {
        super.awakeFromNib();
        //--
        self.updateView();
    } //F.E.
    
    public func updateView() {
        
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
