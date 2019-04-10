//
//  String+Utility.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 09/03/2017.
//  Copyright © 2017 Social Cubix. All rights reserved.
//


public extension String {
    public func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        
        return String(data: data, encoding: .utf8)
    } //F.E
    
    public func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    } //F.E.
    
    public var hasOnlyNewlineSymbols: Bool {
        return trimmingCharacters(in: CharacterSet.newlines).isEmpty
    }
    
    public var encodeUTF8: String {
        guard let cString = self.cString(using: .nonLossyASCII) else {
            return self;
        }
        
        return String(cString: cString, encoding: .utf8) ?? self;
    }
    
    public var decodeUTF8: String {
        guard let data = self.data(using: .utf8, allowLossyConversion: false) else {
            return self;
        }
        
        return String(data: data, encoding: .utf8) ?? self
    }
} //E.E.
