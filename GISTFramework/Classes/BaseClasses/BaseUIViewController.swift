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
    } //F.E.
    
    /// Overridden method
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated);

        if (self.isMovingFromParent) {
            self.backButtonTapped();
        }
        
    } //F.E.
    
    //MARK: - Methods
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
