//
//  VerticalTopAlignLabel.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 03/03/2017.
//  Copyright © 2017 Social Cubix. All rights reserved.
//

import UIKit


/// VerticalTopAlignLabel is a subclass of BaseUILabel. It draws top aligned text.
class VerticalTopAlignLabel: BaseUILabel {
    
    override func drawText(in rect:CGRect) {
        guard let labelText = text else {  return super.drawText(in: rect) }
        
        let attributedText = NSAttributedString(string: labelText, attributes: [NSFontAttributeName: font])
        var newRect = rect
        newRect.size.height = attributedText.boundingRect(with: rect.size, options: .usesLineFragmentOrigin, context: nil).size.height
        
        if numberOfLines != 0 {
            newRect.size.height = min(newRect.size.height, CGFloat(numberOfLines) * font.lineHeight)
        }
        
        super.drawText(in: newRect)
    } //F.E.
    
} //CLS END
