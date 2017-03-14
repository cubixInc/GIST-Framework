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
