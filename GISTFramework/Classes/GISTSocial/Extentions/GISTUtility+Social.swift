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
    
    public class func validate(array:NSMutableArray, ignore iParams:[String]? = nil) -> Bool {
        var isValid:Bool = true;
        
        let ignoreParams:[String] = iParams ?? [];
        
        for i in 0 ..< array.count {
            if let dict:NSMutableDictionary = array[i] as? NSMutableDictionary {
                let isFieldValid:Bool;
                
                if let dataArr:NSMutableArray = dict["data"] as? NSMutableArray {
                    isFieldValid = self.validate(array: dataArr, ignore: iParams);
                } else if let pKey:String = dict["paramKey"] as? String, ignoreParams.contains(pKey) == false {
                    dict["validated"] = true;
                    isFieldValid = dict["isValid"] as? Bool ?? false;
                } else {
                    isFieldValid = true;
                }
                
                if (isFieldValid == false && isValid == true) {
                    isValid = false; // The reason for not breaking loop here is that each field should call its isValid propert to update view
                }
            }
        }
        
        return isValid;
        
    } //F.E.
    
    public class func formate(fields:[ValidatedTextField], additional aParams:[String:Any]? = nil, ignore iParams:[String]? = nil) -> [String:Any] {
        var rParams:[String:Any] = [:];
        
        for field in fields {
            if let pKey:String = field.paramKey, let text:String = field.validText {
                rParams[pKey] = text;
            }
        }

        //Additional Params
        if let params:[String:Any] = aParams {
            for (pKey, pValue) in params {
                rParams[pKey] = pValue;
            }
        }
        
        //Ingnore Params
        if let params:[String] = iParams {
            for pKey in params {
                rParams.removeValue(forKey: pKey);
            }
        }
        
        return rParams;
    } //F.E.
    
    public class func formate(array:NSMutableArray, additional aParams:[String:Any]? = nil, ignore iParams:[String]? = nil) -> [String:Any] {
        var rParams:[String:Any] = [:];
        
        for i in 0 ..< array.count {
            if let dict:NSMutableDictionary = array[i] as? NSMutableDictionary {
                if let dataArr:NSMutableArray = dict["data"] as? NSMutableArray {
                    
                    for j in 0 ..< dataArr.count {
                        if let sDict:NSMutableDictionary = dataArr[j] as? NSMutableDictionary {
                            if let pKey:String = sDict["paramKey"] as? String {
                                if let text:String = sDict["rawText"] as? String {
                                    rParams[pKey] = text;
                                } else if let text:String = sDict["validText"] as? String {
                                    rParams[pKey] = text;
                                }
                            }
                        }
                    }
                    
                    
                } else if let pKey:String = dict["paramKey"] as? String {
                    if let text:String = dict["rawText"] as? String {
                        rParams[pKey] = text;
                    } else if let text:String = dict["validText"] as? String {
                        rParams[pKey] = text;
                    }
                }
            }
        }
        
        //Additional Params
        if let params:[String:Any] = aParams {
            for (pKey, pValue) in params {
                rParams[pKey] = pValue;
            }
        }
        
        //Ingnore Params
        if let params:[String] = iParams {
            for pKey in params {
                rParams.removeValue(forKey: pKey);
            }
        }
        
        return rParams;
    } //F.E.
    
    public class func formate(user:GISTUser, additional aParams:[String:Any]? = nil, ignore iParams:[String]? = nil) -> [String:Any] {
        var rParams:[String:Any] = user.toDictionary() as? [String:Any] ?? [:];
        
        //Additional Params
        if let params:[String:Any] = aParams {
            for (pKey, pValue) in params {
                rParams[pKey] = pValue;
            }
        }
        
        //Ingnore Params
        if let params:[String] = iParams {
            for pKey in params {
                rParams.removeValue(forKey: pKey);
            }
        }
        
        return rParams;
    } //F.E.
    
    
    public class func mapData(to array:NSMutableArray, from data:NSDictionary, forkey key:String){
        for i in 0 ..< array.count {
            if let dict:NSMutableDictionary = array[i] as? NSMutableDictionary {
                if let paramKey:String = dict["paramKey"] as? String, let value:Any = data[paramKey] {
                    dict[key] = value;
                }
                
                if let dataArr:NSMutableArray = dict["data"] as? NSMutableArray {
                    self.mapData(to: dataArr, from: data, forkey: key);
                }
            }
        }
    } //F.E.
    
    public class func getData(from array:NSMutableArray, forkey key:String) -> NSMutableDictionary? {
        for i in 0 ..< array.count {
            if let dict:NSMutableDictionary = array[i] as? NSMutableDictionary {
                if let paramKey:String = dict["paramKey"] as? String, paramKey == key {
                    return dict;
                }
            }
        }
        
        return nil;
    } //F.E.

} //CLS END
