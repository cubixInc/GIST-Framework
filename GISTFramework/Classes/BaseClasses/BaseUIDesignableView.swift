//
//  BaseDesignableView.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 14/06/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit

public class BaseUIDesignableView: BaseUIView {
    
    private var _view: UIView!
    //--
    override init(frame: CGRect) {
        super.init(frame: frame);
        //--
        xibSetup();
    } //F.E.
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup();
    } //F.E.
    
    override public func updateView() {
        super.updateView();
        //--
        (_view as? BaseView)?.updateView();
    } //F.E.
    
    public func xibSetup() {
        let nib = getNib();
        //--
        _view = UIView.loadDynamicViewWithNib(nib.nibName, viewIndex: nib.viewIndex, owner: self) as! UIView;
        
        // use bounds not frame
        _view.frame = bounds;
        
        // Make the view stretch with containing view
        _view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight];
        
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        self.addSubview(_view);
    }//F.E.
    

    public func getNib() -> (nibName:String, viewIndex:Int) {
        assert(false, "Override this method in your class");
        return ("", 0);
    }//F.E.
    
} //F.E.
