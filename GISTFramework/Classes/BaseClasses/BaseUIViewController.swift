//
//  BaseUIViewController.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 14/06/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit

public class BaseUIViewController: UIViewController {

    @IBInspectable var backBtnImageName:String = "NavBackButton";
    
    private var _hasBackButton:Bool = true;
    private var _hasForcedBackButton = false;
    
    private var _lastSyncedDate:String?
    
    private var _titleKey:String?;
    override public var title: String? {
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
    
    
    public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?, backButton:Bool) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil);
        //--
        _hasBackButton = backButton;
    } //F.E.
    
    public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?, backButtonForced:Bool)
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil);
        //--
        _hasBackButton = backButtonForced;
        _hasForcedBackButton = backButtonForced;
    } //F.E.
    
    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil);
    } //F.E.

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    } //F.E.
    
    override public func viewDidLoad() {
        super.viewDidLoad();
        //--
        self.navigationItem.hidesBackButton = true;
       //--
       
        _lastSyncedDate = SyncEngine.lastSyncedServerDate;
        
       //--
        if (_hasBackButton) {
            if (_hasForcedBackButton || (self.navigationController != nil && (self.navigationController!.viewControllers as NSArray).count > 1)) {
                self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: self.backBtnImageName), style:UIBarButtonItemStyle.Plain, target: self, action: #selector(backButtonTapped));
            }
        }
        
    } //F.E.
    
    override public func viewWillAppear(animated: Bool) {
        super.viewDidAppear(animated);
        //--
        self.updateSyncedData();
    }//F.E.

    /*
    override public func  preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent;
    } //F.E.
    */
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    } //F.E.
    
    public func backButtonTapped() {
        self.view.endEditing(true);
        self.navigationController?.popViewControllerAnimated(true)
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
    
} //CLS END
