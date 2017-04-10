//
//  GISTAuth.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 07/04/2017.
//  Copyright © 2017 Social Cubix. All rights reserved.
//

import UIKit
import ObjectMapper

private let SIGN_UP_REQUEST = "users";
private let SIGN_IN_REQUEST = "users/signin";
private let SOCIAL_SIGN_IN_REQUEST = "users/social_login";

private let EDIT_PROFILE_REQUEST = "users/edit_profile";

public class GISTAuth: NSObject {
    
    static let shared = GISTAuth();
    
    public typealias GISTAuthCompletion = (_ user:User, _ rawData:Any?) -> Void
    
    //PRIVATE init so that singleton class should not be reinitialized from anyother class
    fileprivate override init() {} //C.E.
    
    @discardableResult
    public static func signUp(fields:ValidatedTextField ..., completion:@escaping GISTAuthCompletion) -> HTTPRequest? {
        return self.shared.request(service: SIGN_IN_REQUEST, fields: fields, completion:completion);
    } //F.E.
    
    @discardableResult
    public static func signUp(params:[String:Any], completion:@escaping GISTAuthCompletion) -> HTTPRequest? {
        return self.shared.request(service: SIGN_IN_REQUEST, params: params, completion:completion);
    } //F.E.
    
    @discardableResult
    public static func signIn(fields:ValidatedTextField ..., completion:@escaping GISTAuthCompletion) -> HTTPRequest? {
        return self.shared.request(service: SIGN_UP_REQUEST, fields: fields, completion:completion);
    } //F.E.
    
    @discardableResult
    public static func signIn(params:[String:Any], completion:@escaping GISTAuthCompletion) -> HTTPRequest? {
        return self.shared.request(service: SIGN_UP_REQUEST, params: params, completion:completion);
    } //F.E.
    
    @discardableResult
    public static func socialSignIn(user:User, completion:@escaping GISTAuthCompletion) -> HTTPRequest? {
        return self.shared.request(service: SOCIAL_SIGN_IN_REQUEST, params: user.toDictionary() as! [String : Any], completion:completion);
    } //F.E.
    
    @discardableResult
    public static func editProfile(user:User, completion:@escaping GISTAuthCompletion) -> HTTPRequest? {
        return self.shared.request(service: EDIT_PROFILE_REQUEST, params: user.toDictionary() as! [String : Any], completion:completion);
    } //F.E.
    
    func request(service:String, fields:[ValidatedTextField], completion:@escaping GISTAuthCompletion) -> HTTPRequest? {
        guard GISTUtility.validate(fields: fields) else {
            return nil;
        }
        
        return self.request(service: service, params: GISTUtility.formate(fields: fields), completion:completion);
    } //F.E.
    
    func request(service:String, params:[String:Any], completion:@escaping GISTAuthCompletion) -> HTTPRequest  {
        
        var uParams:[String:Any] = params;
        uParams["device_type"] = "ios";
        
        if let token:String = GIST_GLOBAL.deviceToken {
            uParams["device_token"] = token;
        }
        
        let httpRequest:HTTPRequest = HTTPServiceManager.request(requestName: service, parameters: uParams, delegate: nil);
        
        httpRequest.onSuccess { (data:Any?) in
            let dicData:[String:Any]? = data as? [String:Any];
            
            if let userData:[String:Any] = dicData?["user"] as? [String:Any], let user:User = Mapper<User>().map(JSON: userData) {
                
                GIST_GLOBAL.user = user;
                
                completion(user, data);
            }
        }
        
        return httpRequest;
    } //F.E.

} //CLS END
