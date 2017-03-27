//
//  User.swift
//  Copyright © Cubix Labs. All rights reserved.
//

import Foundation
import ObjectMapper

/*
{
    kick_user: 0,
    data: {
        user: {
            user_id: 19,
            name: "test test02",
            first_name: "test",
            last_name: "test02",
            user_name: null,
            email: "test02@abc.com",
            dob: "1986-12-12",
            gender: "male",
            image: "",
            thumb: "",
            status: 1,
            platform_type: "custom",
            device_udid: "12",
            device_type: "ios",
            mobile_no: "",
            city_id: null,
            country_id: 1,
            state_id: 1,
            zip_code: "1234",
            device_token: "",
            is_verified: 0,
            is_mobile_verified: 0,
            is_guest: 0,
            additional_note: null,
            other_data: null,
            remember_login_token_created_at: null,
            forgot_password_token_created_at: null,
            last_login_at: null,
            last_seen_at: null,
            created_at: "2017-03-21 01:51:07",
            updated_at: null,
            location: "Victoria, Afghanistan"
        }
    },
    message: "Please check your email for confirmation",
    error: 0
}
*/

open class User: NSObject, Mappable, ReverseMappable, NSCopying {
	public var additionalNote: String?;
	public var cityId: NSNumber?;
	public var countryId: NSNumber?;
	public var createdAt: String?;
	public var deviceToken: String?;
	public var deviceType: String?;
	public var deviceUdid: String?;
	public var dob: String?;
	public var email: String?;
	public var firstName: String?;
	public var forgotPasswordTokenCreatedAt: String?;
	public var gender: String?;
	public var image: String?;
	public var isGuest: NSNumber?;
	public var isMobileVerified: NSNumber?;
	public var isVerified: NSNumber?;
	public var lastLoginAt: String?;
	public var lastName: String?;
	public var lastSeenAt: String?;
	public var mobileNo: String?;
	public var name: String?;
	public var otherData: String?;
	public var platformType: String?;
	public var rememberLoginTokenCreatedAt: String?;
	public var stateId: NSNumber?;
	public var status: NSNumber?;
	public var thumb: String?;
	public var updatedAt: String?;
	public var userId: NSNumber?;
	public var userName: String?;
	public var zipCode: String?;
    
    public var socialId: String?;
    
    required public init?(map: Map) {
	}

	override public init() {
		super.init();
	}

	public func mapping(map: Map) {
		additionalNote <- map["additional_note"];
		cityId <- map["city_id"];
		countryId <- map["country_id"];
		createdAt <- map["created_at"];
		deviceToken <- map["device_token"];
		deviceType <- map["device_type"];
		deviceUdid <- map["device_udid"];
		dob <- map["dob"];
		email <- map["email"];
		firstName <- map["first_name"];
		forgotPasswordTokenCreatedAt <- map["forgot_password_token_created_at"];
		gender <- map["gender"];
		image <- map["image"];
		isGuest <- map["is_guest"];
		isMobileVerified <- map["is_mobile_verified"];
		isVerified <- map["is_verified"];
		lastLoginAt <- map["last_login_at"];
		lastName <- map["last_name"];
		lastSeenAt <- map["last_seen_at"];
		mobileNo <- map["mobile_no"];
		name <- map["name"];
		otherData <- map["other_data"];
		platformType <- map["platform_type"];
		rememberLoginTokenCreatedAt <- map["remember_login_token_created_at"];
		stateId <- map["state_id"];
		status <- map["status"];
		thumb <- map["thumb"];
		updatedAt <- map["updated_at"];
		userId <- map["user_id"];
		userName <- map["user_name"];
		zipCode <- map["zip_code"];
	}

