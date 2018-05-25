//
//  GISTAuth.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 07/04/2017.
//  Copyright © 2017 Social Cubix. All rights reserved.
//

import ObjectMapper
import Alamofire


private let SIGN_UP_REQUEST = "signup"; //POST

private let VERIFY_EMAIL_REQUEST = "email-confirm"; //POST
private let VERIFY_PASSWORD_RESET_REQUEST = "verify-password-reset-token"; //POST

private let SIGN_IN_REQUEST = "signin"; //POST

private let FORGOT_PASSWORD_REQUEST = "send-password-recovery-email"; //POST
private let RESET_PASSWORD_REQUEST = "update-password"; //POST

private let RESEND_EMAIL_CODE_REQUEST = "resend-confirmation-email"; //POST

private let SIGN_OUT = "logout"; //GET

private let EDIT_PROFILE_REQUEST = "update-user"; // PUT

private let REFRESH_ACCESS_TOKEN = "refresh-access-token" // GET


/*
  NOT USING RIGHT NOW
private let MOBILE_SIGN_UP_REQUEST = "mobile_signup";
private let SOCIAL_SIGN_IN_REQUEST = "social_login";

private let VERIFY_PHONE_REQUEST = "verify_phone";

private let CHANGE_PASSWORD_REQUEST = "change_password";
private let DELETE_ACCOUNT = "delete_account";
private let CHANGE_LOGIN_ID = "change_id_request";
*/


public class GISTMicroAuth<T:GISTUser>: NSObject {
    
    public typealias GISTAuthCompletion = (T?, Any?) -> Void
    public typealias GISTAuthFailure = (_ error:NSError) -> Void
    
    //PRIVATE init so that singleton class should not be reinitialized from anyother class
    fileprivate override init() {
        super.init();
    } //C.E.
    
    //MARK: - Sign Up
    public static func signUp(fields:[ValidatedTextInput], additional params:[String:Any]?, completion:@escaping GISTAuthCompletion, failure:GISTAuthFailure?) {
        self.request(service: SIGN_UP_REQUEST, fields: fields, additional:params, method: HTTPMethod.post, completion:completion, failure:failure);
    } //F.E.
    
    public static func signUp(arrData:NSMutableArray, additional params:[String:Any]?, ignore iParams:[String]?, completion:@escaping GISTAuthCompletion, failure:GISTAuthFailure?) {

        self.request(service: SIGN_UP_REQUEST, arrData: arrData, additional:params, ignore:iParams, method: HTTPMethod.post, completion:completion, failure:failure);
    } //F.E.
    
    public static func signUp(params:[String:Any], completion:@escaping GISTAuthCompletion, failure:GISTAuthFailure?) {
        self.request(service: SIGN_UP_REQUEST, params: params, method: HTTPMethod.post, completion:completion, failure:failure);
    } //F.E.
    
    //MARK: - Sign In
    public static func signIn(fields:[ValidatedTextInput], additional params:[String:Any]?, completion:@escaping GISTAuthCompletion, failure:GISTAuthFailure?) {
        self.request(service: SIGN_IN_REQUEST, fields: fields, additional:params, method: HTTPMethod.post, completion:completion, failure:failure);
    } //F.E.
    
    public static func signIn(arrData:NSMutableArray, additional params:[String:Any]?, completion:@escaping GISTAuthCompletion, failure:GISTAuthFailure?) {
        
        self.request(service: SIGN_IN_REQUEST, arrData: arrData, additional:params, ignore:nil, method: HTTPMethod.post, completion:completion, failure:failure);
    } //F.E.
    
    public static func signIn(params:[String:Any], completion:@escaping GISTAuthCompletion, failure:GISTAuthFailure?) {
        self.request(service: SIGN_IN_REQUEST, params: params, method: HTTPMethod.post, completion:completion, failure:failure);
    } //F.E.
    
    public static func signIn(user:T, additional params:[String:Any]?, completion:@escaping GISTAuthCompletion, failure:GISTAuthFailure?) {

        var aParams:[String:Any] = params ?? [:];
        
        if let platformType:String = user.platformType, platformType != "custom" {
            aParams["social_login"] = true;
        }

        self.request(service: SIGN_IN_REQUEST, params: GISTSocialUtils.formate(user: user, additional: aParams), method: HTTPMethod.post, completion:completion, failure:failure);
    } //F.E.
    
