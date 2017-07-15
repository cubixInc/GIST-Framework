//
//  GISTGlobal.swift
//  SocialGIST
//
//  Created by Shoaib Abdul on 14/03/2017.
//  Copyright © 2017 Social Cubix Inc. All rights reserved.
//

import UIKit;
import ObjectMapper;

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
    
    private var _userData:[String:Any]?
    internal var userData:[String:Any]? {
        set {
            _userData = newValue;
            _user = nil;
            
            if let dictData:[String:Any] = _userData, let data:Data = dictData.toJSONData() {
                UserDefaults.standard.set(data, forKey: "APP_USER");
                UserDefaults.standard.synchronize();
            } else {
                UserDefaults.standard.removeObject(forKey: "APP_USER")
            }
        }
        
        get {
            if _userData == nil, let data: Data = UserDefaults.standard.object(forKey: "APP_USER") as? Data {
                _userData = data.toJSONObject() as? [String:Any];
            }
            
            return _userData;
        }
    } //P.E.
    
    private var _hasAskedForApnsPermission:Bool?
    public var hasAskedForApnsPermission:Bool {
        get {
            guard (userData != nil) else {
                return false;
            }
            
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
    
    private var _user:GISTUser?;
    public func getUser<T:GISTUser>() -> T? {
        guard let usrData = userData, let _:Int = usrData["user_id"] as? Int else {
            return nil;
        }
        
        if (_user == nil && _userData != nil) {
            _user = Mapper<T>().map(JSON: usrData);
        }
        
        return _user as? T;
    } //F.E.
    
} //F.E.
