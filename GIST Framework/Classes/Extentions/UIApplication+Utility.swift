//
//  UIApplication+Utility.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 29/06/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit

// MARK: - UIApplication Utility
public extension UIApplication {
    
    /// Finds top view controller of the given UIVIew Controller
    ///
    /// - Parameter base: UIViewController of which topViewController is required
    /// - Returns: Top View Controller of the the given base controller
    public class func topViewController(_ base: UIViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(nav.visibleViewController!)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = base.presentedViewController {
            return topViewController(presented)
        }
        return base
    } //F.E.
} //E.E.
