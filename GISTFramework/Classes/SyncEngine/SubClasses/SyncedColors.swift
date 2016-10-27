//
//  SyncedColor.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 14/06/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit


open class SyncedColors: SyncEngine {
    
    fileprivate static var _sharedInstance: SyncedColors = SyncedColors();
    class override var sharedInstance: SyncedColors {
        get {
            return self._sharedInstance;
        }
    }
    
    @discardableResult open class func syncForData(_ dict:NSDictionary) -> Bool {
        return SyncedColors.sharedInstance.syncForData(dict);
    } //F.E.
    
    open class func color(forKey key: String?) -> UIColor? {
        return SyncedColors.sharedInstance.color(forKey: key);
    } //F.E.
    
    open func color(forKey key: String?) -> UIColor? {
        if let haxColor:String = super.objectForKey(key) {
            return UIColor(haxColor);
        } else {
            return nil;
        }
    } //F.E.
    
    open override class func objectForKey<T>(_ aKey: String?) -> T? {
        return SyncedColors.sharedInstance.objectForKey(aKey);
    } //F.E.
    
} //CLS END
