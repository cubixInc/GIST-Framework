//
//  BaseLayoutConstraint.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 14/06/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit

public class BaseLayoutConstraint: NSLayoutConstraint {
    @IBInspectable public var sizeForIPad:Bool = false ;
    
    override public func awakeFromNib() {
        super.awakeFromNib();
        //--
        self.constant = UIView.convertToRatio(constant, sizedForIPad: sizeForIPad);
    } //F.E.
} //CLS END
