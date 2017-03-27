//
//  AppInfo.swift
//  GIST
//
//  Created by Shoaib Abdul on 29/04/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit

class AppInfo: NSObject {
    
    static var bundleNumber:String {
        get {
            return Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "";
        }
    } //P.E.
    
    static var versionNumber:String {
        get {
            return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "";
        }
    } //P.E.

    static var versionNBuildNumber:String {
        get {
            return "\(self.versionNumber) (\(self.bundleNumber))";
        }
    } //P.E.
    
    
    static var bundleIdentifier:String {
        get {
            return Bundle.main.bundleIdentifier ?? "";
        }
    } //P.E.
    
} //CLS END
