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
    
    public class func validate(fields:ValidatedTextField ...) -> Bool {
        return self.validate(fields: fields);
    } //F.E.
    
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
            
            dict?["validated"] = true;
            
            let isFieldValid:Bool = dict?["isValid"] as? Bool ?? false;
            
            if (isFieldValid == false && isValid == true) {
                isValid = false; // The reason on not breaking loop here is that each field should call its isValid propert to update view
            }
        }
        
        return isValid;
        
    } //F.E.
    
    public class func formate(fields:BaseUITextField ...) -> [String:String] {
        return self.formate(fields: fields);
    } //F.E.
    
    public class func formate(fields:[BaseUITextField]) -> [String:String] {
        var params:[String:String] = [:];
        
        for field in fields {
            if let paramKey:String = field.paramKey, let text:String = field.text {
                params[paramKey] = text;
            }
        }
        
        return params;
    } //F.E.
    
    public class func formate(array:NSMutableArray) -> [String:String] {
        var params:[String:String] = [:];
        
        for i in 0 ..< array.count {
            let dict:NSMutableDictionary? = array[i] as? NSMutableDictionary;
            
            if let paramKey:String = dict?["paramKey"] as? String, let text:String = dict?["text"] as? String {
                params[paramKey] = text;
            }
        }
        
        return params;
    } //F.E.

} //CLS END
