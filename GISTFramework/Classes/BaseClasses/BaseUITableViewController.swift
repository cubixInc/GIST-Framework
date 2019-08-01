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
    } //F.E.
    
    /// Overridden method
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated);
        
        self.view.endEditing(true);
    } //F.E.
    
    //MARK: - Methods
    
    //Completion Blocks
    open func setOnCompletion(completion: @escaping (_ success:Bool, _ data:Any?) -> Void) {
        _completion = completion;
    } //F.E.
    
    open func completion(_ success:Bool, _ data:Any?) {
        _completion?(success, data);
    } //F.E.
} //CLS END
