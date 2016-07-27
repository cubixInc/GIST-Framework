//
//  UIColor+Utility.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 27/07/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit

public extension UIColor {
    
    /*
    * All colors are explicitly unwrapped assuming keys will always be correct
    */
    
    public class func theme() -> UIColor! {
        return SyncedColors.sharedInstance.color(forKey: "theme");
    } //F.E.
    
    public class func accent() -> UIColor! {
        return SyncedColors.sharedInstance.color(forKey: "accent");
    } //F.E.
    
    public class func primary() -> UIColor! {
        return SyncedColors.sharedInstance.color(forKey: "primary");
    } //F.E.
    
    public class func secondary() -> UIColor! {
        return SyncedColors.sharedInstance.color(forKey: "secondary");
    } //F.E.
    
    public class func color(forKey key: String?) -> UIColor! {
        return SyncedColors.sharedInstance.color(forKey: key);
    } //F.E.
    
} //CLS END
