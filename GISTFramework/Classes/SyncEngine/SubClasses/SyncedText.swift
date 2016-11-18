//
//  SyncedString.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 14/06/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit

open class SyncedText: SyncEngine {
    
    private static var _sharedInstance: SyncedText = SyncedText();
    class override var sharedInstance: SyncedText {
        get {
            return self._sharedInstance;
        }
    } //P.E.
    
    @discardableResult open class func syncForData(_ dict:NSDictionary) -> Bool {
        return SyncedText.sharedInstance.syncForData(dict);
    } //F.E.
    
    open class func text(forKey key: String) -> String {
        return SyncedText.sharedInstance.text(forKey: key);
    } //F.E.
    
    open func text(forKey key: String) -> String {
        return (super.objectForKey(key.trimmingCharacters(in: CharacterSet(charactersIn: "#")))) ?? key
    } //F.E.
    
    open override class func objectForKey<T>(_ aKey: String?) -> T? {
        return SyncedText.sharedInstance.objectForKey(aKey);
    } //F.E.
    
} //CLS END
