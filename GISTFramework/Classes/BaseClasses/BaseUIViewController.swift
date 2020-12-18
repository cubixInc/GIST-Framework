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
    
    @IBInspectable open var hasBackButton:Bool = true;
    
    /// Inspectable property for navigation back button - Default back button image is 'NavBackButton'
    @IBInspectable open var backButtonImageName:String? = GIST_CONFIG.backButtonImageName;

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
        
        self.setupBackButton();
    } //F.E.

    //MARK: - Methods
    private func setupBackButton() {
        if self.hasBackButton, self.navigationItem.leftBarButtonItem == nil, let navigationController = self.navigationController, navigationController.viewControllers.count > 1 {
            self.navigationItem.hidesBackButton = true;

            BaseUIViewController.addBackButton(self, backButtonImageName: self.backButtonImageName, target: self, action: #selector(backButtonTapped));
        }
    } //F.E.
    
    @objc
    @IBAction open func backButtonTapped(_ sender:Any) {
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


public extension BaseUIViewController {
    class func addBackButton(_ vc:UIViewController, backButtonImageName:String?, target: Any?, action: Selector?) {
        
        var backButtonImage:UIImage?;
        
        if let backButtonImageName = backButtonImageName {
            backButtonImage = UIImage(named: backButtonImageName);
        } else {
            backButtonImage = UIImage(named: "backButton", in: GISTUtility.bundle, compatibleWith: nil);
        }
        
        let barButtonItem = BaseUIBarButtonItem(image: backButtonImage, style:UIBarButtonItem.Style.plain, target: target, action: action);
        
        barButtonItem.respectRTL = GISTConfig.shared.respectRTL;
        
        vc.navigationItem.hidesBackButton = true;
        vc.navigationItem.leftBarButtonItem = barButtonItem;
    } //F.E.
}
