//
//  BaseUISearchController.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 30/09/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit

open class BaseUISearchController: UISearchController {

    @IBInspectable open var sizeForIPad:Bool = false;
    
    @IBInspectable open var bgColorStyle:String? = nil {
        didSet {
            self.searchBar.backgroundColor = SyncedColors.color(forKey: bgColorStyle);
        }
    }
    
    @IBInspectable open var fontBgColorStyle:String? = nil {
        didSet {
            if let txtField:UITextField = self.searchBar.textField {
                txtField.backgroundColor =  SyncedColors.color(forKey: fontBgColorStyle);
            }
        }
    }
    
    @IBInspectable open var tintColorStyle:String? = nil {
        didSet {
            self.searchBar.tintColor =  SyncedColors.color(forKey: tintColorStyle);
        }
    }
    
    @IBInspectable open var barTintColorStyle:String? = nil {
        didSet {
            self.searchBar.barTintColor =  SyncedColors.color(forKey: barTintColorStyle);
        }
    }
    
    @IBInspectable open var border:Int = 0 {
        didSet {
            if let borderCStyle:String = borderColorStyle {
                self.searchBar.addBorder(SyncedColors.color(forKey: borderCStyle), width: border)
            }
        }
    }
    
    @IBInspectable open var borderColorStyle:String? = nil {
        didSet {
            if let borderCStyle:String = borderColorStyle {
                self.searchBar.addBorder(SyncedColors.color(forKey: borderCStyle), width: border)
            }
        }
    }
    
    @IBInspectable open var cornerRadius:Int = 0 {
        didSet {
            self.searchBar.addRoundedCorners(GISTUtility.convertToRatio(CGFloat(cornerRadius), sizedForIPad: sizeForIPad));
        }
    }
    
    @IBInspectable open var rounded:Bool = false {
        didSet {
            if rounded {
                self.searchBar.addRoundedCorners();
            }
        }
    }
    
    @IBInspectable open var hasDropShadow:Bool = false {
        didSet {
            if (hasDropShadow) {
                self.searchBar.addDropShadow();
            } else {
                // TO HANDLER
            }
        }
    }
    
    @IBInspectable open var fontName:String = "fontRegular" {
        didSet {
            if let txtField:UITextField = self.searchBar.textField {
                txtField.font = UIFont.font(fontName, fontStyle: fontStyle, sizedForIPad: self.sizeForIPad);
            }
        }
    }
    
    @IBInspectable open var fontStyle:String = "medium" {
        didSet {
            if let txtField:UITextField = self.searchBar.textField {
                txtField.font = UIFont.font(fontName, fontStyle: fontStyle, sizedForIPad: self.sizeForIPad);
            }
        }
    }
    
    @IBInspectable open var fontColorStyle:String? = nil {
        didSet {
            if let txtField:UITextField = self.searchBar.textField {
                txtField.textColor = SyncedColors.color(forKey: fontColorStyle);
            }
        }
    }
    
    @IBInspectable open var searchBarIcon:UIImage? = nil {
        didSet {
            self.searchBar.setImage(searchBarIcon, for: UISearchBarIcon.search, state: UIControlState());
        }
    }
    
    fileprivate var _placeholderKey:String?
    open var placeholder: String? {
        get {
            return self.searchBar.placeholder;
        }
        
        set {
            if let key:String = newValue , key.hasPrefix("#") == true{
                _placeholderKey = key; // holding key for using later
                //--
                self.searchBar.placeholder = SyncedText.text(forKey: key);
            } else {
                self.searchBar.placeholder = newValue;
            }
        }
    }
    
    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil);
    } //C.E.
    
    override public init(searchResultsController: UIViewController?) {
        super.init(searchResultsController: searchResultsController);
        //--
        self.commontInit();
    } //F.E.
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    } //F.E.
    
    override open func awakeFromNib() {
        super.awakeFromNib();
        //--
        self.commontInit();
    } //F.E.
    
    override open func viewDidLoad() {
        super.viewDidLoad()
    } //F.E.

    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func commontInit() {
        if let placeHoldertxt:String = self.placeholder , placeHoldertxt.hasPrefix("#") == true{
            self.placeholder = placeHoldertxt; // Assigning again to set value from synced data
        }
    } //F.E.
    
    open func updateView() {
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
