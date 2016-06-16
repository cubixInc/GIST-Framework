//
//  BaseUIPopoverNavigationController.swift
//  eGrocery
//
//  Created by Shoaib on 4/9/15.
//  Copyright (c) 2015 cubixlabs. All rights reserved.
//

import UIKit

public class BaseUIPopoverNavigationController: BaseUINavigationController {

    private var _mainNavigationController:UINavigationController?
    public var mainNavigationController:UINavigationController? {
        get {
            return _mainNavigationController;
        }
    } //P.E.
    
    private var _popoverController:PopoverController?;//UIPopoverController?
    public var popoverController:PopoverController? {
        get {
            return _popoverController;
        }
    } //P.E.
    
    private var _parentViewController:UIViewController!
    
    private var _popoverContentSize:CGSize = CGSize(width: 414, height: 736);
    public var popoverContentSize:CGSize {
        set {
            _popoverContentSize = newValue;
        }
        
        get {
            return _popoverContentSize;
        }
    } //P.E.
    
    private var _popoverContentPosition:CGPoint?;
    public var popoverContentPosition:CGPoint?
        {
        set {
            _popoverContentPosition = newValue;
        }
        
        get {
            return _popoverContentPosition;
        }
    } //P.E.
    
    private var _popoverContentRoundedCorner:Bool = true;
    public var popoverContentRoundedCorner:Bool
        {
        set {
            _popoverContentRoundedCorner = newValue;
        }
        
        get {
            return _popoverContentRoundedCorner;
        }
    } //P.E.
    
    private var _arrowColor:UIColor = UIColor.blackColor();
    public var arrowColor:UIColor {
        set {
            _arrowColor = newValue;
        }
        
        get {
            return _arrowColor;
        }
    } //P.E.
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController, barStyle:BarStyle.Default);
    } //F.E.

    override  init(rootViewController: UIViewController, barStyle:BarStyle) {
        super.init(rootViewController: rootViewController);
    } //F.E.
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil);
    } //F.E.
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    } //F.E.
    
    override public func viewDidLoad() {
        super.viewDidLoad()
    } //F.E.
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    } //F.E.
    
    public func show(inViewController viewController:UIViewController, fromRect rect:CGRect = CGRect.zero, permittedArrowDirection:UIPopoverArrowDirection = UIPopoverArrowDirection()) {
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
    
    public func dismissPopover(animated:Bool = true) {
        _popoverController!.dismissPopoverAnimated(animated);
    } //F.E.
} //CLS END
