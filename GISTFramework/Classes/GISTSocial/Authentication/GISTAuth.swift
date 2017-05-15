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

private let RESEND_CODE_REQUEST = "users/resend_code";
private let VERIFY_PHONE_REQUEST = "users/verify_signup";

private let FORGOT_PASSWORD_REQUEST = "users/forgot";
private let CHANGE_PASSWORD_REQUEST = "users/change_password";


public class GISTAuth: NSObject {
    
    static let shared = GISTAuth();
    
    public typealias GISTAuthCompletion = (_ user:User?, _ rawData:Any?) -> Void
    public typealias GISTAuthFailure = (_ error:NSError) -> Void
    
    //PRIVATE init so that singleton class should not be reinitialized from anyother class
    fileprivate override init() {
    
    } //C.E.
    
    //MARK: - Sign Up
    public static func signUp(fields:[ValidatedTextField], additional params:[String:Any]?, completion:@escaping GISTAuthCompletion, failure:GISTAuthFailure?) {
        self.shared.request(service: SIGN_UP_REQUEST, fields: fields, additional:params, completion:completion, failure:failure);
    } //F.E.
    
    public static func signUp(arrData:NSMutableArray, additional params:[String:Any]?, completion:@escaping GISTAuthCompletion, failure:GISTAuthFailure?) {

        self.shared.request(service: SIGN_UP_REQUEST, arrData: arrData, additional:params, completion:completion, failure:failure);
    } //F.E.
    
    public static func signUp(params:[String:Any], completion:@escaping GISTAuthCompletion, failure:GISTAuthFailure?) {
        self.shared.request(service: SIGN_UP_REQUEST, params: params, completion:completion, failure:failure);
    } //F.E.
    
    public static func signUp(user:User, additional params:[String:Any]?, completion:@escaping GISTAuthCompletion, failure:GISTAuthFailure?) {
        self.shared.request(service: SIGN_UP_REQUEST, params: GISTUtility.formate(user: user, additional: params), completion:completion, failure:failure);
    } //F.E.
    
    //MARK: - Sign In
    public static func signIn(fields:[ValidatedTextField], additional params:[String:Any]?, completion:@escaping GISTAuthCompletion, failure:GISTAuthFailure?) {
        self.shared.request(service: SIGN_IN_REQUEST, fields: fields, additional:params, completion:completion, failure:failure);
    } //F.E.
    
    public static func signIn(arrData:NSMutableArray, additional params:[String:Any]?, completion:@escaping GISTAuthCompletion, failure:GISTAuthFailure?) {
        
        self.shared.request(service: SIGN_IN_REQUEST, arrData: arrData, additional:params, completion:completion, failure:failure);
    } //F.E.
    
    public static func signIn(params:[String:Any], completion:@escaping GISTAuthCompletion, failure:GISTAuthFailure?) {
        self.shared.request(service: SIGN_IN_REQUEST, params: params, completion:completion, failure:failure);
    } //F.E.
    
    public static func signIn(user:User, additional params:[String:Any]?, completion:@escaping GISTAuthCompletion, failure:GISTAuthFailure?) {
        
        let service:String
        
        if let platformType:String = user.platformType, platformType != "custom" {
            service = SOCIAL_SIGN_IN_REQUEST;
        } else {
            service = SIGN_IN_REQUEST;
        }
        
        self.shared.request(service: service, params: GISTUtility.formate(user: user, additional: params), completion:completion, failure:failure);
    } //F.E.
    
    //MARK: - Edit Profile
    public static func editProfile(updated user:User, additional params:[String:Any]?, completion:@escaping GISTAuthCompletion, failure:GISTAuthFailure?) {
        self.shared.request(service: EDIT_PROFILE_REQUEST, params: GISTUtility.formate(user: user, additional: params), completion:completion, failure:failure);
    } //F.E.
    
    //MARK: - Verify Phone
    public static func verifyPhone(code:String, completion:@escaping GISTAuthCompletion, failure:GISTAuthFailure?) {
        
        guard let mobileNo:String = GIST_GLOBAL.user?.mobileNo else {
            return;
        }
        
        var params:[String:Any] = ["mobile_no":mobileNo];
        params["code"] = code;
        
        self.shared.request(service: VERIFY_PHONE_REQUEST, params: params, completion:completion, failure:failure);
    } //F.E.
    
