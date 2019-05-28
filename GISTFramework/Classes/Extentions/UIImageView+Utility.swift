//
//  UIImageView+Utility.swift
//  GISTTesting
//
//  Created by Shoaib Abdul on 11/07/2017.
//  Copyright © 2017 Social Cubix Inc. All rights reserved.
//

import UIKit

public extension UIImageView {
    func tintImageColor(color : UIColor) {
        self.image = self.image!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        self.tintColor = color
    } //F.E.
} //E.E.
