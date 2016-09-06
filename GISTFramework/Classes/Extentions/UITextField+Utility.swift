//
//  UITextField+Utility.swift
//  Tst1
//
//  Created by Shoaib Abdul on 06/09/2016.
//  Copyright © 2016 Cubix Labs. All rights reserved.
//

import UIKit

public extension UITextField {
    
    public func isEmpty()->Bool {
        guard (self.text != nil) else {
            return true;
        }
        
        return (self.text! == "");
    } //F.E.
    
    public func isValidEmail()->Bool {
        guard (self.text != nil) else {
            return false;
        }
        
        let emailRegex:String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let predicate:NSPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        
        return predicate.evaluateWithObject(self.text!);
    } //F.E.
    
    public func isValidUrl() -> Bool {
        guard (self.text != nil) else {
            return false;
        }
        
        let regexURL: String = "(http://|https://)?((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+"
        let predicate:NSPredicate = NSPredicate(format: "SELF MATCHES %@", regexURL)
        return predicate.evaluateWithObject(self.text)
    } //F.E.
    
    public func isNumeric() -> Bool {
        guard (self.text != nil) else {
            return false;
        }
        
        return Double(self.text!) != nil;
    } //F.E.
    
    public func isAlphabetic() -> Bool {
        guard (self.text != nil) else {
            return false;
        }
        
        for chr in self.text!.characters {
            if (!(chr >= "a" && chr <= "z") && !(chr >= "A" && chr <= "Z") ) {
                return false
            }
        }
        return true;
    } //F.E.
    
    public func isValidForRegex(regex:String)->Bool {
        guard (self.text != nil) else {
            return false;
        }
        
        let predicate:NSPredicate = NSPredicate(format: "SELF MATCHES %@", regex)
        
        return predicate.evaluateWithObject(self.text!);
    } //F.E.
    
} //E.E.
