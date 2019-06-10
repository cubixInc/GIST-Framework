//
//  Scale9Image.swift
//  Vision sports
//
//  Created by Shoaib Abdul on 17/07/2017.
//  Copyright © 2017 Social Cubix Inc. All rights reserved.
//

import UIKit
import GISTFramework

open class Scale9Image: BaseUIImageView {
    
    @IBInspectable open var edgeInset:Float = 20;

    open override func awakeFromNib() {
        super.awakeFromNib();
        
        self.image = self.image?.resizableImage(withCapInsets: UIEdgeInsets(top: edgeInset, left: edgeInset, bottom: edgeInset, right: edgeInset), resizingMode: UIImageResizingMode.stretch);
    }

} //CLS END
