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
            if #available(iOS 10.0, *) {
                return UIKeyboardType.asciiCapableNumberPad
            } else {
                return UIKeyboardType.default
            }
            
        default:
            return UIKeyboardType.default;
        }
    }
}

public extension UIKeyboardAppearance {
    public static func keyboardAppearance(for type:String) -> UIKeyboardAppearance {
        switch type {
        case "dark":
                return UIKeyboardAppearance.dark;
            
        case "light":
                return UIKeyboardAppearance.light;
            
        default:
                return UIKeyboardAppearance.default;
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
    } //F.E.
} //E.E.

public extension UITextAutocapitalizationType {
    public static func textAutocapitalizationType (for type:String) -> UITextAutocapitalizationType {
        
        switch type {
        case "none":
            return UITextAutocapitalizationType.none;
        
        case "words":
            return UITextAutocapitalizationType.words;
            
        case "sentences":
            return UITextAutocapitalizationType.sentences;
            
        case "allCharacters":
            return UITextAutocapitalizationType.allCharacters;
            
        default:
            return UITextAutocapitalizationType.none;
        }
    } //F.E.
} //E.E.

public extension UITextAutocorrectionType {
    public static func textAutocorrectionType (for type:String) -> UITextAutocorrectionType {
        switch type {
        case "no":
            return UITextAutocorrectionType.no;
            
        case "yes":
            return UITextAutocorrectionType.yes;
            
        default:
            return UITextAutocorrectionType.default;
        }
    } //F.E.
} //E.E.
