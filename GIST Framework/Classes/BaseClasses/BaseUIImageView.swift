//
//  BaseImageView.swift
//  E-Grocery
//
//  Created by Muneeba on 1/12/15.
//  Copyright (c) 2015 cubixlabs. All rights reserved.
//

import UIKit

class BaseUIImageView: UIImageView, BaseView {

    @IBInspectable var bgColorStyle:String! = nil;
    
    @IBInspectable var boarder:Int = 0;
    @IBInspectable var boarderColorStyle:String! = nil;
    
    @IBInspectable var cornerRadius:Int = 0;
    
    @IBInspectable var rounded:Bool = false;
    
    @IBInspectable var hasDropShadow:Bool = false;
    
    override func awakeFromNib() {
        super.awakeFromNib();
        //--
        self.updateView();
    } //F.E.
    
    func updateView() {
        if (boarder > 0) {
            self.addBorder(SyncedColors.color(forKey: boarderColorStyle), width: boarder)
        }
        
        if (bgColorStyle != nil) {
            self.backgroundColor = SyncedColors.color(forKey: bgColorStyle);
        }
        
        if (cornerRadius != 0) {
            self.addRoundedCorners(UIView.convertToRatio(CGFloat(cornerRadius)));
        }
        
        if (hasDropShadow) {
            self.addDropShadow();
        }
        //--
        self.clipsToBounds = true;        
    } //F.E.
    
    override func layoutSubviews() {
        super.layoutSubviews();
        //--
        if rounded {
            self.addRoundedCorners();
        }
    } //F.E.

} //CLS END
