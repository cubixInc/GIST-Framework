//
//  BaseUINavigationController.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 14/06/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit

/// BaseUINavigationController is a subclass of UINavigationController. It has some extra proporties and support for SyncEngine.
open class BaseUINavigationController: UINavigationController {

    //MARK: - Properties
    
    /// Flag for whether to resize the values for iPad.
    @IBInspectable open var sizeForIPad:Bool = GIST_CONFIG.sizeForIPad;
    
    /// Navigation background Color key from SyncEngine.
    @IBInspectable open var bgColor:String? = nil {
        didSet {
            self.navigationBar.barTintColor = SyncedColors.color(forKey:bgColor);
            
            //Fixing black line issue when the navigation is transparent
            if self.navigationBar.barTintColor?.cgColor.alpha == 0 {
                self.hasSeparator = false;
            }
        }
    } //P.E.
    
    /// Navigation tint Color key from SyncEngine.
    @IBInspectable open var tintColor:String? = nil {
        didSet {
            self.navigationBar.tintColor = SyncedColors.color(forKey:tintColor);
        }
    } //P.E.
    
     /// Font name key from Sync Engine.
    @IBInspectable open var fontName:String = GIST_CONFIG.fontName {
        didSet {
            var attrDict:[NSAttributedStringKey : Any] = self.navigationBar.titleTextAttributes  ?? [NSAttributedStringKey : Any]()
            attrDict[NSAttributedStringKey.font] = UIFont.font(fontName, fontStyle: fontStyle, sizedForIPad: self.sizeForIPad);
            self.navigationBar.titleTextAttributes = attrDict;
            
        }
    } //P.E.
    
