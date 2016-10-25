//
//  BaseUISearchController.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 30/09/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit

public class BaseUISearchController: UISearchController {

    @IBInspectable public var sizeForIPad:Bool = false;
    
    @IBInspectable public var bgColorStyle:String? = nil {
        didSet {
            self.searchBar.backgroundColor = SyncedColors.color(forKey: bgColorStyle);
        }
    }
    
    @IBInspectable public var fontBgColorStyle:String? = nil {
        didSet {
            if let txtField:UITextField = self.searchBar.textField {
                txtField.backgroundColor =  SyncedColors.color(forKey: fontBgColorStyle);
            }
        }
    }
    
    @IBInspectable public var tintColorStyle:String? = nil {
        didSet {
            self.searchBar.tintColor =  SyncedColors.color(forKey: tintColorStyle);
        }
    }
    
    @IBInspectable public var barTintColorStyle:String? = nil {
        didSet {
            self.searchBar.barTintColor =  SyncedColors.color(forKey: barTintColorStyle);
        }
    }
    
    @IBInspectable public var border:Int = 0 {
        didSet {
            if let borderCStyle:String = borderColorStyle {
                self.searchBar.addBorder(SyncedColors.color(forKey: borderCStyle), width: border)
            }
        }
    }
    
    @IBInspectable public var borderColorStyle:String? = nil {
        didSet {
            if let borderCStyle:String = borderColorStyle {
                self.searchBar.addBorder(SyncedColors.color(forKey: borderCStyle), width: border)
            }
        }
    }
    
    @IBInspectable public var cornerRadius:Int = 0 {
        didSet {
            self.searchBar.addRoundedCorners(GISTUtility.convertToRatio(CGFloat(cornerRadius), sizedForIPad: sizeForIPad));
        }
    }
    
    @IBInspectable public var rounded:Bool = false {
        didSet {
            if rounded {
                self.searchBar.addRoundedCorners();
            }
        }
    }
    
    @IBInspectable public var hasDropShadow:Bool = false {
        didSet {
            if (hasDropShadow) {
                self.searchBar.addDropShadow();
            } else {
                // TO HANDLER
            }
        }
    }
    
    @IBInspectable public var fontName:String = "fontRegular" {
        didSet {
            if let txtField:UITextField = self.searchBar.textField {
                txtField.font = UIFont.font(fontName, fontStyle: fontStyle, sizedForIPad: self.sizeForIPad);
            }
        }
    }
    
    @IBInspectable public var fontStyle:String = "medium" {
        didSet {
            if let txtField:UITextField = self.searchBar.textField {
                txtField.font = UIFont.font(fontName, fontStyle: fontStyle, sizedForIPad: self.sizeForIPad);
            }
        }
    }
    
    @IBInspectable public var fontColorStyle:String? = nil {
        didSet {
            if let txtField:UITextField = self.searchBar.textField {
                txtField.textColor = SyncedColors.color(forKey: fontColorStyle);
            }
        }
    }
    
    @IBInspectable public var searchBarIcon:UIImage? = nil {
        didSet {
            self.searchBar.setImage(searchBarIcon, forSearchBarIcon: UISearchBarIcon.Search, state: UIControlState.Normal);
        }
    }
    
    private var _placeholderKey:String?
    public var placeholder: String? {
        get {
            return self.searchBar.placeholder;
        }
        
        set {
            if let key:String = newValue where key.hasPrefix("#") == true{
                _placeholderKey = key; // holding key for using later
                //--
                self.searchBar.placeholder = SyncedText.text(forKey: key);
            } else {
                self.searchBar.placeholder = newValue;
            }
        }
    }
    
    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
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
    
    override public func awakeFromNib() {
        super.awakeFromNib();
        //--
        self.commontInit();
    } //F.E.
    
    override public func viewDidLoad() {
        super.viewDidLoad()
    } //F.E.

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func commontInit() {
        if let placeHoldertxt:String = self.placeholder where placeHoldertxt.hasPrefix("#") == true{
            self.placeholder = placeHoldertxt; // Assigning again to set value from synced data
        }
    } //F.E.
    
    public func updateView() {
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
