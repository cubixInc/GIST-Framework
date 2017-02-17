//
//  BaseUICustomPopover.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 14/06/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit

/**
 PopoverController is a subclass of UIViewController. It is a custom implementation of native UIPopoverController with some extra features.
 
 It is taking UIViewController as a content view.
 */
open class PopoverController: BaseUIViewController {

    //MARK: - Properties
    
    private var _fromRect:CGRect = CGRect.zero;
    
    private var _parentViewController:UIViewController!;
    private var _containerView:BaseUIView!
    
    private var _contentViewController:UIViewController?;
    open var contentViewController:UIViewController? {
        get {
            return _contentViewController;
        }
    } //P.E.
    
    private var _contentView:UIView?;
    open var contentView:UIView? {
        get {
            return _contentView;
        }
    } //P.E.
    
    private var _roundedCorner:Bool = true;
    open var popoverContentRoundedCorner:Bool
        {
        set {
            if (_roundedCorner != newValue) {
                _roundedCorner = newValue;
                
                _containerView.addRoundedCorners(_roundedCorner ?6:0);
            }
        }
        
        get {
            return _roundedCorner;
        }
    } //P.E.
    
    private var _position:CGPoint?
    open var popoverContentPosition:CGPoint?
    {
        set {
            _position = newValue;
        }
        
        get {
            return _position;
        }
    } //P.E.
    
    private var _popoverContentSize:CGSize = CGSize(width: 320, height: 480);
    
    /// Holds size of content view - Default value is CGSize(width: 320, height: 480).
    open var popoverContentSize:CGSize {
        set {
            _popoverContentSize = newValue;
        }
        
        get {
            return _popoverContentSize;
        }
    } //P.E.
    
    private var popoverContentRect:CGRect {
        get {
            if (_position != nil)
            {return CGRect(origin: _position!, size: _popoverContentSize);}
            
            var rect:CGRect!
             
            let offSet:CGFloat = 20;
             
            switch (_arrowDirection) {
            case UIPopoverArrowDirection.up:
                rect = CGRect(x: _fromRect.origin.x + ((_fromRect.size.width - _popoverContentSize.width) / 2.0), y: _fromRect.origin.y + _fromRect.height + offSet, width: _popoverContentSize.width, height: _popoverContentSize.height);
                break;
                
            case UIPopoverArrowDirection.left:
                rect = CGRect(x: _fromRect.origin.x + _fromRect.width + offSet, y: _fromRect.origin.y + ((_fromRect.size.height - _popoverContentSize.height) / 2.0), width: _popoverContentSize.width, height: _popoverContentSize.height);
                break;
                
            case UIPopoverArrowDirection.right:
                rect = CGRect(x: _fromRect.origin.x - _popoverContentSize.width - offSet, y: _fromRect.origin.y + ((_fromRect.size.height - _popoverContentSize.height) / 2.0), width: _popoverContentSize.width, height: _popoverContentSize.height);
                break;
                
            case UIPopoverArrowDirection.down:
                rect = CGRect(x: _fromRect.origin.x + ((_fromRect.size.width - _popoverContentSize.width) / 2.0), y: _fromRect.origin.y - _popoverContentSize.height - offSet, width: _popoverContentSize.width, height: _popoverContentSize.height);
                break;
                
            default:
                rect = CGRect(x: (UIScreen.main.bounds.width - _popoverContentSize.width) / 2.0, y: (UIScreen.main.bounds.height - _popoverContentSize.height) / 2.0, width: _popoverContentSize.width, height: _popoverContentSize.height);
                break;
            }
            
            rect.origin.x = min(max(offSet, rect.origin.x), UIScreen.main.bounds.width - rect.size.width - 15);
            rect.origin.y = min(max(offSet, rect.origin.y), UIScreen.main.bounds.height - rect.size.height - 15);
             
            return rect;
        }
    } //F.E.
    
    private var _backgroundView:BaseUIView!;
    
    private var _backgroundColor:UIColor = UIColor.black.withAlphaComponent(0.5);
    open var backgroundColor:UIColor {
        get {
            return _backgroundColor;
        }
        
        set {
            if (_backgroundColor != newValue) {
                _backgroundColor = newValue;
                
                _backgroundView.backgroundColor = _backgroundColor;
            }
        }
    } //F.E.
    
    open var arrowColor:UIColor {
        get {
            return self.arrowView.arrowColor;
        }
        
        set {
            self.arrowView.arrowColor = newValue;
        }
    } //F.E.
    
