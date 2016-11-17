//
//  Weak.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 18/11/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit

/// Class to hold generic weak objects
open class Weak<T: AnyObject> {
    
    //MARK: - Properties
    
    /// Holds weak object
    weak open var value : T?
    
    //MARK: - Constructor
    
    /// Constructor for weak generic value
    ///
    /// - Parameter value: Weak Value to hold
    public init (value: T) {
        self.value = value
    } //C.E.
} //CLS END
