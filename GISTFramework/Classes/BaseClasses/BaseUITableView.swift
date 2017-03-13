//
//  BaseTableView.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 14/06/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit

/// BaseUITableView is a subclass of UITableView and implements BaseView. It has some extra proporties and support for SyncEngine.
open class BaseUITableView: UITableView, BaseView {
    
    //MARK: - Properties
    
    /// Flag for whether to resize the values for iPad.
    @IBInspectable open var sizeForIPad:Bool = GIST_CONFIG.sizeForIPad;
    
    /// Background color key from Sync Engine.
    @IBInspectable open var bgColorStyle:String? = nil {
        didSet {
            self.backgroundColor = SyncedColors.color(forKey: bgColorStyle);
        }
    }
    
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
    
    /// Overridden methed to update layout.
    override open func layoutSubviews() {
        super.layoutSubviews();
    } //F.E.
    
    //MARK: - Methods
    
    /// Updates layout and contents from SyncEngine. this is a protocol method BaseView that is called when the view is refreshed.
    func updateView(){
        if let tintCStyle = tintColorStyle {
            self.tintColorStyle = tintCStyle;
        }
        
        if let bgCStyle = self.bgColorStyle {
            self.bgColorStyle = bgCStyle;
        }
    } //F.E.
    
} //CLS END
