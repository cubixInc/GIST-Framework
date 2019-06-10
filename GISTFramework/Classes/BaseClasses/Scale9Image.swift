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

    open override func awakeFromNib() {
        super.awakeFromNib();
        
        self.image = self.image?.resizableImage(withCapInsets: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20), resizingMode: UIImageResizingMode.stretch);
    }

} //CLS END
