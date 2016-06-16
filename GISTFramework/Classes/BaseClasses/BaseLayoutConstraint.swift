//
//  BaseLayoutConstraint.swift
//  TestApp
//
//  Created by Shoaib Mac Mini on 22/01/2015.
//  Copyright (c) 2015 CubixLabs. All rights reserved.
//

import UIKit

public class BaseLayoutConstraint: NSLayoutConstraint {
    override public func awakeFromNib() {
        super.awakeFromNib();
        //--
        self.constant = UIView.convertToRatio(constant);
    } //F.E.
} //CLS END
