//
//  BaseSeperatorConstraint.swift
//  eGrocery
//
//  Created by Shoaib on 2/19/15.
//  Copyright (c) 2015 cubixlabs. All rights reserved.
//

import UIKit

class BaseSeperatorLayoutConstraint: NSLayoutConstraint {
    override func awakeFromNib() {
        super.awakeFromNib();
        //--
        self.constant = 0.5;
    } //F.E.
} //F.E.
