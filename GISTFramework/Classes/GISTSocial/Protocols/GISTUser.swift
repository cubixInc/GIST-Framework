//
//  GISTUser.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 25/05/2017.
//  Copyright © 2017 Social Cubix. All rights reserved.
//

import Foundation
import ObjectMapper

/*
{"kick_user":0,"data":{"user":{"user_id":134,"type":"user","name":"","first_name":"","last_name":"","user_name":null,"email":"","dob":null,"gender":"male","image":"","thumb":"","status":1,"platform_type":"facebook","platform_id":"76543212","device_udid":"","device_type":"ios","mobile_no":"","city_id":null,"country_id":null,"state_id":null,"zip_code":"","device_token":"","is_verified":1,"mobile_verified_at":null,"is_email_verified":0,"verification_token":null,"is_mobile_verified":0,"sent_email_verification":0,"sent_mobile_verification":0,"is_guest":0,"additional_note":null,"other_data":null,"remember_login_token_created_at":null,"last_login_at":"2017-05-25 07:45:24","last_seen_at":null,"created_at":"2017-05-25 07:42:16","updated_at":null},"client_token":"XapP@#_xw-Oof295807e082fdb158578918241b5213e"},"message":"Success","error":0}
    */

public protocol GISTUser: Mappable, ReverseMappable, NSCopying {
    var userId: Int? {get set};
    var type: String? {get set};
    
    var email: String? {get set};
    var mobileNo: String? {get set};
    
    var platformId: String? {get set};
    var platformType: String? {get set};
    
    var isVerified: Bool? {get set};
    
    var isMobileVerified: Bool? {get set};
    var isEmailVerified: Bool? {get set};
    
    var verificationToken: String? {get set};
    
    var sentEmailVerification: Bool? {get set};
    var sentMobileVerification: Bool? {get set};
    
    var clientToken: String? {get set};
    var rawImage: UIImage? {get set};
    
    init();
} //P.E.