    private var _arrowView:ArrowView?;
    private var arrowView:ArrowView {
        get {
            if (_arrowView == nil) {
                _arrowView = ArrowView(frame: CGRect(x: 0, y: 0, width: 20, height: 20));
                
                self.view.addSubview(_arrowView!);
            }
            
            return _arrowView!;
        }
    } //P.E.
    
    private var _arrowDirection:UIPopoverArrowDirection = UIPopoverArrowDirection.unknown;
    private var arrowDirection:UIPopoverArrowDirection {
        get {
            return _arrowDirection;
        }
        
        set {
            _arrowDirection = newValue;
        }
    } //P.E.
    
    public init(contentViewController:UIViewController) {
        super.init(nibName: nil, bundle: nil);
         
        self.modalPresentationStyle = UIModalPresentationStyle.custom;
        self.view.backgroundColor = UIColor.clear;
        
        self.setupPopoverController(contentViewController);
    } //F.E.
    
    /// Required constructor implemented.
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    } //F.E
    
    override open func viewDidLoad() {
        super.viewDidLoad();
    } //F.E.

    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    } //F.E.
    
    private func setupPopoverController(_ contentViewController:UIViewController) {
        _contentViewController = contentViewController;
        self.addChildViewController(_contentViewController!);
         
        setupPopoverController(_contentViewController!.view);
    } //F.E.
    
    private func setupPopoverController(_ contentView:UIView) {
        _contentView = contentView;
        //Background View
        _backgroundView = BaseUIView(frame: UIScreen.main.bounds);
        _backgroundView.backgroundColor = _backgroundColor;
        self.view.addSubview(_backgroundView);
        
        _backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backgroundViewTapped)));
        
        let containtViewRect = self.popoverContentRect;
        
        //ContainerView
        _containerView = BaseUIView(frame: containtViewRect);
        _containerView.backgroundColor = UIColor.clear;
        _containerView.autoresizingMask = [UIViewAutoresizing.flexibleHeight, UIViewAutoresizing.flexibleWidth];
        _containerView.addRoundedCorners(6);
        self.view.addSubview(_containerView);
        
        _contentView!.frame = CGRect(x: 0, y: 0, width: containtViewRect.width, height: containtViewRect.height);
        _contentView!.autoresizingMask = [UIViewAutoresizing.flexibleHeight, UIViewAutoresizing.flexibleWidth];
        _containerView.addSubview(_contentView!);
        
        //Arrow
        if (_contentView!.backgroundColor != nil)
        {
            self.arrowView.arrowColor = _contentView!.backgroundColor!;
        }
    } //F.E.
    
    open func presentPopoverFromRect(_ rect:CGRect, inViewController viewController:UIViewController, permittedArrowDirection:UIPopoverArrowDirection, animated:Bool) {
        updatePopoverFrame(fromRect:rect, permittedArrowDirection:permittedArrowDirection);
         
        _parentViewController = viewController;
         
        _parentViewController.present(self, animated: false, completion: nil);
         
        if (animated)
        {
            self.view.alpha = 0.0;
             
            afterDelay(0.1, closure: { () -> Void in
                UIView.animate(withDuration: 0.5, animations: { () -> Void in
                    self.view.alpha=1.0
                })
            })
        }
    } //F.E.
    
    func backgroundViewTapped(_ gestureRecognizer:UITapGestureRecognizer) {
        self.dismissPopoverAnimated(true);
    } //F.E.
    
    open func dismissPopoverAnimated(_ animated: Bool, completion:((Bool)->Void)? = nil) {
        if (animated == true) {
            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                self.view.alpha = 0.0;
            }, completion: { (Bool) -> Void in
                self.cleanup();
                 
                if (completion != nil)
                {completion!(true);}
            })
        } else {
            cleanup();
             
            if (completion != nil)
            {completion!(true);}
        }
    } //F.E.
    
    private func cleanup() {
        if (_contentView != nil)
        {_contentView!.removeFromSuperview();}
         
        if (_contentViewController != nil)
        {_contentViewController!.removeFromParentViewController();}
         
        _containerView.removeFromSuperview();
        _backgroundView.removeFromSuperview();
         
        _parentViewController.dismiss(animated: false, completion: nil);
    } //F.E.
    
    
    private func updatePopoverFrame(fromRect rect:CGRect, permittedArrowDirection:UIPopoverArrowDirection) {
        _fromRect = rect;
        _arrowDirection = permittedArrowDirection;
         
        let containtViewRect = self.popoverContentRect;
        _containerView.frame = containtViewRect;
         
        _contentView!.frame = CGRect(x: 0, y: 0, width: containtViewRect.width, height: containtViewRect.height);
        
        //Arrow Update
        updateArrow();
    } //F.E.
    
    //MARK: - ArrowView
    private func updateArrow() {
        switch (_arrowDirection) {
        case UIPopoverArrowDirection.up:
            self.arrowView.isHidden = false;
             
            self.arrowView.frame = CGRect(x: _fromRect.origin.x + (_fromRect.width - self.arrowView.frame.width)/2.0, y: _containerView.frame.origin.y - self.arrowView.frame.size.height, width: self.arrowView.frame.size.width, height: self.arrowView.frame.size.height);
            self.arrowView.transform = CGAffineTransform(rotationAngle: radianFromDegree(180));
            break;
            
        case UIPopoverArrowDirection.left:
            self.arrowView.isHidden = false;
             
            self.arrowView.frame = CGRect(x: _containerView.frame.origin.x - self.arrowView.frame.size.width, y: _fromRect.origin.y + (_fromRect.height - self.arrowView.frame.height)/2.0, width: self.arrowView.frame.size.width, height: self.arrowView.frame.size.height);
            
            self.arrowView.transform = CGAffineTransform(rotationAngle: radianFromDegree(90));
            break;
            
        case UIPopoverArrowDirection.right:
            self.arrowView.isHidden = false;
             
            self.arrowView.frame = CGRect(x: _containerView.frame.origin.x + _containerView.frame.size.width, y: _fromRect.origin.y + (_fromRect.height - self.arrowView.frame.height)/2.0, width: self.arrowView.frame.size.width, height: self.arrowView.frame.size.height);
            self.arrowView.transform = CGAffineTransform(rotationAngle: radianFromDegree(-90));
            break;
            
        case UIPopoverArrowDirection.down:
            self.arrowView.isHidden = false;
             
            self.arrowView.frame = CGRect(x: _fromRect.origin.x + (_fromRect.width - self.arrowView.frame.width)/2.0, y: _containerView.frame.origin.y + _containerView.frame.size.height, width: self.arrowView.frame.size.width, height: self.arrowView.frame.size.height);
            break;
            
        default:
            self.arrowView.isHidden = true;
            break;
        }
    } //F.E.
    
    private func radianFromDegree(_ a:Double) -> CGFloat {
        return CGFloat(M_PI * a / 180.0);
    } //F.E.
    
    //Defining here in the class privately, so that the class be independent - It may be improved
    private func afterDelay(_ delay:Double, closure:@escaping () -> Void) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    } //F.E.
    
} //CLS END

