//
//  BaseUIPopoverNavigationController.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 14/06/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit

/// BaseUIPopoverNavigationController is a subclass of BaseUINavigationController. It has some extra proporties for the Popover Controller.
open class BaseUIPopoverNavigationController: BaseUINavigationController {

    //MARK: - Properties
    
    private var _mainNavigationController:UINavigationController?
    
    /// Main Navigation Controller Instance.
    open var mainNavigationController:UINavigationController? {
        get {
            return _mainNavigationController;
        }
    } //P.E.
    
    private var _popoverController:PopoverController?;
    
    /// Popover Controller Instance.
    open var popoverController:PopoverController? {
        get {
            return _popoverController;
        }
    } //P.E.
    
    private var _parentViewController:UIViewController!
    
    private var _popoverContentSize:CGSize = CGSize(width: 414, height: 736);
    
    /// Popover Contrnet Size - Default value CGSize(width: 414, height: 736).
    open var popoverContentSize:CGSize {
        set {
            _popoverContentSize = newValue;
        }
        
        get {
            return _popoverContentSize;
        }
    } //P.E.
    
    private var _popoverContentPosition:CGPoint?;
    
    /// Popover Content Position
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
    
    /// Flag for popover view rounded corner.
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
    
    /// Popover arrow color
    open var arrowColor:UIColor {
        set {
            _arrowColor = newValue;
        }
        
        get {
            return _arrowColor;
        }
    } //P.E.
    
    //MARK: - Constructors
    
    /// Overridden constructor to setup/ initialize components.
    ///
    /// - Parameter rootViewController: Root View Controller of Navigation
    override public init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController);
    } //F.E.

    /// Overridden constructor to setup/ initialize components.
    ///
    /// - Parameters:
    ///   - nibNameOrNil: Nib Name
    ///   - nibBundleOrNil: Nib Bundle Name
    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil);
    } //F.E.
    
    /// Required constructor implemented.
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    } //F.E.
    
    //MARK: - Methods
    
    /// Show
    ///
    /// - Parameters:
    ///   - viewController: Container View Controller
    ///   - rect: Start point rect of popover view - Default value is CGRect.zero
    ///   - permittedArrowDirection: Arrow Direction
    open func show(inViewController viewController:UIViewController, fromRect rect:CGRect = CGRect.zero, permittedArrowDirection:UIPopoverArrowDirection = UIPopoverArrowDirection()) {
        _parentViewController = viewController;
        _mainNavigationController = _parentViewController.navigationController;
        
        _popoverController = PopoverController(contentViewController: self);
        
        _popoverController!.popoverContentSize = _popoverContentSize;
        _popoverController!.popoverContentPosition = _popoverContentPosition;
        
        _popoverController!.popoverContentRoundedCorner = _popoverContentRoundedCorner;
        
        _popoverController!.arrowColor = self.topViewController!.view.backgroundColor!;
        
        self._popoverController!.presentPopoverFromRect(rect, inViewController: _parentViewController, permittedArrowDirection: permittedArrowDirection, animated: true);
    } //F.E.
    
    
    open func dismissPopover(_ animated:Bool = true) {
        _popoverController!.dismissPopoverAnimated(animated);
    } //F.E.
} //CLS END
