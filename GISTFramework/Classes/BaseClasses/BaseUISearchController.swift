//
//  BaseUISearchController.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 30/09/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit

/// BaseUISearchController is a subclass of UISearchController. It has some extra proporties and support for SyncEngine.
open class BaseUISearchController: UISearchController {

    //MARK: - Properties
    
    /// Flag for whether to resize the values for iPad.
    @IBInspectable open var sizeForIPad:Bool = GIST_GLOBAL.sizeForIPad;
    
    /// Background color key from Sync Engine.
    @IBInspectable open var bgColorStyle:String? = nil {
        didSet {
            self.searchBar.backgroundColor = SyncedColors.color(forKey: bgColorStyle);
        }
    }
    
    /// Search text field background color key from Sync Engine.
    @IBInspectable open var fontBgColorStyle:String? = nil {
        didSet {
            if let txtField:UITextField = self.searchBar.textField {
                txtField.backgroundColor =  SyncedColors.color(forKey: fontBgColorStyle);
            }
        }
    }
    
    /// Search tint color key from Sync Engine.
    @IBInspectable open var tintColorStyle:String? = nil {
        didSet {
            self.searchBar.tintColor =  SyncedColors.color(forKey: tintColorStyle);
        }
    }
    
    /// Search bar tint color key from Sync Engine.
    @IBInspectable open var barTintColorStyle:String? = nil {
        didSet {
            self.searchBar.barTintColor =  SyncedColors.color(forKey: barTintColorStyle);
        }
    }
    
    /// Width of View Border.
    @IBInspectable open var border:Int = 0 {
        didSet {
            if let borderCStyle:String = borderColorStyle {
                self.searchBar.addBorder(SyncedColors.color(forKey: borderCStyle), width: border)
            }
        }
    }
    
    /// Border color key from Sync Engine.
    @IBInspectable open var borderColorStyle:String? = nil {
        didSet {
            if let borderCStyle:String = borderColorStyle {
                self.searchBar.addBorder(SyncedColors.color(forKey: borderCStyle), width: border)
            }
        }
    }
    
    /// Corner Radius for View.
    @IBInspectable open var cornerRadius:Int = 0 {
        didSet {
            self.searchBar.addRoundedCorners(GISTUtility.convertToRatio(CGFloat(cornerRadius), sizedForIPad: sizeForIPad));
        }
    }
    
    /// Flag for making circle/rounded view.
    @IBInspectable open var rounded:Bool = false {
        didSet {
            if rounded {
                self.searchBar.addRoundedCorners();
            }
        }
    }
    
    /// Flag for Drop Shadow.
    @IBInspectable open var hasDropShadow:Bool = false {
        didSet {
            if (hasDropShadow) {
                self.searchBar.addDropShadow();
            } else {
                // TO HANDLER
            }
        }
    }
    
    /// Font name key from Sync Engine.
    @IBInspectable open var fontName:String = GIST_GLOBAL.fontName {
        didSet {
            if let txtField:UITextField = self.searchBar.textField {
                txtField.font = UIFont.font(fontName, fontStyle: fontStyle, sizedForIPad: self.sizeForIPad);
            }
        }
    }
    
    /// Font size/style key from Sync Engine.
    @IBInspectable open var fontStyle:String = GIST_GLOBAL.fontStyle {
        didSet {
            if let txtField:UITextField = self.searchBar.textField {
                txtField.font = UIFont.font(fontName, fontStyle: fontStyle, sizedForIPad: self.sizeForIPad);
            }
        }
    }
    
    /// Font color key from Sync Engine.
    @IBInspectable open var fontColorStyle:String? = nil {
        didSet {
            if let txtField:UITextField = self.searchBar.textField {
                txtField.textColor = SyncedColors.color(forKey: fontColorStyle);
            }
        }
    }
    
    /// Inspectable property for search bar icon image.
    @IBInspectable open var searchBarIcon:UIImage? = nil {
        didSet {
            self.searchBar.setImage(searchBarIcon, for: UISearchBarIcon.search, state: UIControlState());
        }
    }
    
    private var _placeholderKey:String?
    
    /// placeholder text propery to set text from SyncEngine (Hint '#' prefix).
    open var placeholder: String? {
        get {
            return self.searchBar.placeholder;
        }
        
        set {
            if let key:String = newValue , key.hasPrefix("#") == true{
                _placeholderKey = key; // holding key for using later
                 
                self.searchBar.placeholder = SyncedText.text(forKey: key);
            } else {
                self.searchBar.placeholder = newValue;
            }
        }
    }
    
    //MARK: - Constructors
    
    /// Overridden constructor to setup/ initialize components.
    ///
    /// - Parameters:
    ///   - nibNameOrNil: Nib Name
    ///   - nibBundleOrNil: Nib Bundle Name
    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil);
    } //C.E.
    
    /// Overridden constructor to setup/ initialize components.
    ///
    /// - Parameters:
    ///   - searchResultsController: Search Results View Controller
    override public init(searchResultsController: UIViewController?) {
        super.init(searchResultsController: searchResultsController);
         
        self.commontInit();
    } //F.E.
    
    /// Required constructor implemented.
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    } //F.E.
    
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
        
        if let txtField:UITextField = self.searchBar.textField {
            txtField.font = UIFont.font(fontName, fontStyle: fontStyle, sizedForIPad: self.sizeForIPad);
        }
    } //F.E.

    /// Updates layout and contents from SyncEngine. this is a protocol method BaseView that is called when the view is refreshed.
    func updateView() {
        //Update Font
        if let txtField:UITextField = self.searchBar.textField {
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
