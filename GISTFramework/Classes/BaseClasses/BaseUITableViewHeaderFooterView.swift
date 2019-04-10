//
//  BaseUITableViewHeaderFooterView.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 17/08/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit

/// BaseUITableViewHeaderFooterView is a subclass of UITableViewHeaderFooterView and implements BaseView. It has some extra proporties and support for SyncEngine.
open class BaseUITableViewHeaderFooterView: UITableViewHeaderFooterView, BaseView {
    
    //MARK: - Properties
    
    /// Flag for whether to resize the values for iPad.
    @IBInspectable open var sizeForIPad:Bool = GIST_CONFIG.sizeForIPad;
    
    /// Background color key from Sync Engine.
    @IBInspectable open var bgColorStyle:String? = nil {
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
    
    /// Tint color key from SyncEngine.
    @IBInspectable open var tintColorStyle:String? = nil {
        didSet {
            guard (self.tintColorStyle != oldValue) else {
                return;
            }
             
            self.tintColor = SyncedColors.color(forKey: tintColorStyle);
        }
    }
    
    /// Font name key from Sync Engine.
    @IBInspectable open var fontName:String? = GIST_CONFIG.fontName {
        didSet {
            guard (self.fontName != oldValue) else {
                return;
            }
             
            self.textLabel?.font = UIFont.font(self.fontName, fontStyle: self.fontStyle, sizedForIPad: sizeForIPad);
            
            self.detailTextLabel?.font = UIFont.font(self.fontName, fontStyle: self.detailFontStyle, sizedForIPad: sizeForIPad);
        }
    }
    
    /// Font size/ style key from Sync Engine.
    @IBInspectable open var fontStyle:String? = GIST_CONFIG.fontStyle {
        didSet {
            guard (self.fontStyle != oldValue) else {
                return;
            }
             
            self.textLabel?.font = UIFont.font(self.fontName, fontStyle: self.fontStyle, sizedForIPad: sizeForIPad);
        }
    }
    
    /// Font Color key from SyncEngine.
    @IBInspectable open var fontColor:String? = nil {
        didSet {
            guard (self.fontColor != oldValue) else {
                return;
            }
             
            self.textLabel?.textColor = UIColor.color(forKey: fontColor);
        }
    }
    
    /// Detail Text Font size/ style key from Sync Engine.
    @IBInspectable open var detailFontStyle:String? = GIST_CONFIG.fontStyle {
        didSet {
            guard (self.detailFontStyle != oldValue) else {
                return;
            }
             
            self.detailTextLabel?.font = UIFont.font(self.fontName, fontStyle: self.detailFontStyle, sizedForIPad: sizeForIPad);
        }
    }
    
    /// Detail Text Font Color key from SyncEngine.
    @IBInspectable open var detailFontColor:String? = nil {
        didSet {
            guard (self.detailFontColor != oldValue) else {
                return;
            }
             
            self.detailTextLabel?.textColor = UIColor.color(forKey: detailFontColor);
        }
    }
    
    private var _data:Any?
    
    /// Holds Table View Header/Footer View Data.
    open var data:Any? {
        get {
            return _data;
        }
    } //P.E.
    
    //MARK: - Constructors
    
    /// Overridden constructor to setup/ initialize components.
    ///
    /// - Parameter reuseIdentifier: Reuse identifier
    public override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier);
         
        self.commonInit();
    } //F.E.
    
    /// Required constructor implemented.
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder);
    } //F.E.
    
    //MARK: - Overridden Methods
    
    /// Overridden method to setup/ initialize components.
    override open func awakeFromNib() {
        super.awakeFromNib();
         
        self.commonInit();
    } //F.E.
    
    /// Recursive update of layout and content from Sync Engine.
    override func updateSyncedData() {
        super.updateSyncedData();
         
        self.contentView.updateSyncedData();
    } //F.E.
    
    //MARK: - Methods
    
    /// A common initializer to setup/initialize sub components.
    private func commonInit() {
        self.textLabel?.font = UIFont.font(self.fontName, fontStyle: self.fontStyle, sizedForIPad: sizeForIPad);
        
        self.detailTextLabel?.font = UIFont.font(self.fontName, fontStyle: self.detailFontStyle, sizedForIPad: sizeForIPad);
    } //F.E.
    
    /// Updates layout and contents from SyncEngine. this is a protocol method BaseView that is called when the view is refreshed.
    func updateView() {
        if let bgCStyle = self.bgColorStyle {
            self.bgColorStyle = bgCStyle;
        }
        
        if let fName = self.fontName {
            self.fontName = fName;
        }
        
        if let fColor = self.fontColor {
            self.fontColor = fColor;
        }
        
        if let dColor = self.detailFontColor {
            self.detailFontColor = dColor;
        }
    } //F.E.
    
    /// This method should be called in cellForRowAt:indexPath. it also must be overriden in all sub classes of BaseUITableViewHeaderFooterView to update the table view header/Footer view content.
    ///
    /// - Parameter data: Header View Data
    open func updateData(_ data:Any?) {
        _data = data;
         
        self.updateSyncedData();
    } //F.E.
    
} //CLS END
