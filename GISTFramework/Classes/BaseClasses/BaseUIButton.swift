//
//  BaseButton.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 14/06/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit

/// BaseUIButton is a subclass of UIButton and implements BaseView. It extents UIButton with some extra proporties and supports SyncEngine.
open class BaseUIButton: UIButton, BaseView {
    
    //MARK: - Properties
    
    /// Flag for whether to resize the values for iPad.
    @IBInspectable open var sizeForIPad:Bool = GIST_GLOBAL.sizeForIPad;
    
    /// Background color key from Sync Engine.
    @IBInspectable open var bgColorStyle:String? = nil {
        didSet {
            self.backgroundColor = SyncedColors.color(forKey: ((self.isSelected == true) && (bgSelectedColorStyle != nil)) ? bgSelectedColorStyle:bgColorStyle);
        }
    } //P.E.
    
    /// Selected state background color key from Sync Engine.
    @IBInspectable open var bgSelectedColorStyle:String? = nil {
        didSet {
            self.backgroundColor = SyncedColors.color(forKey: (self.isSelected == true) ? bgSelectedColorStyle:bgColorStyle);
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
    
    /// Font name key from Sync Engine.
    @IBInspectable open var fontName:String = GIST_GLOBAL.fontName {
        didSet {
            self.titleLabel?.font = UIFont.font(fontName, fontStyle: fontStyle, sizedForIPad: self.sizeForIPad);
        }
    } //P.E.
    
    /// Font size/style key from Sync Engine.
    @IBInspectable open var fontStyle:String = GIST_GLOBAL.fontStyle {
        didSet {
            self.titleLabel?.font = UIFont.font(fontName, fontStyle: fontStyle, sizedForIPad: self.sizeForIPad);
        }
    } //P.E.
    
    /// Font color key from Sync Engine.
    @IBInspectable open var fontColorStyle:String? = nil {
        didSet {
            self.setTitleColor(SyncedColors.color(forKey: fontColorStyle), for: UIControlState.normal);
        }
    } //P.E.
    
    /// Selected state font color key from Sync Engine.
    @IBInspectable open var fontSelectedColorStyle:String? = nil {
        didSet {
            self.setTitleColor(SyncedColors.color(forKey: fontSelectedColorStyle), for: UIControlState.selected);
        }
    } //P.E.
    
    @IBInspectable open var respectRTL:Bool = GIST_GLOBAL.respectRTL {
        didSet {
            if (respectRTL != oldValue && self.respectRTL && GIST_GLOBAL.isRTL) {
                
                let states:[UIControlState] = [.normal, .selected, .highlighted, .disabled]
                
                for state in states {
                    if let img = self.image(for: state) {
                        super.setImage(img.mirrored(), for: state);
                    }
                }
            }
        }
    } //P.E.
    
    /// Overridden property to handle layouts for different status.
    override open var isSelected:Bool {
        get  {
            return super.isSelected;
        }
        
        set {
            super.isSelected = newValue;
            
            if (bgColorStyle != nil && bgSelectedColorStyle != nil) {
                self.backgroundColor = SyncedColors.color(forKey: (newValue == true) ? bgSelectedColorStyle:bgColorStyle);
            }
        }
    } //P.E.
    
//    private var _titleKey:String?;
    private var _titleKeys:[UInt:String] = [UInt:String]();
    
    //MARK: - Constructors
    
    /// Overridden constructor to setup/ initialize components.
    ///
    /// - Parameter frame: View frame
    public override init(frame: CGRect) {
        super.init(frame: frame);
        
        self.commontInit();
    } //C.E.
    
    /// Required constructor implemented.
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    //MARK: - Overridden Methods
    
    /// Overridden method to setup/ initialize components.
    override open func awakeFromNib() {
        super.awakeFromNib()
        
        self.commontInit()
    } //F.E.
    
    /// Overridden methed to update layout.
    override open func layoutSubviews() {
        super.layoutSubviews();
         
        if rounded {
            self.addRoundedCorners();
        }
    } //F.E.
    
    
    /// Overridden method to set title using Sync Engine key (Hint '#').
    ///
    /// - Parameters:
    ///   - title: Button Title
    ///   - state: Button State
    override open func setTitle(_ title: String?, for state: UIControlState) {
        if let key:String = title , key.hasPrefix("#") == true{
            _titleKeys[state.rawValue] = key;  // holding key for using later
            super.setTitle(SyncedText.text(forKey: key), for: state);
        } else {
            super.setTitle(title, for: state);
        }
    } //F.E.
    
    open override func setImage(_ image: UIImage?, for state: UIControlState) {
        super.setImage( (self.respectRTL && GIST_GLOBAL.isRTL) ? image?.mirrored() : image, for: state)
    } //F.E.
    
    //MARK: - Methods
    
    /// Common initazier for setting up items.
    func commontInit() {
        self.isExclusiveTouch = true;
        
        self.titleLabel?.font = UIFont.font(fontName, fontStyle: fontStyle, sizedForIPad: self.sizeForIPad);
        
        //Updating text with synced data
        let states:[UIControlState] = [.normal, .selected, .highlighted, .disabled]
        
        for state in states {
            // Assigning again to set value from synced data
            if let txt:String = self.title(for: state), txt.hasPrefix("#") == true {
                self.setTitle(txt, for: state);
            } else if let txtKey:String = _titleKeys[state.rawValue] {
                self.setTitle(txtKey, for: state);
            }
            
            if self.respectRTL, GIST_GLOBAL.isRTL, let img:UIImage = self.image(for: state) {
                super.setImage(img.mirrored(), for: state);
            }
        }
        
    } //F.E.
    
    /// Updates layout and contents from SyncEngine. this is a protocol method BaseView that is called when the view is refreshed.
    func updateView() {
        //Setting font
        self.titleLabel?.font = UIFont.font(fontName, fontStyle: fontStyle, sizedForIPad: self.sizeForIPad);
        
        //Re-assigning if there are any changes from server
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
        
        for i:UInt in _titleKeys.keys {
            if let key:String = _titleKeys[i] {
              self.setTitle(key, for: UIControlState(rawValue: i));
            }
        }
    } //F.E.
    
} //CLS END
