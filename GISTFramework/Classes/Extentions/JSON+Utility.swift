//
//  JSON+Utility.swift
//  GISTFramwork
//
//  Created by Shoaib Abdul on 16/10/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

public extension Dictionary where Key: StringLiteralConvertible {
    //Returns JSON String
    public func toJSONString() -> String? {
        return self.toJSONData()?.toString();
    } //F.E.
    
    //Returns JSON Data
    public func toJSONData() -> NSData? {
        return try? NSJSONSerialization.dataWithJSONObject(self as! AnyObject, options: []);
    } //F.E.
    
} //E.E.

public extension Array {
    //Returns JSON String
    public func toJSONString() -> String? {
        return self.toJSONData()?.toString();
    } //F.E.
    
    //Returns JSON Data
    public func toJSONData() -> NSData? {
        return try? NSJSONSerialization.dataWithJSONObject(self as! AnyObject, options: []);
    } //F.E.

} //E.E.

public extension String {
    //Returns Object from JSON String
    public func toJSONObject() -> AnyObject? {
        return self.toDataUTF8String()?.toJSONObject();
    } //F.E.
    
    public func toDataUTF8String() -> NSData? {
        return self.dataUsingEncoding(NSUTF8StringEncoding);
    }

} //E.E.

public extension NSData {
    
    //Returns String from UTF8
    public func toString() -> String? {
        return String(data: self, encoding: NSUTF8StringEncoding);
    } //F.E.
    
    public func toJSONObject() -> AnyObject? {
        do {
            return try NSJSONSerialization.JSONObjectWithData(self, options: NSJSONReadingOptions.MutableContainers);
        } catch let error as NSError {
            print(error)
        }
        
        return nil
    } //F.E.
    
} //E.E.
