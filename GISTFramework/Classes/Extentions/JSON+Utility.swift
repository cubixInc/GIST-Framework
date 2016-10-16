//
//  JSON+Utility.swift
//  GISTFramwork
//
//  Created by Shoaib Abdul on 16/10/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

public extension Dictionary where Key: StringLiteralConvertible {
    //Returns Json String
    public func toJSONString() -> String? {
        if let jsonData = try? NSJSONSerialization.dataWithJSONObject(self as! AnyObject, options: []) {
            return String(data: jsonData, encoding: NSUTF8StringEncoding);
        }
        
        return nil;
    } //F.E.
} //E.E.

public extension Array {
    //Returns JSON String
    public func toJSONString() -> String? {
        if let jsonData = try? NSJSONSerialization.dataWithJSONObject(self as! AnyObject, options: []) {
            return String(data: jsonData, encoding: NSUTF8StringEncoding);
        }
        
        return nil;
    } //F.E.
} //E.E.


public extension String {
    //Returns Object from JSON String
    public func toJSONObject() -> AnyObject? {
        if let jsonData = self.dataUsingEncoding(NSUTF8StringEncoding) {
            do {
                return try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers);
            } catch let error as NSError {
                print(error)
            }
        }
        
        return nil
    } //F.E.
} //E.E.

