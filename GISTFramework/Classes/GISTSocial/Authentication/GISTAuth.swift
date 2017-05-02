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

private let SAVE_TOKEN_REQUEST = "users/save_token";

public class GISTAuth: NSObject {
    
    static let shared = GISTAuth();
    
    public typealias GISTAuthCompletion = (_ user:User, _ rawData:Any?) -> Void
    public typealias GISTAuthFailure = (_ error:NSError) -> Void
    
    //PRIVATE init so that singleton class should not be reinitialized from anyother class
    fileprivate override init() {} //C.E.
    
    public static func signUp(fields:ValidatedTextField ..., completion:@escaping GISTAuthCompletion, failure:GISTAuthFailure? = nil) {
        self.shared.request(service: SIGN_UP_REQUEST, fields: fields, completion:completion, failure:failure);
    } //F.E.
    
    public static func signUp(params:[String:Any], completion:@escaping GISTAuthCompletion, failure:GISTAuthFailure? = nil) {
        self.shared.request(service: SIGN_UP_REQUEST, params: params, completion:completion, failure:failure);
    } //F.E.
    
    public static func signIn(fields:ValidatedTextField ..., completion:@escaping GISTAuthCompletion, failure:GISTAuthFailure? = nil) {
        self.shared.request(service: SIGN_IN_REQUEST, fields: fields, completion:completion, failure:failure);
    } //F.E.
    
    public static func signIn(params:[String:Any], completion:@escaping GISTAuthCompletion, failure:GISTAuthFailure? = nil) {
        self.shared.request(service: SIGN_IN_REQUEST, params: params, completion:completion, failure:failure);
    } //F.E.
    
    public static func socialSignIn(user:User, completion:@escaping GISTAuthCompletion, failure:GISTAuthFailure? = nil) {
        self.shared.request(service: SOCIAL_SIGN_IN_REQUEST, params: user.toDictionary() as! [String : Any], completion:completion, failure:failure);
    } //F.E.
    
    public static func editProfile(user:User, completion:@escaping GISTAuthCompletion, failure:GISTAuthFailure? = nil) {
        self.shared.request(service: EDIT_PROFILE_REQUEST, params: user.toDictionary() as! [String : Any], completion:completion, failure:failure);
    } //F.E.
    
    public static func savePushToken() {
        guard let user:User = GIST_GLOBAL.user, GIST_GLOBAL.deviceToken != nil else {
            return;
        }
        
        let params:[String:Any] = ["user_id":user.userId!];
        
        self.shared.request(service: SAVE_TOKEN_REQUEST, params: params, completion:nil, failure:nil);
    } //F.E.
    
    func request(service:String, fields:[ValidatedTextField], completion:@escaping GISTAuthCompletion, failure:GISTAuthFailure? = nil) {
        
        guard GISTUtility.validate(fields: fields) else {
            if (failure != nil) {
                let error = NSError(domain: "com.cubix.gist", code: -1, userInfo: nil);
                failure!(error);
            }
            return;
        }
        
        self.request(service: service, params: GISTUtility.formate(fields: fields), completion:completion, failure:failure);
    } //F.E.
    
    func request(service:String, params:[String:Any], completion:GISTAuthCompletion?, failure:GISTAuthFailure? = nil)  {
        
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
                
                completion?(user, data);
            }
        }
        
        if (failure != nil) {
            httpRequest.onFailure(response: failure!);
        }
    } //F.E.

} //CLS END
