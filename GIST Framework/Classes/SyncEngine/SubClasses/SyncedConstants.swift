//
//  SyncedConstants.swift
//  GIST
//
//  Created by Shoaib Abdul on 02/05/2016.
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
    
    public static func syncForData(dict:NSDictionary) -> Bool {
        return SyncedConstants.sharedInstance.syncForData(dict);
    } //F.E.
    
    public class func constant<T>(forKey key: String) -> T? {
        return SyncedConstants.sharedInstance.objectForKey(key);
    } //F.E.
    
} //CLS END
