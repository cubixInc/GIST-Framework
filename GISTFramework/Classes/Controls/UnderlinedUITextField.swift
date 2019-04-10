//
//  UnderlinedUITextField.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 13/02/2017.
//  Copyright © 2017 Social Cubix. All rights reserved.
//

import UIKit

/// UnderlinedUITextField is a subclass of BaseUITextField. It has adds an extra line in the text field
open class UnderlinedUITextField: BaseUITextField {

    //MARK: - Properties
    
    /// Flag for showing Underline - Defalut is true
    @IBInspectable open var hasUnderline:Bool {
        get {
            return !self.underlineView.isHidden;
        }
        
        set {
            self.underlineView.isHidden = !newValue;
        }
    } //P.E.
    
    /// Flag for showing onderline on the top. - Default Value is false
    @IBInspectable open var underlineOnTop:Bool = false {
        didSet {
            self.underlineView.frame = self.underlineFrame;
        }
    } //P.E.
    
    /// Underline Color key from SyncEngine.
    @IBInspectable open var underlineColorStyle:String? = nil {
        didSet {
            guard (self.underlineColorStyle != oldValue) else {
                return;
            }
             
            self.underlineView.backgroundColor = SyncedColors.color(forKey: underlineColorStyle);
        }
    } //P.E.
    
    // Calculated underline frame Rect - Overridable
    open var underlineFrame:CGRect {
        get  {
            return CGRect(x: 0, y: (self.underlineOnTop ? 0:self.frame.size.height - 0.5), width: self.frame.size.width, height: 0.5);
        }
    } //P.E.
    
    //Lazy instance for underline View.
    open lazy var underlineView:UIView = {
        let uView = UIView(frame: self.underlineFrame);
        uView.backgroundColor = UIColor.lightGray;
        self.addSubview(uView);
        return uView;
    }()
    
    //MARK: - Overridden Methods
    
    /// Overridden methed to update layout.
    override open func layoutSubviews() {
        super.layoutSubviews();
        
        self.underlineView.frame = self.underlineFrame;
    } //F.E.
    
    
} //CLS END
