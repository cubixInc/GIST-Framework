//
//  BaseSeperatorConstraint.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 14/06/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit

open class BaseSeperatorLayoutConstraint: NSLayoutConstraint {
    override open func awakeFromNib() {
        super.awakeFromNib();
        //--
        self.constant = 0.5;
    } //F.E.
} //CLS END
