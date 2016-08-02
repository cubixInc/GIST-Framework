//
//  BaseUISwitch.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 14/06/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit

public class BaseUISwitch: UISwitch, BaseView {
    
    @IBInspectable public var onColorStyle:String? = nil {
        didSet {
            self.onTintColor = SyncedColors.color(forKey: onColorStyle);
        }
    }
    //--
    @IBInspectable public var thumbColorStyle:String? = nil {
        didSet {
            self.thumbTintColor = SyncedColors.color(forKey: thumbColorStyle);
        }
    }
    
    //--
    override public func awakeFromNib() {
        super.awakeFromNib()
        //--
        self.updateView()
    } //F.E.
    
    public func updateView(){
        if let onCStyle = self.onColorStyle {
            self.onColorStyle = onCStyle;
        }
        
        if let thumbCStyle = self.thumbColorStyle {
            self.thumbColorStyle = thumbCStyle;
        }
    } //F.E.
} //CLS END
