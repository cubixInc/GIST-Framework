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
    @IBInspectable open var backButtonImage:String? = GIST_CONFIG.navigationBackButtonImgName;

    private (set) var _completion:((Bool, Any?) -> Void)?
    
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
    open override func viewDidLoad() {
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
            self.navigationBar.backIndicatorImage = UIImage();
            self.navigationBar.backIndicatorTransitionMaskImage = UIImage();
            
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
