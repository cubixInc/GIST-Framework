//
//  BaseUISlider.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 14/06/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit

/// BaseUISlider is a subclass of UISlider and implements BaseView. It has some extra proporties and support for SyncEngine.
open class BaseUISlider: UISlider, BaseView {

    /// Minimum track tint color key from SyncEngine.
    @IBInspectable open var minColorStyle:String? = nil {
        didSet {
            self.minimumTrackTintColor = SyncedColors.color(forKey: minColorStyle);
        }
    }
    
    /// Maximum track tint color key from SyncEngine.
    @IBInspectable open var maxColorStyle:String? = nil {
        didSet {
            self.maximumTrackTintColor = SyncedColors.color(forKey: maxColorStyle);
        }
    }
    
    /// Thumb tint color key from SyncEngine.
    @IBInspectable open var thumbColorStyle:String? = nil {
        didSet {
            self.thumbTintColor = SyncedColors.color(forKey: thumbColorStyle);
        }
    }
    
    //MARK: - Overridden Methods
    
    /// Overridden method to setup/ initialize components.
    override open func awakeFromNib() {
        super.awakeFromNib();
    } //F.E.
    
    
} //CLS END
