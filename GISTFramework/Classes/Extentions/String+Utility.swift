//
//  String+Utility.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 09/03/2017.
//  Copyright © 2017 Social Cubix. All rights reserved.
//


extension String {
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        
        return String(data: data, encoding: .utf8)
    } //F.E
    
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    } //F.E.
    
} //E.E.
