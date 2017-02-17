//
//  BaseUISwitch.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 14/06/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit

/// BaseUISwitch is a subclass of UISwitch and implements BaseView. It has some extra proporties and support for SyncEngine.
open class BaseUISwitch: UISwitch, BaseView {
    
    //MARK: - Properties
    @IBInspectable open var onColorStyle:String? = nil {
        didSet {
            self.onTintColor = SyncedColors.color(forKey: onColorStyle);
        }
    }

    @IBInspectable open var thumbColorStyle:String? = nil {
        didSet {
            self.thumbTintColor = SyncedColors.color(forKey: thumbColorStyle);
        }
    }
    
    //MARK: - Overridden Methods
    
    /// Overridden method to setup/ initialize components.
    override open func awakeFromNib() {
        super.awakeFromNib()
         
        self.updateView()
    } //F.E.
    
    //MARK: - Methods
    
    /// Updates layout and contents from SyncEngine. this is a protocol method BaseView that is called when the view is refreshed.
    func updateView(){
        if let onCStyle = self.onColorStyle {
            self.onColorStyle = onCStyle;
        }
        
        if let thumbCStyle = self.thumbColorStyle {
            self.thumbColorStyle = thumbCStyle;
        }
    } //F.E.
} //CLS END