private class ArrowView:BaseUIView {
    
    private var _arrowColor:UIColor = UIColor.black;
    
    var arrowColor:UIColor {
        set {
            _arrowColor = newValue;
        }
        
        get {
            return _arrowColor;
        }
    } //P.E.
    
    /// Overridden constructor to setup/ initialize components.
    ///
    /// - Parameter frame: View frame
    override init(frame: CGRect) {
        super.init(frame: frame);
        
         
        self.isOpaque = false;
    } //C.E.

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    } //C.E.
    
    override func draw(_ rect: CGRect) {
        super.draw(rect);
     
         
        // Drawing code
        let currentContext:CGContext = UIGraphicsGetCurrentContext()!;
        
        currentContext.setFillColor(_arrowColor.cgColor);
        
        let arrowLocation:CGPoint =  CGPoint(x: rect.midX, y: self.bounds.midY);
        let arrowSize:CGSize = self.frame.size;
        
        let arrowTip:CGPoint = CGPoint(x: arrowLocation.x, y: arrowLocation.y + (arrowSize.height / 2));
        let arrowLeftFoot:CGPoint = CGPoint(x: arrowLocation.x - (arrowSize.width / 2), y: arrowLocation.y - (arrowSize.height / 2));
        let arrowRightFoot:CGPoint = CGPoint(x: arrowLocation.x + (arrowSize.width / 2), y: arrowLocation.y - (arrowSize.height / 2));
        
        // now we draw the triangle
        currentContext.move(to: CGPoint(x: arrowTip.x, y: arrowTip.y));
        currentContext.addLine(to: CGPoint(x: arrowLeftFoot.x, y: arrowLeftFoot.y));
        currentContext.addLine(to: CGPoint(x: arrowRightFoot.x, y: arrowRightFoot.y));
        
        currentContext.closePath();
        currentContext.drawPath(using: CGPathDrawingMode.fill);
    } //F.E.
    
} //CLS END
