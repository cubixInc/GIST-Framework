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
    @IBInspectable open var sizeForIPad:Bool = GIST_GLOBAL.sizeForIPad;
    
    /// Navigation background Color key from SyncEngine.
    @IBInspectable open var bgColor:String? = nil {
        didSet {
            self.navigationBar.barTintColor = SyncedColors.color(forKey:bgColor);
            
            //Fixing black line issue when the navigation is transparent
            if self.navigationBar.barTintColor?.cgColor.alpha == 0 {
                self.navigationBar.setBackgroundImage(UIImage(), for: .default);
                self.navigationBar.shadowImage = UIImage();
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
    @IBInspectable open var fontName:String = GIST_GLOBAL.fontName {
        didSet {
            var attrDict:[String : Any] = self.navigationBar.titleTextAttributes  ?? [String : Any]()
             
            attrDict[NSFontAttributeName] = UIFont.font(fontName, fontStyle: fontStyle, sizedForIPad: self.sizeForIPad);
            
            self.navigationBar.titleTextAttributes = attrDict;
        }
    } //P.E.
    
    /// Font size/style key from Sync Engine.
    @IBInspectable open var fontStyle:String = GIST_GLOBAL.fontStyle {
        didSet {
            var attrDict:[String : Any] = self.navigationBar.titleTextAttributes  ?? [String : Any]()
             
            attrDict[NSFontAttributeName] = UIFont.font(fontName, fontStyle: fontStyle, sizedForIPad: self.sizeForIPad);
            
            self.navigationBar.titleTextAttributes = attrDict;
        }
    } //P.E.
    
    /// Font color key from Sync Engine.
    @IBInspectable open var fontColor:String? = nil {
        didSet {
            var attrDict:[String : Any] = self.navigationBar.titleTextAttributes ?? [String : Any]();
             
            attrDict[NSForegroundColorAttributeName] = SyncedColors.color(forKey: fontColor);
            
            self.navigationBar.titleTextAttributes = attrDict;
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
    
    private var _lastSyncedDate:String?
    
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
         
         _lastSyncedDate = SyncEngine.lastSyncedServerDate;
    } //F.E.

    /// Overridden method to receive memory warning.
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
    } //F.E.
    
    //MARK: - Methods
    
    /// Updating the appearance of Navigation Bar.
    private func updateAppearance() {
        //Update Font
        var attrDict:[String : Any] = self.navigationBar.titleTextAttributes  ?? [String : Any]()
        attrDict[NSFontAttributeName] = UIFont.font(fontName, fontStyle: fontStyle, sizedForIPad: self.sizeForIPad);
        
        self.navigationBar.titleTextAttributes = attrDict;
        
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
    
    /// Recursive update of layout and content from Sync Engine.
    @discardableResult func updateSyncedData() -> Bool {
        if let syncedDate:String = SyncEngine.lastSyncedServerDate , syncedDate != _lastSyncedDate {
            _lastSyncedDate = syncedDate;
             
            
            //Update preference
            self.updateAppearance();
            
            return true;
        } else {
            return false;
        }
    } //F.E.
} //F.E.