    public static func resendCode(code:String, completion:@escaping GISTAuthCompletion, failure:GISTAuthFailure?) {
        
        guard let mobileNo:String = GIST_GLOBAL.user?.mobileNo else {
            return;
        }
        
        let params:[String:Any] = ["mobile_no":mobileNo];
        
        self.shared.request(service: RESEND_CODE_REQUEST, params: params, completion:completion, failure:failure);
    } //F.E.
    
    //MARK: - Change Password
    public static func changePassword(fields:[ValidatedTextField], completion:@escaping GISTAuthCompletion, failure:GISTAuthFailure?) {
        
        guard let userId:Int = GIST_GLOBAL.user?.userId else {
            return;
        }
        
        let aParams:[String:Any] = ["user_id":userId];
        
        self.shared.request(service: CHANGE_PASSWORD_REQUEST, fields: fields, additional: aParams, completion: completion, failure: failure);
    } //F.E.
    
    //MARK: - Forgot Password
    public static func forgotPassword(fields:ValidatedTextField ..., completion:@escaping GISTAuthCompletion, failure:GISTAuthFailure?) {
        self.shared.request(service: FORGOT_PASSWORD_REQUEST, fields: fields, additional: nil, completion: completion, failure: failure);
    } //F.E.
    
    //MARK: - Save Token
    public static func savePushToken() {
        guard let userId:Int = GIST_GLOBAL.user?.userId, GIST_GLOBAL.deviceToken != nil else {
            return;
        }
        
        let params:[String:Any] = ["user_id":userId];
        
        self.shared.request(service: SAVE_TOKEN_REQUEST, params: params, completion:nil, failure:nil);
    } //F.E.
    
    public static func signOut() {
        GISTGlobal.shared.user = nil;
    } //F.E.
    
    //MARK: - Requests
    func request(service:String, arrData:NSMutableArray, additional params:[String:Any]?, completion:@escaping GISTAuthCompletion, failure:GISTAuthFailure?) {
        
        
        guard GISTUtility.validate(array: arrData) else {
            if (failure != nil) {
                let error = NSError(domain: "com.cubix.gist", code: -1, userInfo: nil);
                failure!(error);
            }
            return;
        }
        
        self.request(service: service, params: GISTUtility.formate(array: arrData, additional: params), completion:completion, failure:failure);
    } //F.E.
    
    func request(service:String, fields:[ValidatedTextField], additional params:[String:Any]?, completion:@escaping GISTAuthCompletion, failure:GISTAuthFailure?) {
        
        guard GISTUtility.validate(fields: fields) else {
            if (failure != nil) {
                let error = NSError(domain: "com.cubix.gist", code: -1, userInfo: nil);
                failure!(error);
            }
            return;
        }
        
        self.request(service: service, params: GISTUtility.formate(fields: fields, additional:params), completion:completion, failure:failure);
        
    } //F.E.
    
    func request(service:String, params:[String:Any], completion:GISTAuthCompletion?, failure:GISTAuthFailure?)  {
        
        var uParams:[String:Any] = params;
        uParams["device_type"] = "ios";
        
        if let token:String = GIST_GLOBAL.deviceToken {
            uParams["device_token"] = token;
        }
        
        let httpRequest:HTTPRequest = HTTPServiceManager.request(requestName: service, parameters: params, delegate: nil);
        
        httpRequest.onSuccess { (rawData:Any?) in
            let dicData:[String:Any]? = rawData as? [String:Any];
            
            if let userData:[String:Any] = dicData?["user"] as? [String:Any], let user:User = Mapper<User>().map(JSON: userData) {
                
                GIST_GLOBAL.user = user;
                
                completion?(user, rawData);
            } else {
                completion?(nil, rawData);
            }
        };
        
        if (failure != nil) {
            httpRequest.onFailure(response: failure!);
        }
    } //F.E.
    
} //CLS END
