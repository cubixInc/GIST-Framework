//
//  BaseTableView.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 14/06/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit

public class BaseUITableView: UITableView, BaseView {
    
    @IBInspectable var bgColorStyle:String! = nil;
    
    @IBInspectable var boarder:Int = 0;
    @IBInspectable var boarderColorStyle:String! = nil;
    
    @IBInspectable var cornerRadius:Int = 0;
    
    @IBInspectable var rounded:Bool = false;
    
    @IBInspectable var hasDropShadow:Bool = false;
    
    @IBInspectable var tintColorStyle:String! = nil;
    
    override public func awakeFromNib() {
        
        super.awakeFromNib()
        //--
        self.updateView()
    } //F.E.
    
    public func updateView(){
        if (tintColorStyle != nil) {
            self.tintColor = SyncedColors.color(forKey: tintColorStyle);
        }
        
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
    } //F.E.
    
    override public func layoutSubviews() {
        super.layoutSubviews();
        //--
        if rounded {
            self.addRoundedCorners();
        }
    } //F.E.
} //CLS END
