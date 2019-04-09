//
//  UIScrollView+Utility.swift
//  GISTFramwork
//
//  Created by Shoaib Abdul on 11/10/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit


// MARK: - UIScrollView extension for Utility methods and properties.
public extension UIScrollView {

    //MARK: - Properties
    
    /// Returns current page of scroll view. this method is useful when pagination is ON in scroll view. - value range is 0 to numberOfPages-1
    public var currentPage:Int {
        get {
            return Int(floor((self.contentOffset.x - self.bounds.size.width * 0.5) / self.bounds.size.width)) + 1;
        }
        
        set {
            self.contentOffset = CGPoint(x: self.bounds.size.width * CGFloat(newValue),y: 0);
        }
    } //P.E.
    
} //E.E.
