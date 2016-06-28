//
//  BaseUIStepper.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 14/06/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit

public class BaseUIStepper: UIStepper, BaseView {
   
    @IBInspectable public var tintColorStyle:String! = nil;
    
    override public func awakeFromNib() {
        
        super.awakeFromNib()
        //--
        self.updateView()
    } //F.E.
    
    func updateView(){
        if (tintColorStyle != nil) {
            self.tintColor = SyncedColors.color(forKey: tintColorStyle);
        }
    } //F.E.
}
