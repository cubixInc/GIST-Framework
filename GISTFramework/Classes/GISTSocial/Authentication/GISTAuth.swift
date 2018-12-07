//
//  GISTAuth.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 07/04/2017.
//  Copyright © 2017 Social Cubix. All rights reserved.
//

import UIKit
import ObjectMapper

private let SIGN_UP_REQUEST = "";
private let MOBILE_SIGN_UP_REQUEST = "mobile_signup";

private let SIGN_IN_REQUEST = "signin";
private let SOCIAL_SIGN_IN_REQUEST = "social_login";

private let EDIT_PROFILE_REQUEST = "edit_profile";

private let RESEND_CODE_REQUEST = "resend_code";
private let VERIFY_PHONE_REQUEST = "verify_phone";

private let FORGOT_PASSWORD_REQUEST = "forgot_request";
private let CHANGE_PASSWORD_REQUEST = "change_password";

private let RESET_PASSWORD_REQUEST = "reset_password";

private let DELETE_ACCOUNT = "delete_account";

private let CHANGE_LOGIN_ID = "change_id_request";

private let SAVE_TOKEN_REQUEST = "save_token";


public class GISTAuth<T:GISTUser>: NSObject {
    
    public typealias GISTAuthCompletion = (T?, Any?) -> Void
    public typealias GISTAuthFailure = (_ error:NSError) -> Void
    
    //PRIVATE init so that singleton class should not be reinitialized from anyother class
    fileprivate override init() {
        super.init();
    } //C.E.
    
    //MARK: - Sign Up
    public static func signUp(fields:[ValidatedTextInput], additional params:[String:Any]?, completion:@escaping GISTAuthCompletion, failure:GISTAuthFailure?) {
        self.request(service: SIGN_UP_REQUEST, fields: fields, additional:params, completion:completion, failure:failure);
    } //F.E.
    
    public static func signUp(arrData:NSMutableArray, additional params:[String:Any]?, ignore iParams:[String]?, completion:@escaping GISTAuthCompletion, failure:GISTAuthFailure?) {

        self.request(service: SIGN_UP_REQUEST, arrData: arrData, additional:params, ignore:iParams, completion:completion, failure:failure);
    } //F.E.
    
    public static func signUp(params:[String:Any], completion:@escaping GISTAuthCompletion, failure:GISTAuthFailure?) {
        self.request(service: SIGN_UP_REQUEST, params: params, completion:completion, failure:failure);
    } //F.E.
    
    //MARK: - Sign In
    public static func signIn(fields:[ValidatedTextInput], additional params:[String:Any]?, completion:@escaping GISTAuthCompletion, failure:GISTAuthFailure?) {
        self.request(service: SIGN_IN_REQUEST, fields: fields, additional:params, completion:completion, failure:failure);
    } //F.E.
    
    public static func signIn(arrData:NSMutableArray, additional params:[String:Any]?, completion:@escaping GISTAuthCompletion, failure:GISTAuthFailure?) {
        
        self.request(service: SIGN_IN_REQUEST, arrData: arrData, additional:params, ignore:nil, completion:completion, failure:failure);
    } //F.E.
    
    public static func signIn(params:[String:Any], completion:@escaping GISTAuthCompletion, failure:GISTAuthFailure?) {
        self.request(service: SIGN_IN_REQUEST, params: params, completion:completion, failure:failure);
    } //F.E.
    
    public static func signIn(user:T, additional params:[String:Any]?, completion:@escaping GISTAuthCompletion, failure:GISTAuthFailure?) {
        
        let service:String
        
        if let platformType:String = user.platformType, platformType != "custom" {
            service = SOCIAL_SIGN_IN_REQUEST;
        } else {
            service = SIGN_IN_REQUEST;
        }
        
        self.request(service: service, params: GISTSocialUtils.formate(user: user, additional: params), completion:completion, failure:failure);
    } //F.E.
    
