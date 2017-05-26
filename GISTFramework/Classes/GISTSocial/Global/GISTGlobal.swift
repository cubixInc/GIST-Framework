//
//  GISTGlobal.swift
//  SocialGIST
//
//  Created by Shoaib Abdul on 14/03/2017.
//  Copyright © 2017 Social Cubix Inc. All rights reserved.
//

import UIKit

public let GIST_GLOBAL = GISTGlobal.shared;

/// GISTGlobal is a singleton instance class to hold default shared data.
public class GISTGlobal: NSObject {
    static let shared = GISTGlobal();
    
    //PRIVATE init so that singleton class should not be reinitialized from anyother class
    fileprivate override init() {} //C.E.
    
    public var baseURL:URL!
    public var apiURL:URL!
    
    public var deviceToken:String?;
    public var apnsPermissionGranted:Bool?
    
    private var _user:GISTUser?
    public internal(set) var user:GISTUser? {
        get {
            
            if _user == nil, let data: Data = UserDefaults.standard.object(forKey: "APP_USER") as? Data {
                _user = NSKeyedUnarchiver.unarchiveObject(with: data) as? GISTUser;
            }
            
            return _user;
        }
        
        set {
            _user = newValue;
            
            if let usr:GISTUser = _user {
                let data = NSKeyedArchiver.archivedData(withRootObject: usr);
                UserDefaults.standard.set(data, forKey: "APP_USER");
                UserDefaults.standard.synchronize();
            } else {
                UserDefaults.standard.removeObject(forKey: "APP_USER")
            }
        }
    } //P.E.
    
    private var _hasAskedForApnsPermission:Bool?
    public var hasAskedForApnsPermission:Bool {
        get {
            
            if _hasAskedForApnsPermission == nil {
                _hasAskedForApnsPermission = UserDefaults.standard.bool(forKey: "ASKED_APNS_PERMISSION");
            }
            
            return _hasAskedForApnsPermission!;
        }
        
        set {
            _hasAskedForApnsPermission = newValue;
            
            UserDefaults.standard.set(_hasAskedForApnsPermission, forKey: "ASKED_APNS_PERMISSION");
            UserDefaults.standard.synchronize();
        }
    } //P.E.
    
} //F.E.
