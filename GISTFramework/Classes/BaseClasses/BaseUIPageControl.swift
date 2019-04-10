//
//  BaseUIPageControl.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 08/12/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit

/// BaseUIPageControl is a subclass of UIPageControl and implements BaseView. It has some extra proporties and support for SyncEngine.
open class BaseUIPageControl: UIPageControl, BaseView {

    //MARK: - Properties
    @IBInspectable open var pageIndicatorTintColorStyle:String? = nil {
        didSet {
            self.pageIndicatorTintColor = SyncedColors.color(forKey: pageIndicatorTintColorStyle);
        }
    } //P.E.
    
    @IBInspectable open var currentPageIndicatorTintColorStyle:String? = nil {
        didSet {
            self.currentPageIndicatorTintColor = SyncedColors.color(forKey: currentPageIndicatorTintColorStyle);
        }
    } //P.E.
    
    //MARK: - Overridden Methods
    
    /// Overridden method to setup/ initialize components.
    override open func awakeFromNib() {
        super.awakeFromNib()
        
        self.updateView();
    } //F.E.
    
    //MARK: - Methods
    
    /// Updates layout and contents from SyncEngine. this is a protocol method BaseView that is called when the view is refreshed.
    func updateView(){
        if let pIndicatorTintCStyle = self.pageIndicatorTintColorStyle {
            self.pageIndicatorTintColorStyle = pIndicatorTintCStyle;
        }
        
        if let cPIndicatorTintColorStyle = self.currentPageIndicatorTintColorStyle {
            self.currentPageIndicatorTintColorStyle = cPIndicatorTintColorStyle;
        }
    } //F.E.
    
} //CLS END
