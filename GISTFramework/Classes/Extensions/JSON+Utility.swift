//
//  JSON+Utility.swift
//  GISTFramwork
//
//  Created by Shoaib Abdul on 16/10/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

// MARK: - Dictionary extension (ExpressibleByStringLiteral) for JSON serialization.
public extension Dictionary where Key: ExpressibleByStringLiteral {
    
    //MARK: - Methods
    
    ///Returns JSON String
    func toJSONString() -> String? {
        return self.toJSONData()?.toString();
    } //F.E.
    
    ///Returns JSON Data
    func toJSONData() -> Data? {
        return try? JSONSerialization.data(withJSONObject: self, options: []);
    } //F.E.
    
} //E.E.

// MARK: - Array extension for JSON serialization.
public extension Array {
    
    //MARK: - Methods
    
    ///Returns JSON String
    func toJSONString() -> String? {
        return self.toJSONData()?.toString();
    } //F.E.
    
    ///Returns JSON Data
    func toJSONData() -> Data? {
        return try? JSONSerialization.data(withJSONObject: self, options: []);
    } //F.E.

} //E.E.

// MARK: - String extension for JSON serialization.
public extension String {
    
    //MARK: - Methods
    
    ///Returns Object from JSON String
    func toJSONObject() -> Any? {
        return self.toDataUTF8String()?.toJSONObject();
    } //F.E.
    
    ///Returns Data from String
    func toDataUTF8String() -> Data? {
        return self.data(using: String.Encoding.utf8);
    }
} //E.E.

// MARK: - Data extension for JSON serialization.
public extension Data {
    
    //MARK: - Methods
    
    ///Returns String from Data
    func toString() -> String? {
        return String(data: self, encoding: String.Encoding.utf8);
    } //F.E.
    
    ///Returns JSON Object from Data
    func toJSONObject() -> Any? {
        do {
            return try JSONSerialization.jsonObject(with: self, options: JSONSerialization.ReadingOptions.mutableContainers);
        } catch let error as NSError {
            print(error)
        }
        
        return nil
    } //F.E.
    
} //E.E.
