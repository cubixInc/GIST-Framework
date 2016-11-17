//
//  SyncedString.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 14/06/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit

/**
 SyncedText is a subclass of SyncEngine.
 It handles syncing of application texts.
 */
open class SyncedText: SyncEngine {
    
    //MARK: - Properties
    
    private static var _sharedInstance: SyncedText = SyncedText();
    
    /// A singleton overridden sharedInstance for SyncedText.
    class override var sharedInstance: SyncedText {
        get {
            return self._sharedInstance;
        }
    } //P.E.
    
    //MARK: - Methods
    
    /// Retrieves text for a key from SyncEngine.
    ///
    /// - Parameter key: A Key
    /// - Returns: A text from SyncEngine
    public class func text(forKey key: String) -> String {
        return SyncedText.sharedInstance.text(forKey: key);
    } //F.E.
    
    func text(forKey key: String) -> String {
        return (super.objectForKey(key.trimmingCharacters(in: CharacterSet(charactersIn: "#")))) ?? key
    } //F.E.
    
} //CLS END
