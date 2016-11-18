//
//  Weak.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 18/11/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit

open class Weak<T: AnyObject> {
    weak var value : T?
    init (value: T) {
        self.value = value
    }
} //CLS END