    //MARK: - Edit Profile
    
    public static func editProfile(arrData:NSMutableArray, additional params:[String:Any]?, ignore iParams:[String]?, completion:@escaping GISTAuthCompletion, failure:GISTAuthFailure?) {
        
        guard let userId:Int = GIST_GLOBAL.userData?[USER_ID] as? Int else {
            return;
        }
        
        var aParams:[String:Any] = params ?? [:];
        aParams[USER_ID] = userId;
        
        self.request(service: EDIT_PROFILE_REQUEST, arrData: arrData, additional:aParams, ignore:iParams, completion:completion, failure:failure);
    } //F.E.
    
    public static func editProfile(params:[String:Any]?, completion:@escaping GISTAuthCompletion, failure:GISTAuthFailure?) {
        
        guard let userId:Int = GIST_GLOBAL.userData?[USER_ID] as? Int else {
            return;
        }
        
        var aParams:[String:Any] = params ?? [:];
        aParams[USER_ID] = userId;
        
        self.request(service: EDIT_PROFILE_REQUEST, params: aParams, completion:completion, failure:failure);
    } //F.E.
    

    public static func changeLoginId(new loginId:String, additional params:[String:Any]?, completion:@escaping GISTAuthCompletion, failure:GISTAuthFailure?) {
        
        guard let userId:Int = GIST_GLOBAL.userData?[USER_ID] as? Int else {
            return;
        }
        
        var aParams:[String:Any] = params ?? [:];
        aParams[USER_ID] = userId;
        aParams["new_login_id"] = loginId;
        
        self.request(service: CHANGE_LOGIN_ID, params: aParams, completion:completion, failure:failure);
    } //F.E.
    
    //MARK: - Verify Phone
    public static func verifyPhone(code:String, additional params:[String:Any]?, completion:@escaping GISTAuthCompletion, failure:GISTAuthFailure?) {

        guard let usrData:[String:Any] = GIST_GLOBAL.userData, let mobileNo:String = usrData["mobile_no"] as? String, let verificationToken:String = usrData["verification_token"] as? String else {
            return;
        }
        
        let newMobileNo:String = usrData["new_mobile_no"] as? String ?? "";
        
        let isVerified:Bool = (usrData["is_verified"] as? Bool) ?? false;
        let userId:Int? = usrData[USER_ID] as? Int;
        
        let verificationMode:String = (userId == nil) ? "forgot" : (isVerified ? "change_mobile_no" : "signup");
        
        var aParams:[String:Any] = params ?? [:];
        
        aParams["mobile_no"] = (newMobileNo != "") ? newMobileNo : mobileNo;
        aParams["authy_code"] = code;
        aParams["verification_token"] = verificationToken;
        aParams["verification_mode"] = verificationMode;
        
        self.request(service: VERIFY_PHONE_REQUEST, params: aParams, completion:completion, failure:failure);
    } //F.E.
    
    public static func resendCode(additional params:[String:Any]?, completion:@escaping GISTAuthCompletion, failure:GISTAuthFailure?) {
        
        guard let usrData:[String:Any] = GIST_GLOBAL.userData, let mobileNo:String = usrData["mobile_no"] as? String else {
            return;
        }
        
        let newMobileNo:String = usrData["new_mobile_no"] as? String ?? "";
        
        var aParams:[String:Any] = params ?? [:];
        aParams["mobile_no"] = (newMobileNo != "") ? newMobileNo : mobileNo;
        
        self.request(service: RESEND_CODE_REQUEST, params: aParams, completion:completion, failure:failure);
    } //F.E.
    
    //MARK: - Forgot Password
    public static func forgotPassword(fields:[ValidatedTextInput], additional params:[String:Any]?, completion:@escaping GISTAuthCompletion, failure:GISTAuthFailure?) {
        self.request(service: FORGOT_PASSWORD_REQUEST, fields: fields, additional: params, completion: completion, failure: failure);
    } //F.E.
    
