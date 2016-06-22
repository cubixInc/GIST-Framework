//
//  SyncedString.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 14/06/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit

public class SyncedText: SyncEngine {
    
    class override var sharedInstance: SyncedText {
        struct Static {
            static var instance: SyncedText?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = SyncedText();
        }
        
        return Static.instance!
    } //P.E.
    
    public static func syncForData(dict:NSDictionary) -> Bool {
        return SyncedText.sharedInstance.syncForData(dict);
    } //F.E.
    
    public class func text(forKey key: String) -> String {
        return SyncedText.sharedInstance.text(forKey: key);
    } //F.E.
    
    public func text(forKey key: String) -> String {
        return (super.objectForKey(key.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "#")))) ?? key
    } //F.E.
    
} //CLS END
