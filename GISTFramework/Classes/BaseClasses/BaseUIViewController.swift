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
    
    private (set) var _completion:((Bool, Any?) -> Void)?
    
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
    
    /// Overriden title property to set title from SyncEngine (Hint '#' prefix).
    override open var title: String? {
        get {
            return super.title;
        }
        
        set {
            if let key:String = newValue , key.hasPrefix("#") == true {
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
    public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, backButtonForced:Bool) {
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
    } //F.E.
    
    /// Overridden method to setup/ initialize components.
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
         
        self.setupBackBtn();
    }//F.E.
    
    //MARK: - Methods
    
    ///Setting up custom back button.
    private func setupBackBtn() {
        if (_hasBackButton) {
             if (self.navigationItem.leftBarButtonItem == nil && (_hasForcedBackButton || (self.navigationController != nil && (self.navigationController!.viewControllers as NSArray).count > 1))) {
                
                self.navigationItem.hidesBackButton = true;
                
                self.navigationItem.leftBarButtonItem = BaseUIBarButtonItem(image: UIImage(named: self.backBtnImageName), style:UIBarButtonItem.Style.plain, target: self, action: #selector(backButtonTapped));
                
                (self.navigationItem.leftBarButtonItem as? BaseUIBarButtonItem)?.respectRTL = true;
             }
        } else {
            self.navigationItem.hidesBackButton = true;
        }
    } //F.E.
    
    ///Navigation back button tap handler.
    @objc open func backButtonTapped() {
        self.view.endEditing(true);
        
        if (self.navigationController?.viewControllers.count == 1) {
            self.dismiss(animated: true, completion: nil)
        } else {
            _ = self.navigationController?.popViewController(animated: true)
        }
    } //F.E.
    
    //Completion Blocks
    open func setOnCompletion(completion: @escaping (_ success:Bool, _ data:Any?) -> Void) {
        _completion = completion;
    } //F.E.
    
    open func completion(_ success:Bool, _ data:Any?) {
        _completion?(success, data);
    } //F.E.
    
} //CLS END
