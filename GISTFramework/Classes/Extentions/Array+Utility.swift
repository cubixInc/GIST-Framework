//
//  Array+Utility.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 25/07/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

// MARK: - Array Extnsion for Equatable
public extension Array where Element: Equatable {
    
    /// Removes object from the array with validation of availablity
    ///
    /// - Parameter object: Element to delete
    public mutating func removeObject(_ object: Element) {
        if let index = self.index(of: object) {
            self.remove(at: index)
        }
    } //F.E.
    
    /// Removes array elemets form the array
    ///
    /// - Parameter array: Elements of array to delete
    public mutating func removeObjectsInArray(_ array: [Element]) {
        for object in array {
            self.removeObject(object)
        }
    } //F.E.
} //E.E.
