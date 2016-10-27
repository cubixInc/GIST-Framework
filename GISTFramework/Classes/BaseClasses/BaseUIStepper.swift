//
//  BaseUIStepper.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 14/06/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit

open class BaseUIStepper: UIStepper, BaseView {
   
    @IBInspectable open var tintColorStyle:String? = nil {
        didSet {
            self.tintColor = SyncedColors.color(forKey: tintColorStyle);
        }
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
    } //F.E.
    
    open func updateView(){
        if let tintCStyle = self.tintColorStyle {
            self.tintColorStyle = tintCStyle;
        }
    } //F.E.
    
} //CLS END
