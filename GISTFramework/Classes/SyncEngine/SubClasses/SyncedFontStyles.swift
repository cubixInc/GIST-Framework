//
//  SyncedFontStyle.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 14/06/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit

public class SyncedFontStyles: SyncEngine {
    class override var sharedInstance: SyncedFontStyles {
        struct Static {
            static var instance: SyncedFontStyles?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = SyncedFontStyles();
        }
        
        return Static.instance!
    } //P.E.
    
    public static func syncForData(dict:NSDictionary) -> Bool {
        return SyncedFontStyles.sharedInstance.syncForData(dict);
    } //F.E.
    
    public class func style(forKey key: String) -> Float {
        return SyncedFontStyles.sharedInstance.style(forKey: key);
    } //F.E.
    
    public func style(forKey key: String) -> Float {
        return super.objectForKey(key) ?? 22;
    } //F.E.
    
} //CLS END
