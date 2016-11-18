//
//  BaseLayoutConstraint.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 14/06/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit


/// BaseLayoutConstraint is a subclass of NSLayoutConstraint to resize the constraints according to the device screen resolution.
open class BaseLayoutConstraint: NSLayoutConstraint {
    
    /// Flag for whether to resize the values for iPad.
    @IBInspectable open var sizeForIPad:Bool = false;
    
    /// Flag for whether to resize the values considering UINavigationbar fixed height(64)
    @IBInspectable open var sizeForNavi:Bool = false;
    
    /// Overridden method to setup/ initialize components.
    override open func awakeFromNib() {
        super.awakeFromNib();
        //--
        self.constant = GISTUtility.convertToRatio(constant, sizedForIPad: sizeForIPad, sizedForNavi:sizeForNavi);
    } //F.E.
} //CLS END