    public static func forgotPassword(arrData:NSMutableArray, additional params:[String:Any]?, completion:@escaping GISTAuthCompletion, failure:GISTAuthFailure?) {
        self.request(service: FORGOT_PASSWORD_REQUEST, arrData: arrData, additional:params, ignore:nil, completion:completion, failure:failure);
    } //F.E.
    
    //MARK: - Change Password
    public static func changePassword(fields:[ValidatedTextInput], additional params:[String:Any]?, completion:@escaping GISTAuthCompletion, failure:GISTAuthFailure?) {
        
        guard let userId:Int = GIST_GLOBAL.userData?[USER_ID] as? Int else {
            return;
        }
        
        var aParams:[String:Any] = params ?? [:];
        aParams[USER_ID] = userId;
        
        self.request(service: CHANGE_PASSWORD_REQUEST, fields: fields, additional: aParams, completion: completion, failure: failure);
    } //F.E.
    
    //MARK: - Reset Password
    public static func resetPassword(fields:[ValidatedTextInput], completion:@escaping GISTAuthCompletion, failure:GISTAuthFailure?) {
        guard let verificationToken:String = GIST_GLOBAL.userData?["verification_token"] as? String else {
            return;
        }
        
        let aParams:[String:Any] = [
            "verification_token":verificationToken
        ];
        
        self.request(service: RESET_PASSWORD_REQUEST, fields: fields, additional: aParams, completion: completion, failure: failure);
    } //F.E.
    
    //MARK: - Save Token
    internal static func savePushToken(_ deviceToken:String, additional params: [String:Any]?) {
        
        GIST_GLOBAL.deviceToken = deviceToken;
        
        guard let userData = GIST_GLOBAL.userData, let userId:Int = userData[USER_ID] as? Int else {
            return;
        }
        
        if let cDeviceToken:String = userData["device_token"] as? String, cDeviceToken == deviceToken {
            //Already Saved To
            return;
        }

        var aParams:[String:Any] = params ?? [:];
        aParams[USER_ID] = userId;
        
        self.request(service: SAVE_TOKEN_REQUEST, params: aParams, completion: { (user, rawData) in
            //Saved
            print("Token saved ... !");
        }, failure: nil);
    } //F.E.
    
    //MARK: - Sign Out
    public static func signOut() {
        GIST_GLOBAL.userData = nil;
    } //F.E.
    
    //MARK: - Delete Account
    public static func deleteAccount(additional aParams: [String:Any]?, completion:@escaping GISTAuthCompletion, failure:GISTAuthFailure?) {
        
        guard let userId:Int = GIST_GLOBAL.userData?[USER_ID] as? Int else {
            return;
        }
        
        var params:[String:Any] = aParams ?? [:];
        params[USER_ID] = userId;
        
        
        self.request(service: DELETE_ACCOUNT, params: params, completion: { (user:GISTUser?, rawData:Any?) in
            
            self.signOut();
            
            completion(nil, rawData);
            
        }, failure: failure);
    } //F.E.
    
    //MARK: - Requests
    private static func request(service:String, arrData:NSMutableArray, additional aParams:[String:Any]?, ignore iParams:[String]?, completion:@escaping GISTAuthCompletion, failure:GISTAuthFailure?) {
        
        
        guard GISTSocialUtils.validate(array: arrData, ignore:iParams) else {
            if (failure != nil) {
                let error = NSError(domain: "com.cubix.gist", code: -1, userInfo: nil);
                failure!(error);
            }
            return;
        }
        
        self.request(service: service, params: GISTSocialUtils.formate(array: arrData, additional: aParams, ignore:iParams), completion:completion, failure:failure);
    } //F.E.
    
