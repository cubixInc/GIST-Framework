//
//  BaseUINavigationController.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 14/06/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit

public class BaseUINavigationController: UINavigationController {

    @IBInspectable public var bgColor:String? = nil {
        didSet {
            self.navigationBar.barTintColor = SyncedColors.color(forKey:bgColor);
            self.navigationBar.translucent = true;
        }
    }
    
    @IBInspectable public var tintColor:String? = nil {
        didSet {
            self.navigationBar.tintColor = SyncedColors.color(forKey:tintColor);
        }
    }
    
    @IBInspectable public var fontKey:String? = nil;
    
    @IBInspectable public var fontStyle:String? = nil {
        didSet {
            var attrDict:[String : AnyObject] = self.navigationBar.titleTextAttributes ?? [String : AnyObject]()
            //--
            attrDict[NSFontAttributeName] = UIView.font(SyncedConstants.constant(forKey: fontKey ?? ""), fontStyle: fontStyle);
            
            self.navigationBar.titleTextAttributes = attrDict;
        }
    }
    
    @IBInspectable public var fontColor:String? = nil {
        didSet {
            var attrDict:[String : AnyObject] = self.navigationBar.titleTextAttributes ?? [String : AnyObject]();
            //--
            attrDict[NSForegroundColorAttributeName] = SyncedColors.color(forKey: fontColor);
            
            self.navigationBar.titleTextAttributes = attrDict;
        }
    }
    
    @IBInspectable public var hasShadow:Bool = true {
        didSet {
            if (hasShadow == false) {
                self.navigationBar.shadowImage = UIImage();
            }
        }
    }
    
    override public init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController);
    } //F.E.
    
    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil);
    } //F.E.
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!;
    } //F.E.
    
    override public func viewDidLoad() {
        super.viewDidLoad();
        //--
    } //F.E.

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
    } //F.E.
    
    private func updateAppearance()
    {
        //Reassing if there are changes from server
        
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
    
    override public func pushViewController(viewController: UIViewController, animated: Bool) {
        if (self.topViewController == nil || !self.topViewController!.isEqual(viewController)) {
            super.pushViewController(viewController, animated: animated);
        }
    } //F.E.
    
    func updateSyncedData() {
        //Update preference
        self.updateAppearance();
    } //F.E.
   
} //F.E.
