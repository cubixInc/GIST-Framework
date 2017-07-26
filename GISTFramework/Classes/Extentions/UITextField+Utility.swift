//
//  UITextField+Utility.swift
//  GISTFramwork
//
//  Created by Shoaib Abdul on 14/03/2017.
//  Copyright © 2017 Social Cubix. All rights reserved.
//

import UIKit

extension UITextField {

    /// Moves the caret to the correct position by removing the trailing whitespace
    func fixCaretPosition() {
        // Moving the caret to the correct position by removing the trailing whitespace
        // http://stackoverflow.com/questions/14220187/uitextfield-has-trailing-whitespace-after-securetextentry-toggle
        
        let beginning = self.beginningOfDocument
        self.selectedTextRange = self.textRange(from: beginning, to: beginning)
        let end = self.endOfDocument
        self.selectedTextRange = self.textRange(from: end, to: end)
    }

}


public extension UIKeyboardType {
    
    public static func keyboardType(for type:String) -> UIKeyboardType {
        switch type {
            
        case "default":
            return UIKeyboardType.default;
            
        case "asciiCapable":
            return UIKeyboardType.asciiCapable;
            
        case "URL":
            return UIKeyboardType.URL;
            
        case "numberPad":
            return UIKeyboardType.numberPad;
            
        case "phonePad":
            return UIKeyboardType.phonePad;
            
        case "namePhonePad":
            return UIKeyboardType.namePhonePad;
            
        case "emailAddress":
            return UIKeyboardType.emailAddress;
            
        case "decimalPad":
            return UIKeyboardType.decimalPad;
            
        case "twitter":
            return UIKeyboardType.twitter;
            
        case "webSearch":
            return UIKeyboardType.webSearch;
            
        case "asciiCapableNumberPad":
            return UIKeyboardType.asciiCapableNumberPad;
            
        default:
            return UIKeyboardType.default;
        }
    }
}

public extension UIReturnKeyType {
    
    public static func returnKeyType(for type:String) -> UIReturnKeyType {
        switch type {
            
        case "default":
            return UIReturnKeyType.default;
            
        case "go":
            return UIReturnKeyType.go;
            
        case "google":
            return UIReturnKeyType.google;
            
        case "join":
            return UIReturnKeyType.join;
            
        case "route":
            return UIReturnKeyType.route;
            
        case "search":
            return UIReturnKeyType.search;
            
        case "send":
            return UIReturnKeyType.send;
            
        case "done":
            return UIReturnKeyType.done;
            
        case "emergencyCall":
            return UIReturnKeyType.emergencyCall;
            
        case "continue":
            return UIReturnKeyType.continue;
            
        default:
            return UIReturnKeyType.default;
        }
    }
}
