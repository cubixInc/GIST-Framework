//
//  JSON+Utility.swift
//  GISTFramwork
//
//  Created by Shoaib Abdul on 16/10/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

public extension Dictionary where Key: ExpressibleByStringLiteral {
    //Returns JSON String
    public func toJSONString() -> String? {
        return self.toJSONData()?.toString();
    } //F.E.
    
    //Returns JSON Data
    public func toJSONData() -> Data? {
        return try? JSONSerialization.data(withJSONObject: self as AnyObject, options: []);
    } //F.E.
    
} //E.E.

public extension Array {
    //Returns JSON String
    public func toJSONString() -> String? {
        return self.toJSONData()?.toString();
    } //F.E.
    
    //Returns JSON Data
    public func toJSONData() -> Data? {
        return try? JSONSerialization.data(withJSONObject: self as AnyObject, options: []);
    } //F.E.

} //E.E.

public extension String {
    //Returns Object from JSON String
    public func toJSONObject() -> Any? {
        return self.toDataUTF8String()?.toJSONObject();
    } //F.E.
    
    public func toDataUTF8String() -> Data? {
        return self.data(using: String.Encoding.utf8);
    }

} //E.E.

public extension Data {
    
    //Returns String from UTF8
    public func toString() -> String? {
        return String(data: self, encoding: String.Encoding.utf8);
    } //F.E.
    
    public func toJSONObject() -> Any? {
        do {
            return try JSONSerialization.jsonObject(with: self, options: JSONSerialization.ReadingOptions.mutableContainers);
        } catch let error as NSError {
            print(error)
        }
        
        return nil
    } //F.E.
    
} //E.E.
