//
//  BaseDesignableButton.swift
//  eGrocery
//
//  Created by Muneeba on 2/17/15.
//  Copyright (c) 2015 cubixlabs. All rights reserved.
//

import UIKit

class BaseUIDesignableButton: BaseUIButton {
   
    private var _view: UIView! // NOT USING BASE CLASS HERE SO THAT THERE MAY NOT BE DEPENDENCY ISSUE
    //--
    override init(frame: CGRect)
    {
        super.init(frame: frame);
        //--
        xibSetup();
    } //F.E.
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup();
    } //F.E.
    
    override var selected: Bool {
        
        didSet(newValue) {
            //super.selected = newValue;
        }
    } //F.E.
    
    override func updateView() {
        super.updateView();
        //--
        (_view as? BaseView)?.updateView();
    } //F.E.
    
    private func xibSetup() {
        
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
    
    func getNib() -> (nibName:String, viewIndex:Int)
    {
        assert(false, "Override this method in your class");
        return ("", 0);
    }//F.E.

}
