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
    
    public var deviceToken:String?;
    
    public var apnsPermissionGranted:Bool?
    
    public var baseURL:URL!
    public var apiURL:URL!
    
    private var _user:User?
    public var user:User? {
        get {
            
            if _user == nil, let data: Data = UserDefaults.standard.object(forKey: "APP_USER") as? Data {
                _user = NSKeyedUnarchiver.unarchiveObject(with: data) as? User;
            }
            
            return _user;
        }
        
        set {
            _user = newValue;
            
            if let usr:User = _user {
                let data = NSKeyedArchiver.archivedData(withRootObject: usr);
                UserDefaults.standard.set(data, forKey: "APP_USER");
                UserDefaults.standard.synchronize();
            }
        }
    } //P.E.
    
} //F.E.
