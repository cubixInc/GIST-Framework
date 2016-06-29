//
//  UIApplication+Utility.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 29/06/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit

public extension UIApplication {
    class func topViewController(base: UIViewController) -> UIViewController? {
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