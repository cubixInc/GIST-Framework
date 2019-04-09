//
//  ManagedParser.swift
//  Created by Shoaib on 7/29/15.
//

import UIKit
import CoreData

public class ManagedParser: NSObject {
    
    public class func convertToArray(_ managedObjects:NSArray?, parentNode:String? = nil) -> NSArray {
        
        let rtnArr:NSMutableArray = NSMutableArray();
        //--
        if let managedObjs:[NSManagedObject] = managedObjects as? [NSManagedObject] {
            for managedObject:NSManagedObject in managedObjs {
                rtnArr.add(self.convertToDictionary(managedObject, parentNode: parentNode));
            }
        }
        
        return rtnArr;
    } //F.E.
    
    public class func convertToDictionary(_ managedObject:NSManagedObject, parentNode:String? = nil) -> NSDictionary {
        
        let rtnDict:NSMutableDictionary = NSMutableDictionary();
        //-
        let entity:NSEntityDescription = managedObject.entity;
        let properties:[String] = (entity.propertiesByName as NSDictionary).allKeys as! [String];
        //--
        let parentNode:String = parentNode ?? managedObject.entity.name!;
        for property:String in properties  {
            if (property.caseInsensitiveCompare(parentNode) != ComparisonResult.orderedSame)
            {
                let value: AnyObject? = managedObject.value(forKey: property) as AnyObject?;
                //--
                if let set:NSSet = value as? NSSet  {
                    rtnDict[property] = self.convertToArray(set.allObjects as NSArray?, parentNode: parentNode);
                } else if let vManagedObject:NSManagedObject = value as? NSManagedObject {
                    
                    if (vManagedObject.entity.name != parentNode) {
                        rtnDict[property] = self.convertToDictionary(vManagedObject, parentNode: parentNode);
                    }
                } else  if let vData:AnyObject = value {
                    rtnDict[property] = vData;
                }
            }
        }
        
        return rtnDict;
    } //F.E.
    
    
} //CLS END
