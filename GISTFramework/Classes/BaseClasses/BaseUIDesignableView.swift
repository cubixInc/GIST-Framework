//
//  BaseDesignableView.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 14/06/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit

open class BaseUIDesignableView: BaseUIView {
    
    fileprivate var _view: UIView!
    //--
    override public init(frame: CGRect) {
        super.init(frame: frame);
        
        //Setting up custom xib
        self.xibSetup();
    } //F.E.
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        
        //Setting up custom xib
        self.xibSetup();
    } //F.E.
    
    override open func updateView() {
        super.updateView();
        //--
        (_view as? BaseView)?.updateView();
    } //F.E.
    
    //MARK: - Setup Custom View
    open func xibSetup() {
        let nib = getNib();
        //--
        _view = UIView.loadDynamicViewWithNib(nib.nibName, viewIndex: nib.viewIndex, owner: self) as! UIView;
        
        // use bounds, Not frame
        _view.frame = bounds;
        
        // Make the view stretch with containing view
        _view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight];
        
        // Adding custom subview on top of our view
        self.addSubview(_view);
    }//F.E.
    

    open func getNib() -> (nibName:String, viewIndex:Int) {
        assert(false, "Override this method in your class");
        return ("", 0);
    }//F.E.
    
} //F.E.
