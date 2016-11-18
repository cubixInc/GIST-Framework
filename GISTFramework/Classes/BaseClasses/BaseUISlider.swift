//
//  BaseUISlider.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 14/06/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit

open class BaseUISlider: UISlider, BaseView {

    @IBInspectable open var minColorStyle:String? = nil {
        didSet {
            self.minimumTrackTintColor = SyncedColors.color(forKey: minColorStyle);
        }
    }
    
    @IBInspectable open var maxColorStyle:String? = nil {
        didSet {
            self.maximumTrackTintColor = SyncedColors.color(forKey: maxColorStyle);
        }
    }
    
    @IBInspectable open var thumbColorStyle:String? = nil {
        didSet {
            self.thumbTintColor = SyncedColors.color(forKey: thumbColorStyle);
        }
    }
    
    /// Overridden method to setup/ initialize components.
    override open func awakeFromNib() {
        super.awakeFromNib();
    } //F.E.
    
    /// Updates layout and contents from SyncEngine. this is a protocol method BaseView that is called when the view is refreshed.
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
