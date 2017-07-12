//
//  ValidatedAnimatedTextInput.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 12/07/2017.
//  Copyright © 2017 Social Cubix. All rights reserved.
//

import UIKit

open class ValidatedAnimatedTextInput: AnimatedTextInput, ValidatedTextInput {

    open override var text: String? {
        get {
            return super.text;
        }
        set {
            super.text = newValue;
            
            if (!self.isFirstResponder) {
                
                self.validateText();
            }
        }
    } //P.E.
    
    open var validText: String?;
    
    /// Flag for whether the input is valid or not.
    open var isValid:Bool {
        get {
            if (self.isFirstResponder) {
                self.validateText();
            }
            
            return true; // INCOMPLETE
        }
    } //F.E.
    
    /// Validating in input and updating the flags of isValid and isEmpty.  --- Incomplete implementation
    private func validateText() {
        
        self.validText = self.text
        
        if let dicData:NSMutableDictionary = self.data as? NSMutableDictionary {
            dicData["isValid"] = true;
            dicData["validText"] = self.validText;
        }
        
    } //F.E.
    
    /// Overridden property to get text changes.
    open override func textInputDidEndEditing(textInput: TextInput) {
        super.textInputDidEndEditing(textInput: textInput);
        
        //Updating text in the holding dictionary
        let dicData:NSMutableDictionary? = data as? NSMutableDictionary;
        dicData?["text"] = textInput.currentText;
        
        //Validating the input
        self.validateText();
    }

} //CLS END
