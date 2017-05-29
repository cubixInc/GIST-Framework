//
//  GISTUtility.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 07/09/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit

/// Extension for Utility
public extension GISTUtility {
    
    public class func validate(fields:[ValidatedTextField]) -> Bool {
        var isValid:Bool = true;
        
        for field in fields {
            if (field.isValid == false && isValid == true) {
                isValid = false; // The reason on not breaking loop here is that each field should call its isValid propert to update view
            }
        }
        
        return isValid;
        
    } //F.E.
    
    public class func validate(array:NSMutableArray) -> Bool {
        var isValid:Bool = true;
        
        for i in 0 ..< array.count {
            let dict:NSMutableDictionary? = array[i] as? NSMutableDictionary;
            
            let isFieldValid:Bool;
            
            if let dataArr:NSMutableArray = dict?["data"] as? NSMutableArray {
                isFieldValid = self.validate(array: dataArr);
            } else {
                dict?["validated"] = true;
                isFieldValid = dict?["isValid"] as? Bool ?? false;
            }
            
            if (isFieldValid == false && isValid == true) {
                isValid = false; // The reason on not breaking loop here is that each field should call its isValid propert to update view
            }
        }
        
        return isValid;
        
    } //F.E.
    
    public class func formate(fields:[ValidatedTextField], additional params:[String:Any]? = nil) -> [String:Any] {
        var rParams:[String:Any] = [:];
        
        for field in fields {
            if let pKey:String = field.paramKey, let text:String = field.validText {
                rParams[pKey] = text;
            }
        }

        if let aParams:[String:Any] = params {
            for (pKey, pValue) in aParams {
                rParams[pKey] = pValue;
            }
        }
        
        return rParams;
    } //F.E.
    
    public class func formate(array:NSMutableArray, additional params:[String:Any]?) -> [String:Any] {
        var rParams:[String:Any] = [:];
        
        for i in 0 ..< array.count {
            let dict:NSMutableDictionary? = array[i] as? NSMutableDictionary;
            
            if let dataArr:NSMutableArray = dict?["data"] as? NSMutableArray {
                
                for j in 0 ..< dataArr.count {
                    let sDict:NSMutableDictionary? = dataArr[j] as? NSMutableDictionary;
                    
                    if let pKey:String = sDict?["paramKey"] as? String, let text:String = sDict?["validText"] as? String {
                        rParams[pKey] = text;
                    }
                }
                
                
            } else if let pKey:String = dict?["paramKey"] as? String, let text:String = dict?["validText"] as? String {
                rParams[pKey] = text;
            }
        }
        
        if let aParams:[String:Any] = params {
            for (pKey, pValue) in aParams {
                rParams[pKey] = pValue;
            }
        }
        
        return rParams;
    } //F.E.
    
    public class func formate(user:GISTUser, additional params:[String:Any]?) -> [String:Any] {
        var rParams:[String:Any] = user.toDictionary() as? [String:Any] ?? [:];
        
        if let aParams:[String:Any] = params {
            for (pKey, pValue) in aParams {
                rParams[pKey] = pValue;
            }
        }
        
        return rParams;
    } //F.E.

} //CLS END
