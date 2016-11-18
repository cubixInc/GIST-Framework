//
//  BaseButton.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 14/06/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit

/// BaseUIButton is subclass of UIButton and implements BaseView. It extents UIButton with some extra proporties to support SyncEngine
open class BaseUIButton: UIButton, BaseView {
    
    //MARK: - Properties
    
    /// Flag for whether to resize the values for iPad.
    @IBInspectable open var sizeForIPad:Bool = false;
    
    @IBInspectable open var bgColorStyle:String? = nil {
        didSet {
            self.backgroundColor = SyncedColors.color(forKey: ((self.isSelected == true) && (bgSelectedColorStyle != nil)) ? bgSelectedColorStyle:bgColorStyle);
        }
    }
    
    @IBInspectable open var bgSelectedColorStyle:String? = nil {
        didSet {
            self.backgroundColor = SyncedColors.color(forKey: (self.isSelected == true) ? bgSelectedColorStyle:bgColorStyle);
        }
    }

    @IBInspectable open var border:Int = 0 {
        didSet {
            if let borderCStyle:String = borderColorStyle {
                self.addBorder(SyncedColors.color(forKey: borderCStyle), width: border)
            }
        }
    }
    
    @IBInspectable open var borderColorStyle:String? = nil {
        didSet {
            if let borderCStyle:String = borderColorStyle {
                self.addBorder(SyncedColors.color(forKey: borderCStyle), width: border)
            }
        }
    }
    
    @IBInspectable open var cornerRadius:Int = 0 {
        didSet {
            self.addRoundedCorners(GISTUtility.convertToRatio(CGFloat(cornerRadius), sizedForIPad: sizeForIPad));
        }
    }
    
    @IBInspectable open var rounded:Bool = false {
        didSet {
            if rounded {
                self.addRoundedCorners();
            }
        }
    }
    
    @IBInspectable open var hasDropShadow:Bool = false {
        didSet {
            if (hasDropShadow) {
                self.addDropShadow();
            } else {
                // TO HANDLER
            }
        }
    }
    
    @IBInspectable open var fontName:String = "fontRegular" {
        didSet {
            self.titleLabel?.font = UIFont.font(fontName, fontStyle: fontStyle, sizedForIPad: self.sizeForIPad);
        }
    }
    
    @IBInspectable open var fontStyle:String = "medium" {
        didSet {
            self.titleLabel?.font = UIFont.font(fontName, fontStyle: fontStyle, sizedForIPad: self.sizeForIPad);
        }
    }
    
    @IBInspectable open var fontColorStyle:String? = nil {
        didSet {
            self.setTitleColor(SyncedColors.color(forKey: fontColorStyle), for: UIControlState());
        }
    }
    
    @IBInspectable open var fontSelectedColorStyle:String? = nil {
        didSet {
            self.setTitleColor(SyncedColors.color(forKey: fontSelectedColorStyle), for: UIControlState.selected);
        }
    }
    
    override open var isSelected:Bool {
        get  {
            return super.isSelected;
        }
        
        set {
            super.isSelected = newValue;
            //--
            if (bgColorStyle != nil && bgSelectedColorStyle != nil) {
                self.backgroundColor = SyncedColors.color(forKey: (newValue == true) ? bgSelectedColorStyle:bgColorStyle);
            }
        }
    } //P.E.
    
    private var _titleKey:String?;
    
    //MARK: - Constructors
    
    /// Overridden constructor to setup/ initialize components.
    ///
    /// - Parameter frame: View frame
    public override init(frame: CGRect) {
        super.init(frame: frame);
        //--
        self.commontInit();
    } //C.E.
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    //MARK: - Methods
    
    /// Overridden method to setup/ initialize components.
    override open func awakeFromNib() {
        super.awakeFromNib()
        //--
        self.commontInit()
    } //F.E.
    
    /// Common initazier for setting up items.
    func commontInit() {
        self.isExclusiveTouch = true;
        
        self.titleLabel?.font = UIFont.font(fontName, fontStyle: fontStyle, sizedForIPad: self.sizeForIPad);
        
        //Updating text with synced data
        if let txt:String = self.titleLabel?.text , txt.hasPrefix("#") == true {
            self.setTitle(txt, for: state); // Assigning again to set value from synced data
        } else if _titleKey != nil {
            self.setTitle(_titleKey, for: state);
        }
    } //F.E.
    
    /// Updates layout and contents from SyncEngine. this is a protocol method BaseView that is called when the view is refreshed.
    public func updateView() {
        self.titleLabel?.font = UIFont.font(fontName, fontStyle: fontStyle, sizedForIPad: self.sizeForIPad);
        
        if let bgCStyle:String = self.bgColorStyle {
            self.bgColorStyle = bgCStyle;
        }
        
        if let borderCStyle:String = self.borderColorStyle {
            self.borderColorStyle = borderCStyle;
        }
        
        if let fntClrStyle = self.fontColorStyle {
            self.fontColorStyle = fntClrStyle;
        }
        
        if let fntSelClrStyle = self.fontSelectedColorStyle {
            self.fontSelectedColorStyle = fntSelClrStyle;
        }
        
        if let txtKey:String = _titleKey {
            self.setTitle(txtKey, for: state);
        }
    } //F.E.
    
    
    /// Overridden methed to update layout.
    override open func layoutSubviews() {
        super.layoutSubviews();
        //--
        if rounded {
            self.addRoundedCorners();
        }
    } //F.E.
    
    
    /// Overridden method to set title using Sync Engine key (#)
    ///
    /// - Parameters:
    ///   - title: Button Title
    ///   - state: Button State
    override open func setTitle(_ title: String?, for state: UIControlState) {
        if let key:String = title , key.hasPrefix("#") == true{
            //--
            _titleKey = key;  // holding key for using later
            super.setTitle(SyncedText.text(forKey: key), for: state);
        } else {
            super.setTitle(title, for: state);
        }
    } //F.E.
    
} //CLS END