	required public init(coder aDecoder: NSCoder) {
		additionalNote = aDecoder.decodeObject(forKey: "additional_note") as? String;
		cityId = aDecoder.decodeObject(forKey: "city_id") as? NSNumber;
		countryId = aDecoder.decodeObject(forKey: "country_id") as? NSNumber;
		createdAt = aDecoder.decodeObject(forKey: "created_at") as? String;
		deviceToken = aDecoder.decodeObject(forKey: "device_token") as? String;
		deviceType = aDecoder.decodeObject(forKey: "device_type") as? String;
		deviceUdid = aDecoder.decodeObject(forKey: "device_udid") as? String;
		dob = aDecoder.decodeObject(forKey: "dob") as? String;
		email = aDecoder.decodeObject(forKey: "email") as? String;
		firstName = aDecoder.decodeObject(forKey: "first_name") as? String;
		forgotPasswordTokenCreatedAt = aDecoder.decodeObject(forKey: "forgot_password_token_created_at") as? String;
		gender = aDecoder.decodeObject(forKey: "gender") as? String;
		image = aDecoder.decodeObject(forKey: "image") as? String;
		isGuest = aDecoder.decodeObject(forKey: "is_guest") as? NSNumber;
		isMobileVerified = aDecoder.decodeObject(forKey: "is_mobile_verified") as? NSNumber;
		isVerified = aDecoder.decodeObject(forKey: "is_verified") as? NSNumber;
		lastLoginAt = aDecoder.decodeObject(forKey: "last_login_at") as? String;
		lastName = aDecoder.decodeObject(forKey: "last_name") as? String;
		lastSeenAt = aDecoder.decodeObject(forKey: "last_seen_at") as? String;
		mobileNo = aDecoder.decodeObject(forKey: "mobile_no") as? String;
		name = aDecoder.decodeObject(forKey: "name") as? String;
		otherData = aDecoder.decodeObject(forKey: "other_data") as? String;
		platformType = aDecoder.decodeObject(forKey: "platform_type") as? String;
		rememberLoginTokenCreatedAt = aDecoder.decodeObject(forKey: "remember_login_token_created_at") as? String;
		stateId = aDecoder.decodeObject(forKey: "state_id") as? NSNumber;
		status = aDecoder.decodeObject(forKey: "status") as? NSNumber;
		thumb = aDecoder.decodeObject(forKey: "thumb") as? String;
		updatedAt = aDecoder.decodeObject(forKey: "updated_at") as? String;
		userId = aDecoder.decodeObject(forKey: "user_id") as? NSNumber;
		userName = aDecoder.decodeObject(forKey: "user_name") as? String;
		zipCode = aDecoder.decodeObject(forKey: "zip_code") as? String;
	}

	public func encodeWithCoder(_ aCoder: NSCoder) {
		aCoder.encode(additionalNote, forKey: "additional_note");
		aCoder.encode(cityId, forKey: "city_id");
		aCoder.encode(countryId, forKey: "country_id");
		aCoder.encode(createdAt, forKey: "created_at");
		aCoder.encode(deviceToken, forKey: "device_token");
		aCoder.encode(deviceType, forKey: "device_type");
		aCoder.encode(deviceUdid, forKey: "device_udid");
		aCoder.encode(dob, forKey: "dob");
		aCoder.encode(email, forKey: "email");
		aCoder.encode(firstName, forKey: "first_name");
		aCoder.encode(forgotPasswordTokenCreatedAt, forKey: "forgot_password_token_created_at");
		aCoder.encode(gender, forKey: "gender");
		aCoder.encode(image, forKey: "image");
		aCoder.encode(isGuest, forKey: "is_guest");
		aCoder.encode(isMobileVerified, forKey: "is_mobile_verified");
		aCoder.encode(isVerified, forKey: "is_verified");
		aCoder.encode(lastLoginAt, forKey: "last_login_at");
		aCoder.encode(lastName, forKey: "last_name");
		aCoder.encode(lastSeenAt, forKey: "last_seen_at");
		aCoder.encode(mobileNo, forKey: "mobile_no");
		aCoder.encode(name, forKey: "name");
		aCoder.encode(otherData, forKey: "other_data");
		aCoder.encode(platformType, forKey: "platform_type");
		aCoder.encode(rememberLoginTokenCreatedAt, forKey: "remember_login_token_created_at");
		aCoder.encode(stateId, forKey: "state_id");
		aCoder.encode(status, forKey: "status");
		aCoder.encode(thumb, forKey: "thumb");
		aCoder.encode(updatedAt, forKey: "updated_at");
		aCoder.encode(userId, forKey: "user_id");
		aCoder.encode(userName, forKey: "user_name");
		aCoder.encode(zipCode, forKey: "zip_code");
	}

