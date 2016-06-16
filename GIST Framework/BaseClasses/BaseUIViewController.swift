//
//  BaseUIViewController.swift
//  E-Grocery
//
//  Created by Muneeba on 12/24/14.
//  Copyright (c) 2014 cubixlabs. All rights reserved.
//

import UIKit

class BaseUIViewController: UIViewController {

    private var _hasBackButton:Bool = true;
    private var _hasMenuButton:Bool = false;
    private var _hasForcedBackButton = false;
    
    private var _lastSyncedDate:String?
    
    private var _titleKey:String?;
    
    override var title: String? {
        get {
            return super.title;
        }
        
        set {
            if let key:String = newValue where key.hasPrefix("#") == true {
                _titleKey = key;  // holding key for using later
                
                super.title = SyncedText.text(forKey: key);
            } else {
                super.title = newValue;
            }
        }
    } //P.E.
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?, menuButton:Bool) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil);
        //--
        _hasBackButton = false;
        _hasMenuButton = menuButton;
    } //F.E.
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?, backButton:Bool) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil);
        //--
        _hasBackButton = backButton;
        _hasMenuButton = false;
    } //F.E.
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?, backButtonForced:Bool)
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil);
        //--
        _hasBackButton = backButtonForced;
        _hasForcedBackButton = backButtonForced;
        _hasMenuButton = false;
    } //F.E.
    
    /*
    init(deviceSpecificNibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: Utility.deviceSpecificNibName(nibNameOrNil), bundle: nibBundleOrNil);
    } //F.E.
    */
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil);
    } //F.E.

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    } //F.E.
    
    override func viewDidLoad() {
        super.viewDidLoad();
        //--
        self.navigationItem.hidesBackButton = true;
       //--
       
        _lastSyncedDate = SyncEngine.lastSyncedServerDate;
        
       //--
        if (_hasBackButton) {
            if (_hasForcedBackButton || (self.navigationController != nil && (self.navigationController!.viewControllers as NSArray).count > 1)) {
                self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "NavBackButton"), style:UIBarButtonItemStyle.Plain, target: self, action: #selector(BaseUIViewController.backButtonTapped));
            }
        }/* else if (_hasMenuButton) {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "menu-icon"), style:UIBarButtonItemStyle.Plain, target: self, action: Selector("menuButtonTapped"));}
        */
        
        
    } //F.E.
    
    override func viewWillAppear(animated: Bool) {
        super.viewDidAppear(animated);
        //--
        self.updateSyncedData();
    }//F.E.

    override func  preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent;
    } //F.E.
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    } //F.E.
    
    func backButtonTapped() {
        self.view.endEditing(true);
        self.navigationController?.popViewControllerAnimated(true)
    } //F.E.
    
    func menuButtonTapped() {
        //??NSNotificationCenter.defaultCenter().postNotificationName(MENU_BUTTON_DID_TAP_NOTIFICATION, object: self);
    } //F.E.
    
    func doneType(sender: UIButton!) {
        self.view.endEditing(true);
    } //F.E.
    
    private func updateSyncedData() {
        if let syncedDate:String = SyncEngine.lastSyncedServerDate where syncedDate != _lastSyncedDate {
            _lastSyncedDate = syncedDate;
            //--
            if _titleKey != nil {
                self.title = _titleKey;
            }
            //--
            self.view.updateSyncedData();
            (self.navigationController as? BaseUINavigationController)?.updateSyncedData()
        }
    } //F.E.
    
} //F.E.