    //MARK: - Edit Profile
    
    public static func editProfile(arrData:NSMutableArray, additional params:[String:Any]?, ignore iParams:[String]?, completion:@escaping GISTAuthCompletion, failure:GISTAuthFailure?) {

        let aParams:[String:Any] = params ?? [:];
        
        self.request(service: EDIT_PROFILE_REQUEST, arrData: arrData, additional:aParams, ignore:iParams, method: HTTPMethod.put, completion:completion, failure:failure);
    } //F.E.
    
    public static func editProfile(params:[String:Any]?, completion:@escaping GISTAuthCompletion, failure:GISTAuthFailure?) {

        let aParams:[String:Any] = params ?? [:];
        
        self.request(service: EDIT_PROFILE_REQUEST, params: aParams, method: HTTPMethod.put, completion:completion, failure:failure);
    } //F.E.
    

    /*
     NOT AVAILABLE RIGHT NOW
     
    public static func changeLoginId(new loginId:String, additional params:[String:Any]?, completion:@escaping GISTAuthCompletion, failure:GISTAuthFailure?) {
        
        guard let identifier:String = GIST_GLOBAL.userData?["identifier"] as? String else {
            return;
        }
        
        var aParams:[String:Any] = params ?? [:];
        aParams["identifier"] = identifier;
        aParams["new_login_id"] = loginId;
        
        self.request(service: CHANGE_LOGIN_ID, params: aParams, completion:completion, failure:failure);
    } //F.E.
    */
    
    //MARK: - Verify Phone
    /*
     NOT AVAILABLE RIGHT NOW
    public static func verifyPhone(code:String, additional params:[String:Any]?, completion:@escaping GISTAuthCompletion, failure:GISTAuthFailure?) {

        guard let usrData:[String:Any] = GIST_GLOBAL.userData, let identifier:String = usrData["identifier"] as? String else {
            return;
        }
        
        var aParams:[String:Any] = params ?? [:];
        
        aParams["identifier"] = identifier;
        aParams["code"] = code;

        self.request(service: VERIFY_PHONE_REQUEST, params: aParams, completion:completion, failure:failure);
    } //F.E.
     */
    
    public static func verifyEmail(token:String, additional params:[String:Any]?, completion:@escaping GISTAuthCompletion, failure:GISTAuthFailure?) {
        var aParams:[String:Any] = params ?? [:];
        
        aParams["token"] = token;
        
        let service:String;
        
        if GIST_GLOBAL.userData == nil {
            service = VERIFY_PASSWORD_RESET_REQUEST;
        } else {
            service = VERIFY_EMAIL_REQUEST;
        }
        
        self.request(service: service, params: aParams, method: HTTPMethod.post, completion:completion, failure:failure);
    } //F.E.
    
    
    /*
     NOT AVAILABLE RIGHT NOW
    public static func resendCode(additional params:[String:Any]?, completion:@escaping GISTAuthCompletion, failure:GISTAuthFailure?) {
        
        guard let usrData:[String:Any] = GIST_GLOBAL.userData, let identifier:String = usrData["identifier"] as? String else {
            return;
        }
        
        var aParams:[String:Any] = params ?? [:];
        aParams["identifier"] = identifier;
        
        self.request(service: RESEND_CODE_REQUEST, params: aParams, completion:completion, failure:failure);
    } //F.E.
     */
    
    public static func resendEmailCode(additional params:[String:Any]?, completion:@escaping GISTAuthCompletion, failure:GISTAuthFailure?) {
        guard let usrData:[String:Any] = GIST_GLOBAL.userData, let email:String = usrData["email"] as? String else {
            return;
        }
        
        var aParams:[String:Any] = params ?? [:];
        aParams["email"] = email;
        
        self.request(service: RESEND_EMAIL_CODE_REQUEST, params: aParams, method: HTTPMethod.post, completion:completion, failure:failure);
    } //F.E.
    
