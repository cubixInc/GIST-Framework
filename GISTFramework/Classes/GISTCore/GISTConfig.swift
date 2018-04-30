//
//  GISTGlobal.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 02/05/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit


public let GIST_CONFIG = GISTConfig.shared;

/// GISTConfig is a singleton instance class to hold default properties for the framework.
public class GISTConfig: NSObject {
    
    static let shared = GISTConfig()
    
    //PRIVATE init so that singleton class should not be reinitialized from anyother class
    fileprivate override init() {} //C.E.
    
    public var fontName:String = "fontDefault";
    public var fontStyle:String = "medium";
    
    public var largeFontStyle:String = "large";
    
    public var navigationBackButtonImgName:String = "NavBackButton";
    
    public var seperatorWidth:CGFloat = 1.0 / UIScreen.main.scale;//0.5;
    
    public var sizeForIPad:Bool = true;
    public var sizeForNavi:Bool = false;
    
    public var respectRTL:Bool = false;
    
    private var _currentLanguageCode:String?
    public var currentLanguageCode:String {
        get {
            if (_currentLanguageCode == nil) {
                _currentLanguageCode = Bundle.main.preferredLocalizations.first ?? "en";
            }
            
            return _currentLanguageCode!;
        }
        
        set {
            if (_currentLanguageCode == newValue) {
                return;
            }
            
            _isRTL = nil;
            
            _currentLanguageCode = newValue;
            

            //change language in the app
            //the language will be changed after restart
            UserDefaults.standard.set([newValue], forKey: "AppleLanguages");
            UserDefaults.standard.synchronize();
            
            //Changes semantic to all views
            //this hack needs in case of languages with different semantics: leftToRight(en/uk) & rightToLeft(ar)
            UIView.appearance().semanticContentAttribute = self.isRTL ? .forceRightToLeft : .forceLeftToRight;
        }
    } //P.E.
    
    private var _isRTL:Bool?;
    public var isRTL:Bool {
        get {
            if (_isRTL == nil) {
                _isRTL = Locale.characterDirection(forLanguage: self.currentLanguageCode) == .rightToLeft;
            }
            
            return _isRTL!;
        }
    } //P.E.

} //CLS END
