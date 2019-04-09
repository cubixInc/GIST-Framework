//
//  BaseUIStepper.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 14/06/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit

/// BaseUIStepper is a subclass of UIStepper and implements BaseView. It has some extra proporties and support for SyncEngine.
open class BaseUIStepper: UIStepper, BaseView {
   
    //MARK: - Properties
    @IBInspectable open var tintColorStyle:String? = nil {
        didSet {
            self.tintColor = SyncedColors.color(forKey: tintColorStyle);
        }
    }
    
    //MARK: - Overridden Methods
    
    /// Overridden method to setup/ initialize components.
    override open func awakeFromNib() {
        super.awakeFromNib()
    } //F.E.
    
    //MARK: - Methods
    
    /// Updates layout and contents from SyncEngine. this is a protocol method BaseView that is called when the view is refreshed.
    func updateView(){
        if let tintCStyle = self.tintColorStyle {
            self.tintColorStyle = tintCStyle;
        }
    } //F.E.
    
} //CLS END
