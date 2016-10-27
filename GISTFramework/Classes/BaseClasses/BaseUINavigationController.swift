//
//  BaseUINavigationController.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 14/06/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit

open class BaseUINavigationController: UINavigationController {

    fileprivate var _lastSyncedDate:String?
    
    @IBInspectable open var bgColor:String? = nil {
        didSet {
            self.navigationBar.barTintColor = SyncedColors.color(forKey:bgColor);
        }
    }
    
    @IBInspectable open var tintColor:String? = nil {
        didSet {
            self.navigationBar.tintColor = SyncedColors.color(forKey:tintColor);
        }
    }
    
    @IBInspectable open var fontKey:String? = nil;
    
    @IBInspectable open var fontStyle:String? = nil {
        didSet {
            var attrDict:[String : Any] = self.navigationBar.titleTextAttributes  ?? [String : Any]()
            //--
            attrDict[NSFontAttributeName] = UIFont.font(fontKey, fontStyle: fontStyle);
            
            self.navigationBar.titleTextAttributes = attrDict;
        }
    }
    
    @IBInspectable open var fontColor:String? = nil {
        didSet {
            var attrDict:[String : Any] = self.navigationBar.titleTextAttributes ?? [String : Any]();
            //--
            attrDict[NSForegroundColorAttributeName] = SyncedColors.color(forKey: fontColor);
            
            self.navigationBar.titleTextAttributes = attrDict;
        }
    }
    
    @IBInspectable open var hasShadow:Bool = true {
        didSet {
            if (hasShadow == false) {
                self.navigationBar.shadowImage = UIImage();
            }
        }
    }
    
    override public init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController);
    } //F.E.
    
    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil);
    } //F.E.
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!;
    } //F.E.
    
    override open func viewDidLoad() {
        super.viewDidLoad();
        //--
         _lastSyncedDate = SyncEngine.lastSyncedServerDate;
    } //F.E.

    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
    } //F.E.
    
    fileprivate func updateAppearance() {
        //Re-assigning if there are changes from server
        
        if let newBgColor = bgColor {
            self.bgColor = newBgColor;
        }
        
        if let newTintColor = tintColor {
            self.tintColor = newTintColor;
        }
        
        if let newFontStyle = fontStyle {
            self.fontStyle = newFontStyle;
        }
        
        if let newFontColor = fontColor {
            self.fontColor = newFontColor;
        }
        
    } //F.E.
    
    override open func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if (self.topViewController == nil || !self.topViewController!.isEqual(viewController)) {
            super.pushViewController(viewController, animated: animated);
        }
    } //F.E.
    
    @discardableResult open func updateSyncedData() -> Bool {
        if let syncedDate:String = SyncEngine.lastSyncedServerDate , syncedDate != _lastSyncedDate {
            _lastSyncedDate = syncedDate;
            //--
            
            //Update preference
            self.updateAppearance();
            
            return true;
        } else {
            return false;
        }
    } //F.E.
} //F.E.
