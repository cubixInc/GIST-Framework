//
//  BaseLayoutConstraint.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 14/06/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit

open class BaseLayoutConstraint: NSLayoutConstraint {
    @IBInspectable open var sizeForIPad:Bool = false;
    @IBInspectable open var sizeForNavi:Bool = false;
    
    override open func awakeFromNib() {
        super.awakeFromNib();
        //--
        self.constant = GISTUtility.convertToRatio(constant, sizedForIPad: sizeForIPad, sizedForNavi:sizeForNavi);
    } //F.E.
} //CLS END
