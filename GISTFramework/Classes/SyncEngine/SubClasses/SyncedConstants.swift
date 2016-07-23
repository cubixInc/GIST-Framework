//
//  SyncedConstants.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 14/06/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit

public class SyncedConstants: SyncEngine {
    class override var sharedInstance: SyncedConstants {
        struct Static {
            static var instance: SyncedConstants?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = SyncedConstants();
        }
        
        return Static.instance!
    } //P.E.
    
    public class func syncForData(dict:NSDictionary) -> Bool {
        return SyncedConstants.sharedInstance.syncForData(dict);
    } //F.E.
    
    public class func constant<T>(forKey key: String?) -> T? {
        return SyncedConstants.sharedInstance.objectForKey(key);
    } //F.E.
    
    public override class func objectForKey<T>(aKey: String?) -> T? {
        return SyncedConstants.sharedInstance.objectForKey(aKey);
    } //F.E.
    
} //CLS END
