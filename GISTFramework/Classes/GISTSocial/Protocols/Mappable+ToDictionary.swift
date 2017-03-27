//
//  Mappable+ToDictionary.swift
//  FoodParcel
//
//  Created by Shoaib Abdul on 14/10/2016.
//  Copyright © 2016 Cubixlabs. All rights reserved.
//

import Foundation
import ObjectMapper

public protocol ReverseMappable {
    func toDictionary () -> NSDictionary?;
}

public extension ReverseMappable {
    func reverseMap (_ obj:Any?) -> Any? {
        guard (obj != nil) else {
            return nil;
        }
        
        if let mappableObj:ReverseMappable = obj as? ReverseMappable {
            return mappableObj.toDictionary();
        }
        
        if let arrMappableObj:[Any] = obj as? [Any] {
            return self.reverseMapArray(arrMappableObj);
        }
        
        return obj;
    } //F.E.
    
    func reverseMapArray(_ arrMappableObj:[Any]) -> NSArray {
        let rtnArr:NSMutableArray = NSMutableArray();
        
        for obj in arrMappableObj {
            if let mappable = obj as? ReverseMappable {
                if let dict = mappable.toDictionary() {
                    rtnArr.add(dict);
                }
            }
            
        }
        
        return rtnArr;
    }
}
