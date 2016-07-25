//
//  Array+Utility.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 25/07/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

public extension Array where Element: Equatable {
    public mutating func removeObject(object: Element) {
        if let index = self.indexOf(object) {
            self.removeAtIndex(index)
        }
    } //F.E.
    
    public mutating func removeObjectsInArray(array: [Element]) {
        for object in array {
            self.removeObject(object)
        }
    } //F.E.
} //E.E.