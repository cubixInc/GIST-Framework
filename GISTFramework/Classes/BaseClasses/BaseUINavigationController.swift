//
//  BaseUINavigationController.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 14/06/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit

enum BarStyle {
    case Default;//, Black, Gray, Red
}

public class BaseUINavigationController: UINavigationController {

    private var _barStyle:BarStyle = BarStyle.Default;
    
    var barStyle:BarStyle {
        get {
            return _barStyle;
        }
        
        set {
            _barStyle = newValue;
            //--
            updateAppearance();
        }
    } //P.E.
    
    init(rootViewController: UIViewController, barStyle:BarStyle) {
        super.init(rootViewController: rootViewController);
        //--
        self.barStyle = barStyle;
    } //F.E.

    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController);
        //--
        self.barStyle = BarStyle.Default;
    } //F.E.
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil);
    } //F.E.
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        var attrDict:[String : AnyObject] = [String : AnyObject]()
        //--
        attrDict[NSFontAttributeName] = UIView.font(SyncedConstants.constant(forKey: "NavigationFont"),fontStyle: SyncedConstants.constant(forKey: "NavigationFontStyle") ?? "Medium");
        
        switch (_barStyle)
        {
            case .Default:
                attrDict[NSForegroundColorAttributeName] = SyncedColors.color(forKey: "NavigationTextColor");
                //--
                self.navigationBar.barTintColor = SyncedColors.color(forKey: "NavigationBgColor");
                self.navigationBar.barStyle = UIBarStyle.Default;
                self.navigationBar.tintColor = SyncedColors.color(forKey: "NavigationTintColor");//UIColor.whiteColor();//GLOBAL.WHITE_COLOR;
                break;
/*
            case .Black:
                attrDict.setObject(GLOBAL.WHITE_COLOR, forKey: NSForegroundColorAttributeName)
                self.navigationBar.barStyle = UIBarStyle.Black;
                self.navigationBar.tintColor = GLOBAL.WHITE_COLOR;
                break;
            
            case .Gray:
                attrDict.setObject(GLOBAL.BLACK_COLOR, forKey: NSForegroundColorAttributeName)
                //--
                self.navigationBar.barTintColor = GLOBAL.LIGHT_GRAY_COLOR;
                //??self.navigationBar.barStyle = UIBarStyle.Default;
                self.navigationBar.tintColor = GLOBAL.GRAY_COLOR;
                break;

            case .Red:
                attrDict.setObject(GLOBAL.WHITE_COLOR, forKey: NSForegroundColorAttributeName)
                //--
                self.navigationBar.barTintColor = GLOBAL.RED_COLOR;
                //??self.navigationBar.barStyle = UIBarStyle.Default;
                self.navigationBar.tintColor = GLOBAL.WHITE_COLOR;
            break;
*/
        }
        
        self.navigationBar.titleTextAttributes = attrDict;// as [String : AnyObject];
        //--
        self.navigationBar.translucent = false
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
