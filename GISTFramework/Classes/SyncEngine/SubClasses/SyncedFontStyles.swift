//
//  SyncedFontStyle.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 14/06/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit

open class SyncedFontStyles: SyncEngine {
    
    fileprivate static var _sharedInstance: SyncedFontStyles = SyncedFontStyles();
    class override var sharedInstance: SyncedFontStyles {
        get {
            return self._sharedInstance;
        }
    } //P.E.
    
    @discardableResult open class func syncForData(_ dict:NSDictionary) -> Bool {
        return SyncedFontStyles.sharedInstance.syncForData(dict);
    } //F.E.
    
    open class func style(forKey key: String) -> Float {
        return SyncedFontStyles.sharedInstance.style(forKey: key);
    } //F.E.
    
    open func style(forKey key: String) -> Float {
        return super.objectForKey(key) ?? 22;
    } //F.E.
    
    open override class func objectForKey<T>(_ aKey: String?) -> T? {
        return SyncedFontStyles.sharedInstance.objectForKey(aKey);
    } //F.E.
    
} //CLS END
