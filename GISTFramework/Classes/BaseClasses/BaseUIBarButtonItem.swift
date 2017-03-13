//
//  BaseUIBarButtonItem.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 04/12/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit


open class BaseUIBarButtonItem: UIBarButtonItem, BaseView {
    //MARK: - Properties
    
    /// Flag for whether to resize the values for iPad.
    @IBInspectable open var sizeForIPad:Bool = GIST_CONFIG.sizeForIPad;
    
    /// Font name key from Sync Engine.
    @IBInspectable open var fontName:String = GIST_CONFIG.fontName {
        didSet {
            self.font = UIFont.font(fontName, fontStyle: fontStyle, sizedForIPad: self.sizeForIPad);
        }
    }
    
    /// Font size/style key from Sync Engine.
    @IBInspectable open var fontStyle:String = GIST_CONFIG.fontStyle {
        didSet {
            self.font = UIFont.font(fontName, fontStyle: fontStyle, sizedForIPad: self.sizeForIPad);
        }
    }
    
    @IBInspectable open var respectRTL:Bool = GIST_CONFIG.respectRTL {
        didSet {
            if (respectRTL != oldValue && self.respectRTL && GISTUtility.isRTL) {
                super.image = self.image?.mirrored();
            }
        }
    } //P.E.
    
    /// Extended proprty font for Segmented Controler Items
    open var font:UIFont? = nil {
        didSet {
            self.setTitleTextAttributes([NSFontAttributeName:self.font!], for: UIControlState());
        }
    }
    
    private var _titleKey:String?;
    
    open override var title: String? {
        set {
            if let key:String = newValue , key.hasPrefix("#") == true{
                 
                _titleKey = key;  // holding key for using later
                super.title = SyncedText.text(forKey: key);
            } else {
                super.title = newValue;
            }
        }
        
        get {
            return super.title;
        }
    }
    
    open override var image: UIImage? {
        set {
            if (self.respectRTL && GISTUtility.isRTL) {
                super.image = newValue?.mirrored();
            } else {
                super.image = newValue;
            }
        }
        
        get {
            return super.image;
        }
    }
    
    /// Overridden method to setup/ initialize components.
    override open func awakeFromNib() {
        super.awakeFromNib();
        
        self.commontInit();
    } //F.E.
    
    /// Common initazier for setting up items.
    private func commontInit() {
        self.font = UIFont.font(fontName, fontStyle: fontStyle, sizedForIPad: self.sizeForIPad);
        
        //Updating text with synced data
        if let txt:String = self.title , txt.hasPrefix("#") == true {
            self.title = txt; // Assigning again to set value from synced data
        } else if _titleKey != nil {
            self.title = _titleKey
        }
        
        if (self.respectRTL && GISTUtility.isRTL) {
            super.image = self.image?.mirrored();
        }
    } //F.E.
    
    /// Updates layout and contents from SyncEngine. this is a protocol method BaseView that is called when the view is refreshed.
    func updateView(){
        self.font = UIFont.font(fontName, fontStyle: fontStyle, sizedForIPad: self.sizeForIPad);
        
        if let txtKey:String = _titleKey {
            self.title = txtKey
        }
    } //F.E.
    
} //CLS END
