//
//  BaseUISlider.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 14/06/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit

public class BaseUISlider: UISlider, BaseView {

    @IBInspectable public var minColorStyle:String? = nil {
        didSet {
            self.minimumTrackTintColor = SyncedColors.color(forKey: minColorStyle);
        }
    }
    
    @IBInspectable public var maxColorStyle:String? = nil {
        didSet {
            self.maximumTrackTintColor = SyncedColors.color(forKey: maxColorStyle);
        }
    }
    
    @IBInspectable public var thumbColorStyle:String? = nil {
        didSet {
            self.thumbTintColor = SyncedColors.color(forKey: thumbColorStyle);
        }
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib();
    } //F.E.
    
    public func updateView() {
        if let minCStyle = self.minColorStyle {
            self.minColorStyle = minCStyle;
        }
        
        if let maxCStyle = self.maxColorStyle {
            self.maxColorStyle = maxCStyle;
        }
        
        if let thumbCStyle = self.thumbColorStyle {
            self.thumbColorStyle = thumbCStyle;
        }
        
    } //F.E.
    
} //CLS END