    //MARK: - Forgot Password
    public static func forgotPassword(fields:[ValidatedTextInput], additional params:[String:Any]?, completion:@escaping GISTAuthCompletion, failure:GISTAuthFailure?) {
        self.request(service: FORGOT_PASSWORD_REQUEST, fields: fields, additional: params, method: HTTPMethod.post, completion: completion, failure: failure);
    } //F.E.
    
    public static func forgotPassword(arrData:NSMutableArray, additional params:[String:Any]?, completion:@escaping GISTAuthCompletion, failure:GISTAuthFailure?) {
        self.request(service: FORGOT_PASSWORD_REQUEST, arrData: arrData, additional:params, ignore:nil, method: HTTPMethod.post, completion:completion, failure:failure);
    } //F.E.
    
    //MARK: - Change Password
    /*
     NOT AVAILABLE RIGHT NOW
    public static func changePassword(fields:[ValidatedTextInput], additional params:[String:Any]?, completion:@escaping GISTAuthCompletion, failure:GISTAuthFailure?) {
        
        guard let identifier:String = GIST_GLOBAL.userData?["identifier"] as? String else {
            return;
        }
        
        var aParams:[String:Any] = params ?? [:];
        aParams["identifier"] = identifier;
        
        self.request(service: CHANGE_PASSWORD_REQUEST, fields: fields, additional: aParams, completion: completion, failure: failure);
    } //F.E.
    */
    
    //MARK: - Reset Password
    public static func resetPassword(fields:[ValidatedTextInput], completion:@escaping GISTAuthCompletion, failure:GISTAuthFailure?) {

        guard let passwordResetToken:String = GIST_GLOBAL.userData?["passwordResetToken"] as? String else {
            return;
        }
        
        let aParams:[String:Any] = [
            "token":passwordResetToken
        ];
        
        self.request(service: RESET_PASSWORD_REQUEST, fields: fields, additional: aParams, method: HTTPMethod.post, completion: completion, failure: failure);
    } //F.E.
    
    //MARK: - Sign Out
    public static func signOut(additional aParams: [String:Any]?) {
        defer {
            self.cleanup();
        }

        self.request(service: SIGN_OUT, params: aParams ?? [:], method: HTTPMethod.get, completion: { (user, rawData) in
            print("Successfully SIGN_OUT")
        }) { (error) in
            //Cleanup in either case
            print("SIGN_OUT error : \(error.localizedDescription)");
        }
    } //F.E.
    
    //MARK: - Save Token
    internal static func savePushToken(_ deviceToken:String, additional params: [String:Any]?) {
        
        GIST_GLOBAL.deviceToken = deviceToken;
        
        guard let userData = GIST_GLOBAL.userData, GIST_GLOBAL.accessToken != nil else {
            return;
        }
        
        
        if let cDeviceToken:String = userData["device_token"] as? String, cDeviceToken == deviceToken {
            //Already Saved To
            return;
        }

        let aParams:[String:Any] = params ?? [:];
        
        self.request(service: EDIT_PROFILE_REQUEST, params: aParams, method: HTTPMethod.put, completion: { (user, rawData) in
            //Saved
            print("Token saved ... !");
        }, failure: nil);
    } //F.E.
    
    //MARK: - Refresh Access token - It refereshes access token, only when it is required
    public static func refreshAccessToken() {
        guard let _ = GIST_GLOBAL.userData, GIST_GLOBAL.accessToken != nil else {
            return;
        }
        
        let curTimeIntervale:TimeInterval = Date().timeIntervalSince1970;
        
        let expiryTimeIntervale:TimeInterval = GIST_GLOBAL.accessTokenValidTill ?? curTimeIntervale;
        
        let halfDuration:TimeInterval = GIST_GLOBAL.accessTokenDuration / 2.0;

        let diff = expiryTimeIntervale - curTimeIntervale;
        
        guard (diff > 0 &&  diff < halfDuration) || halfDuration == 0 else {
            return;
        }

        self.request(service: REFRESH_ACCESS_TOKEN, params: [:], method: HTTPMethod.get, completion: { (user, rawData) in
            print("Successfully REFRESH_ACCESS_TOKEN")
        }) { (error) in
            //Cleanup in either case
            print("Access token error : \(error.localizedDescription)");
        }
    } //F.E.
    
    private static func cleanup() {
        GIST_GLOBAL.userData = nil;
        GIST_GLOBAL.accessToken = nil;
    } //F.E.
    
