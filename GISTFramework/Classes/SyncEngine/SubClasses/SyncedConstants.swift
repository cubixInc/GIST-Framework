//
//  SyncedConstants.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 14/06/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit

open class SyncedConstants: SyncEngine {
    
    private static var _sharedInstance: SyncedConstants = SyncedConstants();
    class override var sharedInstance: SyncedConstants {
        get {
            return self._sharedInstance;
        }
    } //P.E.
    
    @discardableResult open class func syncForData(_ dict:NSDictionary) -> Bool {
        return SyncedConstants.sharedInstance.syncForData(dict);
    } //F.E.
    
    open class func constant<T>(forKey key: String?) -> T? {
        return SyncedConstants.sharedInstance.objectForKey(key);
    } //F.E.
    
    open override class func objectForKey<T>(_ aKey: String?) -> T? {
        return SyncedConstants.sharedInstance.objectForKey(aKey);
    } //F.E.
    
} //CLS END
