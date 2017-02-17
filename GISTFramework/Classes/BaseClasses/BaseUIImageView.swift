//
//  BaseImageView.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 14/06/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit

/// BaseUIImageView is a subclass of UIImageView and implements BaseView. It extents UIImageView with some extra proporties and supports SyncEngine.
open class BaseUIImageView: UIImageView, BaseView {

    //MARK: - Properties
    
    /// Flag for whether to resize the values for iPad.
    @IBInspectable open var sizeForIPad:Bool = GIST_GLOBAL.sizeForIPad;
    
    /// Background color key from Sync Engine.
    @IBInspectable open var bgColorStyle:String? = nil {
        didSet {
            self.backgroundColor = SyncedColors.color(forKey: bgColorStyle);
        }
    } //P.E.
    
    /// Width of View Border.
    @IBInspectable open var border:Int = 0 {
        didSet {
            if let borderCStyle:String = borderColorStyle {
                self.addBorder(SyncedColors.color(forKey: borderCStyle), width: border)
            }
        }
    } //P.E.
    
    /// Border color key from Sync Engine.
    @IBInspectable open var borderColorStyle:String? = nil {
        didSet {
            if let borderCStyle:String = borderColorStyle {
                self.addBorder(SyncedColors.color(forKey: borderCStyle), width: border)
            }
        }
    } //P.E.
    
    /// Corner Radius for View.
    @IBInspectable open var cornerRadius:Int = 0 {
        didSet {
            self.addRoundedCorners(GISTUtility.convertToRatio(CGFloat(cornerRadius), sizedForIPad: sizeForIPad));
        }
    } //P.E.
    
    /// Flag for making circle/rounded view.
    @IBInspectable open var rounded:Bool = false {
        didSet {
            if rounded {
                self.addRoundedCorners();
            }
        }
    } //P.E.
    
    /// Flag for Drop Shadow.
    @IBInspectable open var hasDropShadow:Bool = false {
        didSet {
            if (hasDropShadow) {
                self.addDropShadow();
            } else {
                // TO HANDLER
            }
        }
    } //P.E.
    
    @IBInspectable open var respectRTL:Bool = GIST_GLOBAL.respectRTL {
        didSet {
            if (respectRTL != oldValue && self.respectRTL && GIST_GLOBAL.isRTL) {
                super.image = self.image?.mirrored();
            }
        }
    } //P.E.
    
    open override var image: UIImage? {
        get {
            return super.image;
        }
        
        set {
            if (self.respectRTL && GIST_GLOBAL.isRTL) {
                super.image = newValue?.mirrored();
            } else {
                super.image = newValue;
            }
            
        }
    } //P.E.
    
    //MARK: - Overridden Methods
    
    /// Overridden method to setup/ initialize components.
    override open func awakeFromNib() {
        super.awakeFromNib();
        
        self.clipsToBounds = true;
        
        if (self.respectRTL && GIST_GLOBAL.isRTL) {
            super.image = self.image?.mirrored();
        }
    } //F.E.
    
    /// Overridden methed to update layout.
    override open func layoutSubviews() {
        super.layoutSubviews();
        
        if rounded {
            self.addRoundedCorners();
        }
    } //F.E.
    
    //MARK: - Methods
    
    /// Updates layout and contents from SyncEngine. this is a protocol method BaseView that is called when the view is refreshed.
    func updateView() {
        
        //Re-assigning if there are any changes from server
        if let bgCStyle:String = self.bgColorStyle {
            self.bgColorStyle = bgCStyle;
        }
        
        if let borderCStyle:String = self.borderColorStyle {
            self.borderColorStyle = borderCStyle;
        }
    } //F.E.
    
} //CLS END
