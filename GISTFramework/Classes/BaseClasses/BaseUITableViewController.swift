//
//  BaseUITableViewController.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 30/09/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit

/// BaseUITableViewController is a subclass of UITableViewController. It has some extra proporties and support for SyncEngine.
open class BaseUITableViewController: UITableViewController {
    
    /// Inspectable property for navigation back button - Default back button image is 'NavBackButton'
    @IBInspectable open var backButtonImage:String? = GIST_CONFIG.navigationBackButtonImgName;

    private (set) var _completion:((Bool, Any?) -> Void)?
    
    //MARK: - Properties
    
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
    
    //MARK: - Overridden Methods
    
    /// Overridden method to setup/ initialize components.
    override open func viewDidLoad() {
        super.viewDidLoad();
        self.updateBackButton();
    } //F.E.
    
    /// Overridden method
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated);

        if (self.isMovingFromParent) {
            self.backButtonTapped();
        }
        
    } //F.E.
    
    //MARK: - Methods
    private func updateBackButton() {
        let barItem:BaseUIBarButtonItem;
        
        if let backButtonImage = self.backButtonImage {
            
            //Removing back button arrow indicator
            //??self.navigationController?.navigationBar.backIndicatorImage = UIImage();
            //??self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage();
            
            barItem = BaseUIBarButtonItem(image: UIImage(named: backButtonImage), style:UIBarButtonItem.Style.plain, target: nil, action: nil);
            
            barItem.respectRTL = true;
        } else {
            barItem = BaseUIBarButtonItem(title: " ", style: UIBarButtonItem.Style.plain, target: nil, action: nil);
        }
        
        self.navigationItem.backBarButtonItem = barItem;
    } //F.E.
    
    open func backButtonTapped() {
        self.view.endEditing(true);
    } //F.E.

    //Completion Blocks
    open func setOnCompletion(completion: @escaping (_ success:Bool, _ data:Any?) -> Void) {
        _completion = completion;
    } //F.E.
    
    open func completion(_ success:Bool, _ data:Any?) {
        _completion?(success, data);
    } //F.E.
} //CLS END
