//
//  BaseUITableViewHeaderFooterView.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 17/08/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit

public class BaseUITableViewHeaderFooterView: UITableViewHeaderFooterView, BaseView {
    private var _data:AnyObject?
    public var data:AnyObject? {
        get {
            return _data;
        }
    } //P.E.
    
    @IBInspectable public var sizeForIPad:Bool = false;
    
    @IBInspectable public var bgColorStyle:String? = nil {
        didSet {
            guard (self.bgColorStyle != oldValue) else {
                return;
            }
            
            if (self.backgroundView == nil) {
                self.backgroundView = UIView();
            }
            
            self.backgroundView!.backgroundColor = SyncedColors.color(forKey: bgColorStyle);
        }
    }
    
    @IBInspectable public var tintColorStyle:String? = nil {
        didSet {
            guard (self.tintColorStyle != oldValue) else {
                return;
            }
            
            self.tintColor = SyncedColors.color(forKey: tintColorStyle);
        }
    }
    
    @IBInspectable public var fontName:String? = "fontRegular" {
        didSet {
            guard (self.fontName != oldValue) else {
                return;
            }
            
            self.textLabel?.font = UIFont.font(self.fontName, fontStyle: self.fontTitleStyle, sizedForIPad: sizeForIPad);
            
            self.detailTextLabel?.font = UIFont.font(self.fontName, fontStyle: self.fontDetailStyle, sizedForIPad: sizeForIPad);
        }
    }
    
    @IBInspectable public var fontTitleStyle:String? = "medium" {
        didSet {
            guard (self.fontTitleStyle != oldValue) else {
                return;
            }
            
            self.textLabel?.font = UIFont.font(self.fontName, fontStyle: self.fontTitleStyle, sizedForIPad: sizeForIPad);
        }
    }
    
    @IBInspectable public var fontDetailStyle:String? = "fontRegular" {
        didSet {
            guard (self.fontDetailStyle != oldValue) else {
                return;
            }
            
            self.detailTextLabel?.font = UIFont.font(self.fontName, fontStyle: self.fontDetailStyle, sizedForIPad: sizeForIPad);
        }
    }
    
    @IBInspectable public var fontColor:String? = nil {
        didSet {
            guard (self.fontColor != oldValue) else {
                return;
            }
            
            self.textLabel?.textColor = UIColor.color(forKey: fontColor);
        }
    }
    
    @IBInspectable public var detailColor:String? = nil {
        didSet {
            guard (self.detailColor != oldValue) else {
                return;
            }
            
            self.detailTextLabel?.textColor = UIColor.color(forKey: detailColor);
        }
    }
    
    public override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier);
        
        self.commonInitializer();
    } //F.E.
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder);
    } //F.E.
    
    override public func awakeFromNib() {
        super.awakeFromNib();
        
        self.commonInitializer();
    } //F.E.
    
    private func commonInitializer() {
        self.textLabel?.font = UIFont.font(self.fontName, fontStyle: self.fontTitleStyle, sizedForIPad: sizeForIPad);
        
        self.detailTextLabel?.font = UIFont.font(self.fontName, fontStyle: self.fontDetailStyle, sizedForIPad: sizeForIPad);
    } //F.E.
    
    public func updateView() {
        if let bgCStyle = self.bgColorStyle {
            self.bgColorStyle = bgCStyle;
        }
        
        if let fName = self.fontName {
            self.fontName = fName;
        }
        
        if let fColor = self.fontColor {
            self.fontColor = fColor;
        }
        
        if let dColor = self.detailColor {
            self.detailColor = dColor;
        }
    } //F.E.
    
    override public func updateSyncedData() {
        super.updateSyncedData();
        
        self.contentView.updateSyncedData();
    } //F.E.
    
    public func updateData(data:AnyObject?) {
        _data = data;
        
        self.updateSyncedData();
    } //F.E.
    
} //CLS END
