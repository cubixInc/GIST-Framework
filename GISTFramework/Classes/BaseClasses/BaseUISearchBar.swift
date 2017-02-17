//
//  BaseUISearchBar.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 14/06/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit

// MARK: - Extension for UISearchBar to get textField instance
extension UISearchBar {
    var textField: UITextField? {
        get {
            return self.value(forKey: "_searchField") as? UITextField
        }
    }
}

/// BaseUISearchBar is a subclass of UISearchBar and implements BaseView. It has some extra proporties and support for SyncEngine.
open class BaseUISearchBar: UISearchBar, BaseView {
    
    //MARK: - Properties
    
    /// Flag for whether to resize the values for iPad.
    @IBInspectable open var sizeForIPad:Bool = GIST_GLOBAL.sizeForIPad;
    
    /// Background color key from Sync Engine.
    @IBInspectable open var bgColorStyle:String? = nil {
        didSet {
            self.backgroundColor = SyncedColors.color(forKey: bgColorStyle);
        }
    } //P.E.
    
    @IBInspectable open var fontBgColorStyle:String? = nil {
        didSet {
            if let txtField:UITextField = self.textField {
                txtField.backgroundColor =  SyncedColors.color(forKey: fontBgColorStyle);
            }
        }
    } //P.E.
    
    @IBInspectable open var tintColorStyle:String? = nil {
        didSet {
            self.tintColor =  SyncedColors.color(forKey: tintColorStyle);
        }
    } //P.E.
    
    @IBInspectable open var barTintColorStyle:String? = nil {
        didSet {
            self.barTintColor =  SyncedColors.color(forKey: barTintColorStyle);
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
            if let txtField:UITextField = self.textField {
                txtField.font = UIFont.font(fontName, fontStyle: fontStyle, sizedForIPad: self.sizeForIPad);
            }
        }
    } //P.E.
    
    /// Font size/style key from Sync Engine.
    @IBInspectable open var fontStyle:String = GIST_GLOBAL.fontStyle {
        didSet {
            if let txtField:UITextField = self.textField {
                txtField.font = UIFont.font(fontName, fontStyle: fontStyle, sizedForIPad: self.sizeForIPad);
            }
        }
    } //P.E.
    
    /// Font color key from Sync Engine.
    @IBInspectable open var fontColorStyle:String? = nil {
        didSet {
            if let txtField:UITextField = self.textField {
                txtField.textColor = SyncedColors.color(forKey: fontColorStyle);
            }
        }
    } //P.E.
    
    /// Inspectable propery for Search bar icon.
    @IBInspectable open var searchBarIcon:UIImage? = nil {
        didSet {
            self.setImage(searchBarIcon, for: UISearchBarIcon.search, state: UIControlState());
        }
    } //P.E.
    
    private var _placeholderKey:String?
    
    /// Overridden property to update text from SyncEngine (Hint '#' prefix).
    override open var placeholder: String? {
        get {
            return super.placeholder;
        }
        
        set {
            if let key:String = newValue , key.hasPrefix("#") == true{
                _placeholderKey = key; // holding key for using later
                 
                super.placeholder = SyncedText.text(forKey: key);
            } else {
                super.placeholder = newValue;
            }
        }
    } //P.E.
    
    //MARK: - Constructors
    
    /// Overridden constructor to setup/ initialize components.
    ///
    /// - Parameter frame: View frame
    override public init(frame: CGRect) {
        super.init(frame: frame);
        
        self.commontInit();
    } //C.E.

    /// Required constructor implemented.
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    } //C.E.
    
    //MARK: - Overridden Methods
    
    /// Overridden method to setup/ initialize components.
    override open func awakeFromNib() {
        super.awakeFromNib();
         
        self.commontInit();
    } //F.E.
    
    //MARK: - Methods
    
    /// Common initazier for setting up items.
    private func commontInit() {
        if let placeHoldertxt:String = self.placeholder , placeHoldertxt.hasPrefix("#") == true{
            self.placeholder = placeHoldertxt; // Assigning again to set value from synced data
        }
        
        if let txtField:UITextField = self.textField {
            txtField.font = UIFont.font(fontName, fontStyle: fontStyle, sizedForIPad: self.sizeForIPad);
        }
    } //F.E.

    /// Updates layout and contents from SyncEngine. this is a protocol method BaseView that is called when the view is refreshed.
    func updateView() {
        //Setting Font
        if let txtField:UITextField = self.textField {
            txtField.font = UIFont.font(fontName, fontStyle: fontStyle, sizedForIPad: self.sizeForIPad);
        }
        
        //Re-assigning if there are any changes from server
        if let plcHKey:String = _placeholderKey {
            self.placeholder = plcHKey;
        }
        
        if let bgCStyle:String = self.bgColorStyle {
            self.bgColorStyle = bgCStyle;
        }
        
        if let fBgCStyle:String = self.fontBgColorStyle {
            self.fontBgColorStyle = fBgCStyle;
        }
        
        if let borderCStyle:String = self.borderColorStyle {
            self.borderColorStyle = borderCStyle;
        }
        
        if let tCStyle = self.tintColorStyle {
            self.tintColorStyle = tCStyle;
        }
        
        if let tBCStyle = self.barTintColorStyle {
            self.barTintColorStyle = tBCStyle;
        }
        
        if let fntClrStyle = self.fontColorStyle {
            self.fontColorStyle = fntClrStyle;
        }
    } //F.E.

} //CLS END
