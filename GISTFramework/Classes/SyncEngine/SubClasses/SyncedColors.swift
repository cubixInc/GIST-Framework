//
//  SyncedColor.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 14/06/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit


public class SyncedColors: SyncEngine {
    
    class override var sharedInstance: SyncedColors {
        struct Static {
            static var instance: SyncedColors?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = SyncedColors();
        }
        
        return Static.instance!
    } //P.E.
    
    public class func syncForData(dict:NSDictionary) -> Bool {
        return SyncedColors.sharedInstance.syncForData(dict);
    } //F.E.
    
    public class func color(forKey key: String?) -> UIColor? {
        return SyncedColors.sharedInstance.color(forKey: key);
    } //F.E.
    
    public func color(forKey key: String?) -> UIColor? {
        if let haxColor:String = super.objectForKey(key) {
            return UIColor(rgba: haxColor);
        } else {
            return nil;
        }
    } //F.E.
    
    public override class func objectForKey<T>(aKey: String?) -> T? {
        return SyncedColors.sharedInstance.objectForKey(aKey);
    } //F.E.
    
} //CLS END