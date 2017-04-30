//
//  Int+Utility.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 28/04/2017.
//  Copyright © 2017 Social Cubix. All rights reserved.
//

import UIKit

public extension Int {
    func times(f: () -> ()) {
        if self > 0 {
            for _ in 0..<self {
                f()
            }
        }
    } //F.E.
} //E.E.
