//
//  GISTGlobal.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 02/05/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit


public let GIST_GLOBAL = GISTGlobal.sharedInstance;

/// GISTGlobal is a singleton instance class to hold default properties for the framework.
public class GISTGlobal: NSObject {
    
    static let sharedInstance = GISTGlobal()
    
    //PRIVATE init so that singleton class should not be reinitialized from anyother class
    fileprivate override init() {} //C.E.
    
    public var fontName:String = "fontDefault";
    public var fontStyle:String = "medium";
    public var navigationBackButtonImgName:String = "NavBackButton";
    
    public var seperatorWidth:CGFloat = 0.5;
    
    public var sizeForIPad:Bool = true;
    public var sizeForNavi:Bool = false;
    
    public var respectRTL:Bool = false;
    
    private var _isRTL:Bool?
    
    /// Flag to check user interfce layout direction
    public var isRTL:Bool {
        get {
            if (_isRTL == nil) {
                _isRTL = Locale.characterDirection(forLanguage: Locale.current.languageCode ?? "en") == .rightToLeft;
            }
            return _isRTL!;
        }
    }

} //CLS END