    @IBInspectable open var largeFontName:String = GIST_CONFIG.fontName {
        didSet {
            if #available(iOS 11.0, *) {
                var attrDict:[NSAttributedStringKey : Any] = self.navigationBar.largeTitleTextAttributes  ?? [NSAttributedStringKey : Any]()
                
                attrDict[NSAttributedStringKey.font] = UIFont.font(largeFontName, fontStyle: largeFontStyle, sizedForIPad: self.sizeForIPad);
                self.navigationBar.largeTitleTextAttributes = attrDict
            }
        }
    } //P.E.
    
    /// Font size/style key from Sync Engine.
    @IBInspectable open var fontStyle:String = GIST_CONFIG.fontStyle {
        didSet {
            var attrDict:[NSAttributedStringKey : Any] = self.navigationBar.titleTextAttributes  ?? [NSAttributedStringKey : Any]()
            attrDict[NSAttributedStringKey.font] = UIFont.font(fontName, fontStyle: fontStyle, sizedForIPad: self.sizeForIPad);
            self.navigationBar.titleTextAttributes = attrDict;
        }
    } //P.E.
    
    @IBInspectable open var largeFontStyle:String = GIST_CONFIG.largeFontStyle {
        didSet {

            if #available(iOS 11.0, *) {
                var attrDict:[NSAttributedStringKey : Any] = self.navigationBar.largeTitleTextAttributes  ?? [NSAttributedStringKey : Any]()
                attrDict[NSAttributedStringKey.font] = UIFont.font(largeFontName, fontStyle: largeFontStyle, sizedForIPad: self.sizeForIPad);
                
                self.navigationBar.largeTitleTextAttributes = attrDict
            } else {
                // Fallback on earlier versions
            };
        }
    } //P.E.
    
    /// Font color key from Sync Engine.
    @IBInspectable open var fontColor:String? = nil {
        didSet {
            var attrDict:[NSAttributedStringKey : Any] = self.navigationBar.titleTextAttributes ?? [NSAttributedStringKey : Any]();
            attrDict[NSAttributedStringKey.foregroundColor] = SyncedColors.color(forKey: fontColor);
            self.navigationBar.titleTextAttributes = attrDict;
            
            if #available(iOS 11.0, *) {
                var lAttrDict:[NSAttributedStringKey : Any] = self.navigationBar.largeTitleTextAttributes  ?? [NSAttributedStringKey : Any]()
                lAttrDict[NSAttributedStringKey.foregroundColor] = SyncedColors.color(forKey: fontColor);
                
                self.navigationBar.largeTitleTextAttributes = lAttrDict
            }
        }
    } //P.E.
    
    /// Flag for Navigation Separator Line - default value is true
    @IBInspectable open var hasSeparator:Bool = true {
        didSet {
            if (!hasSeparator) {
                self.navigationBar.setBackgroundImage(UIImage(), for: .default);
                self.navigationBar.shadowImage = UIImage();
            } else {
                self.navigationBar.setBackgroundImage(nil, for: .default);
                self.navigationBar.shadowImage = nil;
            }
        }
    } //P.E.
    
     /// Flag for Navigation bar Shadow - default value is false
    @IBInspectable open var shadow:Bool = false {
        didSet {
            if (shadow != oldValue) {
                if (shadow) {
                    self.navigationBar.layer.shadowColor = UIColor.black.cgColor;
                    self.navigationBar.layer.shadowOffset = CGSize(width:2.0, height:2.0);
                    self.navigationBar.layer.shadowRadius = 3.0; //Default is 3.0
                    self.navigationBar.layer.shadowOpacity = 1.0;
                } else {
                    self.navigationBar.layer.shadowOpacity = 0.0;
                }
            }
        }
    } //P.E.

    private (set) var _completion:((Bool, Any?) -> Void)?
    
    //MARK: - Constructors
    
    /// Overridden constructor to setup/ initialize components.
    ///
    /// - Parameter rootViewController: Root View Controller of Navigation
    override public init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController);
    } //F.E.
    
    
    /// Overridden constructor to setup/ initialize components.
    ///
    /// - Parameters:
    ///   - nibNameOrNil: Nib Name
    ///   - nibBundleOrNil: Nib Bundle Name
    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil);
    } //F.E.
    
    /// Required constructor implemented.
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!;
    } //F.E.
    
    //MARK: - Overridden Methods
    
    /// Overridden method to setup/ initialize components.
    override open func viewDidLoad() {
        super.viewDidLoad();
        
        self.updateAppearance();
    } //F.E.

    /// Overridden method to receive memory warning.
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
    } //F.E.
    
    //MARK: - Methods
    
    /// Updating the appearance of Navigation Bar.
    private func updateAppearance() {
        //Update Font
        var attrDict:[NSAttributedStringKey : Any] = self.navigationBar.titleTextAttributes  ?? [NSAttributedStringKey : Any]()
        attrDict[NSAttributedStringKey.font] = UIFont.font(fontName, fontStyle: fontStyle, sizedForIPad: self.sizeForIPad);
        
        self.navigationBar.titleTextAttributes = attrDict;
        
        if #available(iOS 11.0, *) {
            var attrDict:[NSAttributedStringKey : Any] = self.navigationBar.titleTextAttributes  ?? [NSAttributedStringKey : Any]()
            attrDict[NSAttributedStringKey.font] = UIFont.font(largeFontName, fontStyle: largeFontStyle, sizedForIPad: self.sizeForIPad);
            
            self.navigationBar.largeTitleTextAttributes = attrDict
        }

        //Re-assigning if there are any changes from server
        
        if let newBgColor = bgColor {
            self.bgColor = newBgColor;
        }
        
        if let newTintColor = tintColor {
            self.tintColor = newTintColor;
        }
        
        if let newFontColor = fontColor {
            self.fontColor = newFontColor;
        }
        
    } //F.E.
    
    //Completion Blocks
    open func setOnCompletion(completion: @escaping (_ success:Bool, _ data:Any?) -> Void) {
        _completion = completion;
    } //F.E.
    
    open func completion(_ success:Bool, _ data:Any?) {
        _completion?(success, data);
    } //F.E.
} //F.E.
