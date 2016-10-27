//
//  Array+Utility.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 25/07/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

public extension Array where Element: Equatable {
    public mutating func removeObject(_ object: Element) {
        if let index = self.index(of: object) {
            self.remove(at: index)
        }
    } //F.E.
    
    public mutating func removeObjectsInArray(_ array: [Element]) {
        for object in array {
            self.removeObject(object)
        }
    } //F.E.
} //E.E.
