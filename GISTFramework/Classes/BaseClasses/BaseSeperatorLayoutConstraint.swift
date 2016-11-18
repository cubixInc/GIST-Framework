//
//  BaseSeperatorConstraint.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 14/06/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit

/// BaseSeperatorLayoutConstraint is a subclass of NSLayoutConstraint for seperators' height constraint to make a consistent height of seperators throughout the app.
open class BaseSeperatorLayoutConstraint: NSLayoutConstraint {
    
    /// Overridden method to setup/ initialize components.
    override open func awakeFromNib() {
        super.awakeFromNib();
        //--
        self.constant = 0.5;
    } //F.E.
} //CLS END