	public func copy(with zone: NSZone? = nil) -> Any {
		return self.clone();
	}

	public func clone() -> User {
		let instance:User = User();

		instance.additionalNote = self.additionalNote;
		instance.cityId = self.cityId;
		instance.countryId = self.countryId;
		instance.createdAt = self.createdAt;
		instance.deviceToken = self.deviceToken;
		instance.deviceType = self.deviceType;
		instance.deviceUdid = self.deviceUdid;
		instance.dob = self.dob;
		instance.email = self.email;
		instance.firstName = self.firstName;
		instance.forgotPasswordTokenCreatedAt = self.forgotPasswordTokenCreatedAt;
		instance.gender = self.gender;
		instance.image = self.image;
		instance.isGuest = self.isGuest;
		instance.isMobileVerified = self.isMobileVerified;
		instance.isVerified = self.isVerified;
		instance.lastLoginAt = self.lastLoginAt;
		instance.lastName = self.lastName;
		instance.lastSeenAt = self.lastSeenAt;
		instance.mobileNo = self.mobileNo;
		instance.name = self.name;
		instance.otherData = self.otherData;
		instance.platformType = self.platformType;
		instance.rememberLoginTokenCreatedAt = self.rememberLoginTokenCreatedAt;
		instance.stateId = self.stateId;
		instance.status = self.status;
		instance.thumb = self.thumb;
		instance.updatedAt = self.updatedAt;
		instance.userId = self.userId;
		instance.userName = self.userName;
		instance.zipCode = self.zipCode;

		return instance;
	}

	public func toDictionary () -> NSDictionary? {
		let map:NSMutableDictionary = NSMutableDictionary();

		map["additional_note"] = self.reverseMap(additionalNote);
		map["city_id"] = self.reverseMap(cityId);
		map["country_id"] = self.reverseMap(countryId);
		map["created_at"] = self.reverseMap(createdAt);
		map["device_token"] = self.reverseMap(deviceToken);
		map["device_type"] = self.reverseMap(deviceType);
		map["device_udid"] = self.reverseMap(deviceUdid);
		map["dob"] = self.reverseMap(dob);
		map["email"] = self.reverseMap(email);
		map["first_name"] = self.reverseMap(firstName);
		map["forgot_password_token_created_at"] = self.reverseMap(forgotPasswordTokenCreatedAt);
		map["gender"] = self.reverseMap(gender);
		map["image"] = self.reverseMap(image);
		map["is_guest"] = self.reverseMap(isGuest);
		map["is_mobile_verified"] = self.reverseMap(isMobileVerified);
		map["is_verified"] = self.reverseMap(isVerified);
		map["last_login_at"] = self.reverseMap(lastLoginAt);
		map["last_name"] = self.reverseMap(lastName);
		map["last_seen_at"] = self.reverseMap(lastSeenAt);
		map["mobile_no"] = self.reverseMap(mobileNo);
		map["name"] = self.reverseMap(name);
		map["other_data"] = self.reverseMap(otherData);
		map["platform_type"] = self.reverseMap(platformType);
		map["remember_login_token_created_at"] = self.reverseMap(rememberLoginTokenCreatedAt);
		map["state_id"] = self.reverseMap(stateId);
		map["status"] = self.reverseMap(status);
		map["thumb"] = self.reverseMap(thumb);
		map["updated_at"] = self.reverseMap(updatedAt);
		map["user_id"] = self.reverseMap(userId);
		map["user_name"] = self.reverseMap(userName);
		map["zip_code"] = self.reverseMap(zipCode);

		return map;
	}
}