    //MARK: - Delete Account
    /*
     NOT AVAILABLE RIGHT NOW
    public static func deleteAccount(additional aParams: [String:Any]?, completion:@escaping GISTAuthCompletion, failure:GISTAuthFailure?) {
        
        guard let identifier:String = GIST_GLOBAL.userData?["identifier"] as? String else {
            return;
        }
        
        var params:[String:Any] = aParams ?? [:];
        params["identifier"] = identifier;
        
        
        self.request(service: DELETE_ACCOUNT, params: params, completion: { (user:GISTUser?, rawData:Any?) in
            
            self.cleanup();
            completion(nil, rawData);
            
        }, failure: failure);
    } //F.E.
    */
    
    //MARK: - Requests
    private static func request(service:String, arrData:NSMutableArray, additional aParams:[String:Any]?, ignore iParams:[String]?, method: HTTPMethod, completion:@escaping GISTAuthCompletion, failure:GISTAuthFailure?) {
        
        
        guard GISTSocialUtils.validate(array: arrData, ignore:iParams) else {
            if (failure != nil) {
                let error = NSError(domain: "com.cubix.gist", code: -1, userInfo: nil);
                failure!(error);
            }
            return;
        }
        
        self.request(service: service, params: GISTSocialUtils.formate(array: arrData, additional: aParams, ignore:iParams), method:method, completion:completion, failure:failure);
    } //F.E.
    
    private static func request(service:String, fields:[ValidatedTextInput], additional params:[String:Any]?, method: HTTPMethod, completion:@escaping GISTAuthCompletion, failure:GISTAuthFailure?) {
        
        guard GISTSocialUtils.validate(fields: fields) else {
            if (failure != nil) {
                let error = NSError(domain: "com.cubix.gist", code: -1, userInfo: nil);
                failure!(error);
            }
            return;
        }
        
        self.request(service: service, params: GISTSocialUtils.formate(fields: fields, additional:params), method:method, completion:completion, failure:failure);
        
    } //F.E.
    
    private static func request(service:String, params:[String:Any], method: HTTPMethod, completion:GISTAuthCompletion?, failure:GISTAuthFailure?)  {
//        if (service == SIGN_UP_REQUEST || service == SIGN_IN_REQUEST ||  service == MOBILE_SIGN_UP_REQUEST || service == SOCIAL_SIGN_IN_REQUEST || service == FORGOT_PASSWORD_REQUEST) {
        
        if (service == SIGN_UP_REQUEST || service == SIGN_IN_REQUEST || service == FORGOT_PASSWORD_REQUEST) {
            self.cleanup();
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
        
        let httpRequest:HTTPRequest = HTTPServiceManager.request(requestName: service, parameters: uParams, method: method, showHud: true, delegate: nil);
        
        httpRequest.onSuccess { (rawData:Any?) in
            let dicData:[String:Any]? = rawData as? [String:Any];
            
//            "access_token": {
//                "token": "du2atrc4mzi8296myr8ra6xabikjz27s6tw1o8yd",
//                "valid_till": "1527142952758"
//            }
            if let accessToken:[String:Any] = dicData?["access_token"] as? [String:Any] {
                self.updateAccessToken(accessToken);
            }
            
            if let userData:[String:Any] = dicData?["user"] as? [String:Any] {
                
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
    
    private static func updateAccessToken(_ accessToken:[String:Any]) {
        if let token:String = accessToken["token"] as? String {
            GIST_GLOBAL.accessToken = token;
        }
        
        if let validAccessTokenTill:String = accessToken["valid_till"] as? String, let expiryTimeInMili:TimeInterval = TimeInterval(validAccessTokenTill) {
            
            let expiryInSec:TimeInterval = expiryTimeInMili / 1000.0;
            
            GIST_GLOBAL.accessTokenValidTill = expiryInSec;
            
            let curTimeIntervale:TimeInterval = Date().timeIntervalSince1970;

            GIST_GLOBAL.accessTokenDuration = expiryInSec - curTimeIntervale;
        } else {
            GIST_GLOBAL.accessTokenValidTill = nil;
            GIST_GLOBAL.accessTokenDuration = 0;
        }
    } //F.E.
    
} //CLS END
