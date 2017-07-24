//
//  GISTUser.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 25/05/2017.
//  Copyright © 2017 Social Cubix. All rights reserved.
//

import Foundation
import ObjectMapper

///ModelUser User
public class ModelUser:NSObject, GISTUser {
    public var clientToken: String?;
    public var deviceToken: String?;
    public var email: String?;
    public var isEmailVerified: Bool?;
    public var isMobileVerified: Bool?;
    public var isVerified: Bool?;
    public var mobileNo: String?;
    public var platformId: String?;
    public var platformType: String?;
    public var sentEmailVerification: Bool?;
    public var sentMobileVerification: Bool?;
    public var type: String?;
    public var entityId: Int?;
    public var verificationToken: String?;
    public var rawImage: UIImage?;
    
    public var userName: String?;
    public var firstName: String?;
    public var lastName: String?;
    
    public var image: String?;
    public var thumb: String?;
    
    required public init?(map: Map) {
    }
    
    override required public init() {
        super.init();
    }
    
    public func mapping(map: Map) {
        clientToken <- map["client_token"];
        deviceToken <- map["device_token"];
        email <- map["email"];
        isEmailVerified <- map["is_email_verified"];
        isMobileVerified <- map["is_mobile_verified"];
        isVerified <- map["is_verified"];
        mobileNo <- map["mobile_no"];
        platformId <- map["platform_id"];
        platformType <- map["platform_type"];
        sentEmailVerification <- map["sent_email_verification"];
        sentMobileVerification <- map["sent_mobile_verification"];
        type <- map["type"];
        entityId <- map["entity_id"];
        verificationToken <- map["verification_token"];
        
        userName <- map["user_name"];
        firstName <- map["first_name"];
        lastName <- map["last_name"];
        image <- map["image"];
        
        thumb <- map["thumb"];
    }
    
    required public init(coder aDecoder: NSCoder) {
        clientToken = aDecoder.decodeObject(forKey: "client_token") as? String;
        deviceToken = aDecoder.decodeObject(forKey: "device_token") as? String;
        email = aDecoder.decodeObject(forKey: "email") as? String;
        isEmailVerified = aDecoder.decodeObject(forKey: "is_email_verified") as? Bool;
        isMobileVerified = aDecoder.decodeObject(forKey: "is_mobile_verified") as? Bool;
        isVerified = aDecoder.decodeObject(forKey: "is_verified") as? Bool;
        mobileNo = aDecoder.decodeObject(forKey: "mobile_no") as? String;
        platformId = aDecoder.decodeObject(forKey: "platform_id") as? String;
        platformType = aDecoder.decodeObject(forKey: "platform_type") as? String;
        sentEmailVerification = aDecoder.decodeObject(forKey: "sent_email_verification") as? Bool;
        sentMobileVerification = aDecoder.decodeObject(forKey: "sent_mobile_verification") as? Bool;
        type = aDecoder.decodeObject(forKey: "type") as? String;
        entityId = aDecoder.decodeObject(forKey: "entity_id") as? Int;
        verificationToken = aDecoder.decodeObject(forKey: "verification_token") as? String;
        
        userName = aDecoder.decodeObject(forKey: "user_name") as? String;
        firstName = aDecoder.decodeObject(forKey: "first_name") as? String;
        lastName = aDecoder.decodeObject(forKey: "last_name") as? String;
        image = aDecoder.decodeObject(forKey: "image") as? String;
        
        thumb = aDecoder.decodeObject(forKey: "thumb") as? String;
    }
    
    public func encodeWithCoder(_ aCoder: NSCoder) {
        aCoder.encode(clientToken, forKey: "client_token");
        aCoder.encode(deviceToken, forKey: "device_token");
        aCoder.encode(email, forKey: "email");
        aCoder.encode(isEmailVerified, forKey: "is_email_verified");
        aCoder.encode(isMobileVerified, forKey: "is_mobile_verified");
        aCoder.encode(isVerified, forKey: "is_verified");
        aCoder.encode(mobileNo, forKey: "mobile_no");
        aCoder.encode(platformId, forKey: "platform_id");
        aCoder.encode(platformType, forKey: "platform_type");
        aCoder.encode(sentEmailVerification, forKey: "sent_email_verification");
        aCoder.encode(sentMobileVerification, forKey: "sent_mobile_verification");
        aCoder.encode(type, forKey: "type");
        aCoder.encode(entityId, forKey: "entity_id");
        aCoder.encode(verificationToken, forKey: "verification_token");
        
        aCoder.encode(userName, forKey: "user_name");
        aCoder.encode(firstName, forKey: "first_name");
        aCoder.encode(lastName, forKey: "last_name");
        aCoder.encode(image, forKey: "image");
        
        aCoder.encode(thumb, forKey: "thumb");
    }
    
    public func copy(with zone: NSZone? = nil) -> Any {
        return self.clone();
    }
    
    public func clone() -> ModelUser {
        let instance:ModelUser = ModelUser();
        
        instance.clientToken = self.clientToken;
        instance.deviceToken = self.deviceToken;
        instance.email = self.email;
        instance.isEmailVerified = self.isEmailVerified;
        instance.isMobileVerified = self.isMobileVerified;
        instance.isVerified = self.isVerified;
        instance.mobileNo = self.mobileNo;
        instance.platformId = self.platformId;
        instance.platformType = self.platformType;
        instance.sentEmailVerification = self.sentEmailVerification;
        instance.sentMobileVerification = self.sentMobileVerification;
        instance.type = self.type;
        instance.entityId = self.entityId;
        instance.verificationToken = self.verificationToken;
        instance.rawImage = self.rawImage;
        
        instance.userName = self.userName;
        instance.firstName = self.firstName;
        instance.lastName = self.lastName;
        instance.image = self.image;
        instance.thumb = self.thumb;
        
        return instance;
    }
    
    public func toDictionary () -> NSDictionary {
        let map:NSMutableDictionary = NSMutableDictionary();
        
        map["client_token"] = self.reverseMap(clientToken);
        map["device_token"] = self.reverseMap(deviceToken);
        map["email"] = self.reverseMap(email);
        map["is_email_verified"] = self.reverseMap(isEmailVerified);
        map["is_mobile_verified"] = self.reverseMap(isMobileVerified);
        map["is_verified"] = self.reverseMap(isVerified);
        map["mobile_no"] = self.reverseMap(mobileNo);
        map["platform_id"] = self.reverseMap(platformId);
        map["platform_type"] = self.reverseMap(platformType);
        map["sent_email_verification"] = self.reverseMap(sentEmailVerification);
        map["sent_mobile_verification"] = self.reverseMap(sentMobileVerification);
        map["type"] = self.reverseMap(type);
        map["entity_id"] = self.reverseMap(entityId);
        map["verification_token"] = self.reverseMap(verificationToken);
        map["raw_image"] = self.reverseMap(rawImage);
        
        map["user_name"] = self.reverseMap(userName);
        map["first_name"] = self.reverseMap(firstName);
        map["last_name"] = self.reverseMap(lastName);
        map["image"] = self.reverseMap(image);
        
        map["thumb"] = self.reverseMap(thumb);
        
        return map;
    }
} //CLS END