    private static func request(service:String, fields:[ValidatedTextInput], additional params:[String:Any]?, completion:@escaping GISTAuthCompletion, failure:GISTAuthFailure?) {
        
        guard GISTSocialUtils.validate(fields: fields) else {
            if (failure != nil) {
                let error = NSError(domain: "com.cubix.gist", code: -1, userInfo: nil);
                failure!(error);
            }
            return;
        }
        
        self.request(service: service, params: GISTSocialUtils.formate(fields: fields, additional:params), completion:completion, failure:failure);
        
    } //F.E.
    
    private static func request(service:String, params:[String:Any], completion:GISTAuthCompletion?, failure:GISTAuthFailure?)  {
        
        if (service == SIGN_UP_REQUEST || service == SIGN_IN_REQUEST ||  service == MOBILE_SIGN_UP_REQUEST || service == SOCIAL_SIGN_IN_REQUEST || service == FORGOT_PASSWORD_REQUEST) {
            self.signOut();
        }
        
        var uParams:[String:Any] = params;
                
        uParams["device_type"] = "ios";
        
        if (HTTPServiceManager.sharedInstance.entityFramework) {
            uParams["entity_type_id"] = "user";
        }

        if let token:String = GIST_GLOBAL.deviceToken {
            uParams["device_token"] = token;
        }
        
        if let mobileNo:String = uParams["mobile_no"] as? String, let countryCode:String = uParams["country_code"] as? String {
            
            var uMobileNo = mobileNo;
            
            if (mobileNo.contains("-")) {
                uMobileNo = mobileNo.components(separatedBy: "-").last ?? "";
            } else if (mobileNo.hasPrefix("0")) {
                uMobileNo.remove(at: uMobileNo.startIndex);
            }
            
            uParams["mobile_no"] = "\(countryCode)-\(uMobileNo)";
        }
        
        let requestName:String;
        
        if service == SIGN_UP_REQUEST, uParams["mobile_no"] != nil, uParams["password"] == nil  {
            requestName = "\(HTTPServiceManager.sharedInstance.authenticationModule)/\(MOBILE_SIGN_UP_REQUEST)";
        } else {
            requestName = (service == "") ? HTTPServiceManager.sharedInstance.authenticationModule : "\(HTTPServiceManager.sharedInstance.authenticationModule)/\(service)";
        }
        
        let httpRequest:HTTPRequest
        
        
        //Multipart Request
        if let rawImage:UIImage = uParams["raw_image"] as? UIImage {
            print("raw : \(rawImage)");
            
            let imgData:Data;
            
            if (rawImage.size.width > 400 || rawImage.size.height > 400) {
                
                imgData = rawImage.scaleAndRotateImage(400).jpegData(compressionQuality: 1)!;
            } else {
                imgData = rawImage.jpegData(compressionQuality: 1)!;
            }
            
            uParams["raw_image"] = imgData;
            
            //Multipart Request
            httpRequest = HTTPServiceManager.multipartRequest(requestName: requestName, parameters: uParams, delegate: nil)
        } else {
            httpRequest = HTTPServiceManager.request(requestName: requestName, parameters: uParams, delegate: nil);
        }
        
        httpRequest.onSuccess { (rawData:Any?) in
            let dicData:[String:Any]? = rawData as? [String:Any];
            
            
            if let accessToken:String = dicData?["access_token"] as? String {
                GIST_GLOBAL.accessToken = accessToken;
            }

            if var userData:[String:Any] = dicData?["user"] as? [String:Any] {
                
                if let verificationMode:String = uParams["verification_mode"] as? String, verificationMode == "forgot" {
                    userData[USER_ID] = nil;
                }
                
                GIST_GLOBAL.userData = userData;
                
                let updateUser:T? = GIST_GLOBAL.getUser();
                
                completion?(updateUser, rawData);
            } else {
                completion?(nil, rawData);
            }
        };
        
        if (failure != nil) {
            httpRequest.onFailure(response: failure!);
        }
    } //F.E.
    
} //CLS END
