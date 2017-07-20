//
//  AppInfo.swift
//  GIST
//
//  Created by Shoaib Abdul on 29/04/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit

public class AppInfo: NSObject {
    
   public static var bundleNumber:String {
        get {
            return Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "";
        }
    } //P.E.
    
    public static var versionNumber:String {
        get {
            return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "";
        }
    } //P.E.

    public static var versionNBuildNumber:String {
        get {
            return "\(self.versionNumber) (\(self.bundleNumber))";
        }
    } //P.E.
    
    
    public static var bundleIdentifier:String {
        get {
            return Bundle.main.bundleIdentifier ?? "";
        }
    } //P.E.
    
} //CLS END
