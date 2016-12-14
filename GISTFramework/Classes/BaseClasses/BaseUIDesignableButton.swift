//
//  BaseDesignableButton.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 14/06/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit

public class BaseUIDesignableButton: BaseUIButton {
   
    private var _view: UIView! // NOT USING BASE CLASS HERE SO THAT THERE SHOULD NOT BE DEPENDENCY ISSUE
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        //Setting up custom xib
        self.xibSetup();
    } //F.E.
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        
        //Setting up custom xib
        self.xibSetup();
    } //F.E.
    
    override public func updateView() {
        super.updateView();
        
        (_view as? BaseView)?.updateView();
    } //F.E.
    
    //MARK: - Setup Custom View
    private func xibSetup() {
        let nib = getNib();
        
        _view = UIView.loadDynamicViewWithNib(nib.nibName, viewIndex: nib.viewIndex, owner: self) as! UIView;
        
        //Disabling the interaction for subview
        _view.userInteractionEnabled = false;
        
        // use bounds, Not frame
        _view.frame = bounds;
        
        // Make the view stretch with containing view
        _view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight];
        
        // Adding custom subview on top of our view
        self.addSubview(_view);
    }//F.E.
    
    public func getNib() -> (nibName:String, viewIndex:Int) {
        assert(false, "Override this method in your class");
        return ("", 0);
    }//F.E.

} //CLS END
