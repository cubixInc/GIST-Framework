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
    
    public static var theme:UIColor! {
        get {
            return SyncedColors.sharedInstance.color(forKey: "theme");
        }
    } //F.E.
    
    public static var accent:UIColor! {
        get {
            return SyncedColors.sharedInstance.color(forKey: "accent");
        }
    } //F.E.
    
    public static var primary:UIColor! {
        get {
            return SyncedColors.sharedInstance.color(forKey: "primary");
        }
    } //F.E.
    
    public static var secondary:UIColor! {
        get {
            return SyncedColors.sharedInstance.color(forKey: "secondary");
        }
    } //F.E.
    
    public class func color(forKey key: String?) -> UIColor! {
        return SyncedColors.sharedInstance.color(forKey: key);
    } //F.E.
    
} //CLS END
