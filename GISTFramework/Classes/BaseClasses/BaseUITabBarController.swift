//
//  BaseUITabBarController.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 14/07/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit

/// BaseUITabBarController is a subclass of UITabBarController. It is made for future use. it is not anything for now
open class BaseUITabBarController: UITabBarController {

    //MARK: - Overridden Methods
    
    /// Overridden method to setup/ initialize components.
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    } //F.E.

    /// Overridden method to reveive memory warnings
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    } //F.E.

} //CLS END
