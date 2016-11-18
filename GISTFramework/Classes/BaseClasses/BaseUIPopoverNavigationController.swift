//
//  BaseUIPopoverNavigationController.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 14/06/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit

open class BaseUIPopoverNavigationController: BaseUINavigationController {

    private var _mainNavigationController:UINavigationController?
    open var mainNavigationController:UINavigationController? {
        get {
            return _mainNavigationController;
        }
    } //P.E.
    
    private var _popoverController:PopoverController?;
    open var popoverController:PopoverController? {
        get {
            return _popoverController;
        }
    } //P.E.
    
    private var _parentViewController:UIViewController!
    
    private var _popoverContentSize:CGSize = CGSize(width: 414, height: 736);
    open var popoverContentSize:CGSize {
        set {
            _popoverContentSize = newValue;
        }
        
        get {
            return _popoverContentSize;
        }
    } //P.E.
    
    private var _popoverContentPosition:CGPoint?;
    open var popoverContentPosition:CGPoint?
        {
        set {
            _popoverContentPosition = newValue;
        }
        
        get {
            return _popoverContentPosition;
        }
    } //P.E.
    
    private var _popoverContentRoundedCorner:Bool = true;
    open var popoverContentRoundedCorner:Bool
        {
        set {
            _popoverContentRoundedCorner = newValue;
        }
        
        get {
            return _popoverContentRoundedCorner;
        }
    } //P.E.
    
    private var _arrowColor:UIColor = UIColor.black;
    open var arrowColor:UIColor {
        set {
            _arrowColor = newValue;
        }
        
        get {
            return _arrowColor;
        }
    } //P.E.
    
    override public init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController);
    } //F.E.

    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil);
    } //F.E.
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    } //F.E.
    
    override open func viewDidLoad() {
        super.viewDidLoad()
    } //F.E.
    
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    } //F.E.
    
    open func show(inViewController viewController:UIViewController, fromRect rect:CGRect = CGRect.zero, permittedArrowDirection:UIPopoverArrowDirection = UIPopoverArrowDirection()) {
        _parentViewController = viewController;
        _mainNavigationController = _parentViewController.navigationController;
        //--
        _popoverController = PopoverController(contentViewController: self);
        //--
        _popoverController!.popoverContentSize = _popoverContentSize;
        _popoverController!.popoverContentPosition = _popoverContentPosition;
        //--
        _popoverController!.popoverContentRoundedCorner = _popoverContentRoundedCorner;
        //--
        _popoverController!.arrowColor = self.topViewController!.view.backgroundColor!;
        //--
        self._popoverController!.presentPopoverFromRect(rect, inViewController: _parentViewController, permittedArrowDirection: permittedArrowDirection, animated: true);
    } //F.E.
    
    open func dismissPopover(_ animated:Bool = true) {
        _popoverController!.dismissPopoverAnimated(animated);
    } //F.E.
} //CLS END
