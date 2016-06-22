//
//  BaseLayoutConstraint.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 14/06/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit

public class BaseLayoutConstraint: NSLayoutConstraint {
    override public func awakeFromNib() {
        super.awakeFromNib();
        //--
        self.constant = UIView.convertToRatio(constant);
    } //F.E.
} //CLS END
