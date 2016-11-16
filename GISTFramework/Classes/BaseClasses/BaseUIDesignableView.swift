//
//  BaseDesignableView.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 14/06/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit

/// BaseUIDesignableView is a subclass of BaseUIView. It draws custom view xib on the view and has all the features of a BaseUIView.
open class BaseUIDesignableView: BaseUIView {
    
    //MARK: - Properties
    
    /// Holding containt view
    private var _view: UIView!
    
    /// Inspectable property for custom xib name.
    @IBInspectable open var xibName:String?; //Default value is nil
    
    /// Inspectable property for custom xib view index.
    @IBInspectable open var xibViewIndex:Int = 0; //Default value is Zero
    
    //MARK: - Constructors
    
    /// Used when creating the underlying layer for the view with a custom xib
    ///
    /// - Parameters:
    ///   - frame:  View frame
    ///   - nibName: Xib file name
    ///   - viewIndex: Xib file view index
    public init(frame: CGRect, nibName:String, viewIndex:Int = 0) {
        super.init(frame: frame);
        
        //Holding Params
        self.xibName = nibName;
        self.xibViewIndex = viewIndex;
        
        //Setting up custom xib
        self.xibSetup();
    } //F.E.
    
    /// Required constructor implemented.
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    } //F.E.

    //MARK: - Overridden Methods
    
    /// Overridden method to setup/ initialize components.
    open override func awakeFromNib() {
        super.awakeFromNib();
        
        //Setting up custom xib
        self.xibSetup();
    } //F.E.
    
    /// Updates layout and contents from SyncEngine. this is a protocol method BaseView that is called when the view is refreshed.
    override func updateView() {
        super.updateView();
        //--
        (_view as? BaseView)?.updateView();
    } //F.E.
    
    //MARK: - Methods
    
    /// Setup Custom View
    private func xibSetup() {
        guard self.xibName != nil else {
            return;
        }
        
        _view = UIView.loadDynamicViewWithNib(self.xibName!, viewIndex: self.xibViewIndex, owner: self) as! UIView;
        
        // use bounds, Not frame
        _view.frame = bounds;
        
        // Make the view stretch with containing view
        _view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight];
        
        // Adding custom subview on top of our view
        self.addSubview(_view);
    }//F.E.
    
} //CLS END
