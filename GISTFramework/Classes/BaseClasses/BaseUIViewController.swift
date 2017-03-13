//
//  BaseUIViewController.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 14/06/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit

/// BaseUIViewController is a subclass of UIViewController. It has some extra proporties and support for SyncEngine.
open class BaseUIViewController: UIViewController {

    /// Inspectable property for navigation back button - Default back button image is 'NavBackButton'
    @IBInspectable open var backBtnImageName:String = GIST_CONFIG.navigationBackButtonImgName;
    
    private var _hasBackButton:Bool = true;
    
    /// Flag for back button visibility.
    open var hasBackButton:Bool {
        get {
            return _hasBackButton;
        }
        
        set {
            _hasBackButton = newValue;
        }
    } //P.E.
    
    private var _hasForcedBackButton = false;
    
    /// Flag for back button visibility by force.
    open var hasForcedBackButton:Bool {
        get {
            return _hasForcedBackButton;
        }
        
        set {
            _hasForcedBackButton = newValue;
             
            if (_hasForcedBackButton) {
                _hasBackButton = true;
            }
        }
    } //P.E.
    
    private var _lastSyncedDate:String?
    
    private var _titleKey:String?;
    
    /// Overriden title property to set title from SyncEngine (Hint '#' prefix).
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
    
    //MARK: - Constructors
    
    /// Overridden constructor to setup/ initialize components.
    ///
    /// - Parameters:
    ///   - nibNameOrNil: Nib Name
    ///   - nibBundleOrNil: Nib Bundle Name
    ///   - backButton: Flag for back button
    public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, backButton:Bool) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil);
         
        _hasBackButton = backButton;
    } //F.E.
    
    
    /// Overridden constructor to setup/ initialize components.
    ///
    /// - Parameters:
    ///   - nibNameOrNil: Nib Name
    ///   - nibBundleOrNil: Nib Bundle Name
    ///   - backButtonForced: Flag to show back button by force
    public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, backButtonForced:Bool)
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil);
        
        _hasBackButton = backButtonForced;
        _hasForcedBackButton = backButtonForced;
    } //F.E.
    
    /// Required constructor implemented.
    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil);
    } //F.E.

    /// Required constructor implemented.
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    } //F.E.
    
    //MARK: - Overridden Methods
    
    /// Overridden method to setup/ initialize components.
    override open func viewDidLoad() {
        super.viewDidLoad();
         
        _lastSyncedDate = SyncEngine.lastSyncedServerDate;
    } //F.E.
    
    /// Overridden method to setup/ initialize components.
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
         
        self.setupBackBtn();
        self.updateSyncedData();
    }//F.E.
    
    //MARK: - Methods
    
    ///Setting up custom back button.
    private func setupBackBtn() {
        if (_hasBackButton) {
             if (self.navigationItem.leftBarButtonItem == nil && (_hasForcedBackButton || (self.navigationController != nil && (self.navigationController!.viewControllers as NSArray).count > 1))) {
                self.navigationItem.hidesBackButton = true;
                
                self.navigationItem.leftBarButtonItem = BaseUIBarButtonItem(image: UIImage(named: self.backBtnImageName), style:UIBarButtonItemStyle.plain, target: self, action: #selector(backButtonTapped));
                
                (self.navigationItem.leftBarButtonItem as? BaseUIBarButtonItem)?.respectRTL = true;
             }
        }
    } //F.E.
    
    ///Navigation back button tap handler.
    open func backButtonTapped() {
        self.view.endEditing(true);
        _ = self.navigationController?.popViewController(animated: true)
    } //F.E.
    
    /// Recursive update of layout and content from Sync Engine.
    @discardableResult func updateSyncedData() -> Bool {
        if let syncedDate:String = SyncEngine.lastSyncedServerDate , syncedDate != _lastSyncedDate {
            _lastSyncedDate = syncedDate;
             
            if _titleKey != nil {
                self.title = _titleKey;
            }
             
            self.view.updateSyncedData();
            
            (self.navigationController as? BaseUINavigationController)?.updateSyncedData();
            
            return true;
        } else {
            return false;
        }
    } //F.E.
    
} //CLS END
