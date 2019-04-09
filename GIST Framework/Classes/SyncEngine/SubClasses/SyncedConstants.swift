//
//  SyncedConstants.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 14/06/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit

/**
 SyncedConstants is a subclass of SyncEngine.
 It handles syncing of application constants.
 */
open class SyncedConstants: SyncEngine {
    
    //MARK: - Properties
    
    private static var _sharedInstance: SyncedConstants = SyncedConstants();
    
    /// A singleton overridden sharedInstance for SyncedConstants
    class override var sharedInstance: SyncedConstants {
        get {
            return self._sharedInstance;
        }
    } //P.E.
    
    //MARK: - Methods
    
    /// Retrieves a constant for a key from SyncEngine.
    ///
    /// - Parameter key: A Key
    /// - Returns: A constant text or value from SyncEngine.
    public class func constant<T>(forKey key: String?) -> T? {
        if let constantV:T = super.objectForKey(key) {
            return constantV;
        } else {
            #if DEBUG
                assert(key == nil, "constant key : \(key!) not found\n");
            #endif
            
            return nil;
        }
    } //F.E.
    
} //CLS END
