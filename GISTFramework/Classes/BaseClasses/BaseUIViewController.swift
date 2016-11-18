//
//  BaseUIViewController.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 14/06/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit

open class BaseUIViewController: UIViewController {

    //Default back button image is 'NavBackButton', which can be changed from inspector
    @IBInspectable open var backBtnImageName:String = "NavBackButton";
    
    private var _hasBackButton:Bool = true;
    open var hasBackButton:Bool {
        get {
            return _hasBackButton;
        }
        
        set {
            _hasBackButton = newValue;
        }
    } //P.E.
    
    private var _hasForcedBackButton = false;
    open var hasForcedBackButton:Bool {
        get {
            return _hasForcedBackButton;
        }
        
        set {
            _hasForcedBackButton = newValue;
            //--
            if (_hasForcedBackButton) {
                _hasBackButton = true;
            }
        }
    } //P.E.
    
    private var _lastSyncedDate:String?
    
    private var _titleKey:String?;
    override open var title: String? {
        get {
            return super.title;
        }
        
        set {
            if let key:String = newValue , key.hasPrefix("#") == true {
                _titleKey = key;  // holding key for using later
                
                super.title = SyncedText.text(forKey: key);
            } else {
                super.title = newValue;
            }
        }
    } //P.E.
    
    open override var isMovingToParentViewController : Bool {
        let rtnBool = super.isMovingToParentViewController;
        //DOING NOTHING FOR NOW
        return rtnBool;
    } //F.E.
    
    public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, backButton:Bool) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil);
        //--
        _hasBackButton = backButton;
    } //F.E.
    
    public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, backButtonForced:Bool)
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil);
        //--
        _hasBackButton = backButtonForced;
        _hasForcedBackButton = backButtonForced;
    } //F.E.
    
    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil);
    } //F.E.

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    } //F.E.
    
    override open func viewDidLoad() {
        super.viewDidLoad();
        //--
        _lastSyncedDate = SyncEngine.lastSyncedServerDate;
    } //F.E.
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        //--
        self.setupBackBtn();
        self.updateSyncedData();
    }//F.E.
    
    //Setting up custom back button
    private func setupBackBtn() {
        if (_hasBackButton) {
             if (self.navigationItem.leftBarButtonItem == nil && (_hasForcedBackButton || (self.navigationController != nil && (self.navigationController!.viewControllers as NSArray).count > 1))) {
                self.navigationItem.hidesBackButton = true;
                //--
                self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: self.backBtnImageName), style:UIBarButtonItemStyle.plain, target: self, action: #selector(backButtonTapped));
             }
        }
    } //F.E.
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
    } //F.E.
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated);
    } //F.E.
    
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    } //F.E.
    
    open func backButtonTapped() {
        self.view.endEditing(true);
        _ = self.navigationController?.popViewController(animated: true)
    } //F.E.
    
    /// Recursive update of layout and content from Sync Engine.
    @discardableResult func updateSyncedData() -> Bool {
        if let syncedDate:String = SyncEngine.lastSyncedServerDate , syncedDate != _lastSyncedDate {
            _lastSyncedDate = syncedDate;
            //--
            if _titleKey != nil {
                self.title = _titleKey;
            }
            //--
            self.view.updateSyncedData();
            
            (self.navigationController as? BaseUINavigationController)?.updateSyncedData();
            
            return true;
        } else {
            return false;
        }
    } //F.E.
    
} //CLS END
