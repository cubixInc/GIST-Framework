//
//  SyncedFontStyle.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 14/06/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit

/**
 SyncedFontStyles is a subclass of SyncEngine.
 It handles syncing of application font sizes/ styles.
 */
open class SyncedFontStyles: SyncEngine {
    
    //MARK: - Properties
    
    private static var _sharedInstance: SyncedFontStyles = SyncedFontStyles();
    
    /// A singleton overridden sharedInstance for SyncedFontStyles.
    class override var sharedInstance: SyncedFontStyles {
        get {
            return self._sharedInstance;
        }
    } //P.E.
    
    //MARK: - Methods
    
    /// Retrieves a font size for a key from SyncEngine.
    ///
    /// - Parameter key: A Key
    /// - Returns: A font size value from SyncEngine.
    public class func style(forKey key: String) -> Float {
        return SyncedFontStyles.sharedInstance.style(forKey: key);
    } //F.E.
    
    func style(forKey key: String) -> Float {
        return super.objectForKey(key) ?? 22;
    } //F.E.
    
    
} //CLS END
