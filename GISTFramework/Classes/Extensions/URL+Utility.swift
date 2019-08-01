//
//  URL+Utility.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 22/05/2017.
//  Copyright © 2017 Social Cubix. All rights reserved.
//

import UIKit

public extension URL {
    var params: Dictionary<String, String> {
        get {
            var results = [String:String]()
            if let keyValues:[String] = self.query?.components(separatedBy: "&") {
                for pair in keyValues {
                    let kv:[String] = pair.components(separatedBy: "=")
                    if kv.count > 1 {
                        results.updateValue(kv[1], forKey: kv[0])
                    }
                }
            }
            
            return results
        }
    } //P.E.
} //E.E.
