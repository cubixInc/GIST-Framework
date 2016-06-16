//
//  BaseUIStepper.swift
//  eGrocery
//
//  Created by Muneeba Meer on 06/03/2015.
//  Copyright (c) 2015 cubixlabs. All rights reserved.
//

import UIKit

class BaseUIStepper: UIStepper, BaseView {
   
    @IBInspectable var tintColorStyle:String! = nil;
    
    override func awakeFromNib() {
        
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
