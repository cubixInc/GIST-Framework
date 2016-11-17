//
//  UIColor+Utility.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 27/07/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit

// MARK: - UIColor extension for Synced Color.
public extension UIColor {
    
    /*!
    * All colors are explicitly unwrapped assuming keys will always be correct
    */
    
    
    /// Color from SyncEngine for key 'theme'
    public static var theme:UIColor! {
        get {
            return SyncedColors.sharedInstance.color(forKey: "theme");
        }
    } //F.E.
    
    /// Color from SyncEngine for key 'accent'
    public static var accent:UIColor! {
        get {
            return SyncedColors.sharedInstance.color(forKey: "accent");
        }
    } //F.E.
    
    /// Color from SyncEngine for key 'primary'
    public static var primary:UIColor! {
        get {
            return SyncedColors.sharedInstance.color(forKey: "primary");
        }
    } //F.E.
    
    /// Color from SyncEngine for key 'secondary'
    public static var secondary:UIColor! {
        get {
            return SyncedColors.sharedInstance.color(forKey: "secondary");
        }
    } //F.E.
    
    /// Color from SyncEngine for specific key
    public class func color(forKey key: String?) -> UIColor! {
        return SyncedColors.sharedInstance.color(forKey: key);
    } //F.E.
    
} //CLS END
