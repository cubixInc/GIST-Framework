//
//  BaseTableView.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 14/06/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit

public class BaseUITableView: UITableView, BaseView {
    
    @IBInspectable public var sizeForIPad:Bool = false;
    
    @IBInspectable public var bgColorStyle:String? = nil {
        didSet {
            self.backgroundColor = SyncedColors.color(forKey: bgColorStyle);
        }
    }
    
    @IBInspectable public var tintColorStyle:String? = nil {
        didSet {
            self.tintColor = SyncedColors.color(forKey: tintColorStyle);
        }
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
    } //F.E.
    
    public func updateView(){
        if let tintCStyle = tintColorStyle {
            self.tintColorStyle = tintCStyle;
        }
        
        if let bgCStyle = self.bgColorStyle {
            self.bgColorStyle = bgCStyle;
        }
        
    } //F.E.
    
    override public func layoutSubviews() {
        super.layoutSubviews();
    } //F.E.
} //CLS END
