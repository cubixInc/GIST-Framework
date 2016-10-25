//
//  PopoverControllerView.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 14/06/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit

public class PopoverControllerView: UIView {

    //Defining here in the class privately, so that the class be independent - It may be improved
    private func afterDelay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    } //F.E.
    
    private var _fromRect:CGRect = CGRectZero;
    
    private var _containerView:UIView!
    
    private var _contentView:UIView?;
    public var contentView:UIView? {
        get {
            return _contentView;
        }
    } //P.E.
    
    private var _popoverContentSize:CGSize = CGSize(width: 320, height: 480);
    
    public var popoverContentSize:CGSize {
        set {
            _popoverContentSize = newValue;
        }
        
        get {
            return _popoverContentSize;
        }
    } //P.E.
    
    private var popoverContentRect:CGRect {
        get {
            
            var rect:CGRect!
            //--
            let offSet:CGFloat = 20;
            //--
            switch (_arrowDirection) {
            case UIPopoverArrowDirection.Up:
                rect = CGRect(x: _fromRect.origin.x + ((_fromRect.size.width - _popoverContentSize.width) / 2.0), y: _fromRect.origin.y + _fromRect.height + offSet, width: _popoverContentSize.width, height: _popoverContentSize.height);
                break;
                
            case UIPopoverArrowDirection.Left:
                rect = CGRect(x: _fromRect.origin.x + _fromRect.width + offSet, y: _fromRect.origin.y + ((_fromRect.size.height - _popoverContentSize.height) / 2.0), width: _popoverContentSize.width, height: _popoverContentSize.height);
                break;
                
            case UIPopoverArrowDirection.Right:
                rect = CGRect(x: _fromRect.origin.x - _popoverContentSize.width - offSet, y: _fromRect.origin.y + ((_fromRect.size.height - _popoverContentSize.height) / 2.0), width: _popoverContentSize.width, height: _popoverContentSize.height);
                break;
                
            case UIPopoverArrowDirection.Down:
                rect = CGRect(x: _fromRect.origin.x + ((_fromRect.size.width - _popoverContentSize.width) / 2.0), y: _fromRect.origin.y - _popoverContentSize.height - offSet, width: _popoverContentSize.width, height: _popoverContentSize.height);
                break;
                
            default:
                rect = CGRect(x: (UIScreen.mainScreen().bounds.width - _popoverContentSize.width) / 2.0, y: (UIScreen.mainScreen().bounds.height - _popoverContentSize.height) / 2.0, width: _popoverContentSize.width, height: _popoverContentSize.height);
                break;
            }
            
            rect.origin.x = min(max(offSet, rect.origin.x), UIScreen.mainScreen().bounds.width - rect.size.width - 15);
            rect.origin.y = min(max(offSet, rect.origin.y), UIScreen.mainScreen().bounds.height - rect.size.height - 15);
            
            return rect;
        }
    } //F.E.
    
    private var _backgroundView:UIView!;
    
    private var _backgroundColor:UIColor? = UIColor.blackColor().colorWithAlphaComponent(0.5);
    override public var backgroundColor:UIColor? {
        get {
            return _backgroundColor;
        }
        
        set {
            if (_backgroundColor != newValue)
            {
                _backgroundColor = newValue;
                //--
                _backgroundView.backgroundColor = _backgroundColor;
            }
        }
    } //F.E.
    
    private var _arrowView:ArrowView?;
    private var arrowView:ArrowView {
        get {
            if (_arrowView == nil)
            {
                _arrowView = ArrowView(frame: CGRect(x: 0, y: 0, width: 20, height: 20));
                //--
                self.addSubview(_arrowView!);
            }
            //--
            return _arrowView!;
        }
    } //P.E.
    
    private var _arrowDirection:UIPopoverArrowDirection = UIPopoverArrowDirection.Unknown;
    //--
    private var arrowDirection:UIPopoverArrowDirection {
        get {
            return _arrowDirection;
        }
        
        set {
            _arrowDirection = newValue;
        }
    } //P.E.
    
    public init(contentView:UIView) {
        super.init(frame:UIScreen.mainScreen().bounds);
        //--
        super.backgroundColor = UIColor.clearColor();
        //--
        setupPopoverController(contentView);
    } //F.E.
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented");
    } //F.E
    
    private func setupPopoverController(contentView:UIView) {
        _contentView = contentView;
        //Background View
        _backgroundView = UIView(frame: UIScreen.mainScreen().bounds);
        _backgroundView.backgroundColor = _backgroundColor;
        self.addSubview(_backgroundView);
        
        _backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backgroundViewTapped)));
        
        let containtViewRect = self.popoverContentRect;
        
        //ContainerView
        _containerView = UIView(frame: containtViewRect);
        _containerView.backgroundColor = UIColor.clearColor();
        _containerView.autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth];
        _containerView.addRoundedCorners(6);
        
        self.addSubview(_containerView);
        
        _contentView!.frame = CGRect(x: 0, y: 0, width: containtViewRect.width, height: containtViewRect.height);
        _contentView!.autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth];
        _containerView.addSubview(_contentView!);
        
        //Arrow
        if (_contentView!.backgroundColor != nil)
        {
            self.arrowView.arrowColor = _contentView!.backgroundColor!;
        }
    } //F.E.
    
    
    public func presentPopoverFromRect(rect:CGRect, permittedArrowDirection:UIPopoverArrowDirection, animated:Bool) {
        updatePopoverFrame(fromRect:rect, permittedArrowDirection:permittedArrowDirection);
        //--
//        (UIApplication.sharedApplication().delegate as! AppDelegate).window!.addSubview(self); // THIS IS NOT WORKING IN THE FRAMEWORK
        UIApplication.sharedApplication().keyWindow?.addSubview(self);
        //--
        if (animated)
        {
            self.alpha = 0.0;
            //--
            afterDelay(0.1, closure: { () -> () in
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    self.alpha=1.0
                })
            })
        }
    } //F.E.
    
    func backgroundViewTapped(gestureRecognizer:UITapGestureRecognizer) {
        self.dismissPopoverAnimated(true);
    } //F.E.
    
    public func dismissPopoverAnimated(animated: Bool, completion:((Bool)->Void)? = nil) {
        if (animated == true)
        {
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.alpha = 0.0;
                }, completion: { (Bool) -> Void in
                    self.cleanup();
                    //--
                    if (completion != nil)
                    {completion!(true);}
            })
        }
        else
        {
            self.cleanup();
            //--
            if (completion != nil)
            {completion!(true);}
        }
    } //F.E.
    
    private func cleanup() {
        if (_contentView != nil)
        {_contentView!.removeFromSuperview();}
        //--
        _containerView.removeFromSuperview();
        _backgroundView.removeFromSuperview();
        //--
        self.removeFromSuperview();
    } //F.E.
    
    private func updatePopoverFrame(fromRect rect:CGRect, permittedArrowDirection:UIPopoverArrowDirection) {
        _fromRect = rect;
        _arrowDirection = permittedArrowDirection;
        //--
        let containtViewRect = self.popoverContentRect;
        _containerView.frame = containtViewRect;
        //--
        _contentView!.frame = CGRect(x: 0, y: 0, width: containtViewRect.width, height: containtViewRect.height);
        
        //Arrow Update
        updateArrow();
    } //F.E.
    
    //MARK: - ArrowView
    private func updateArrow() {
        switch (_arrowDirection) {
        case UIPopoverArrowDirection.Up:
            self.arrowView.hidden = false;
            //--
            self.arrowView.frame = CGRectMake(_fromRect.origin.x + (_fromRect.width - self.arrowView.frame.width)/2.0, _containerView.frame.origin.y - self.arrowView.frame.size.height, self.arrowView.frame.size.width, self.arrowView.frame.size.height);
            self.arrowView.transform = CGAffineTransformMakeRotation(degreestoradians(180));
            break;
            
        case UIPopoverArrowDirection.Left:
            self.arrowView.hidden = false;
            //--
            self.arrowView.frame = CGRectMake(_containerView.frame.origin.x - self.arrowView.frame.size.width, _fromRect.origin.y + (_fromRect.height - self.arrowView.frame.height)/2.0, self.arrowView.frame.size.width, self.arrowView.frame.size.height);
            
            self.arrowView.transform = CGAffineTransformMakeRotation(degreestoradians(90));
            break;
            
        case UIPopoverArrowDirection.Right:
            self.arrowView.hidden = false;
            //--
            self.arrowView.frame = CGRectMake(_containerView.frame.origin.x + _containerView.frame.size.width, _fromRect.origin.y + (_fromRect.height - self.arrowView.frame.height)/2.0, self.arrowView.frame.size.width, self.arrowView.frame.size.height);
            self.arrowView.transform = CGAffineTransformMakeRotation(degreestoradians(-90));
            break;
            
        case UIPopoverArrowDirection.Down:
            self.arrowView.hidden = false;
            //--
            self.arrowView.frame = CGRectMake(_fromRect.origin.x + (_fromRect.width - self.arrowView.frame.width)/2.0, _containerView.frame.origin.y + _containerView.frame.size.height, self.arrowView.frame.size.width, self.arrowView.frame.size.height);
            break;
            
        default:
            self.arrowView.hidden = true;
            break;
        }
    } //F.E.
    
    private func degreestoradians(a:Double) -> CGFloat
    {
        return CGFloat(M_PI * a / 180.0);
    } //F.E.
    
} //CLS END

private class ArrowView:UIView {
    
    private var _arrowColor:UIColor = UIColor.blackColor();
    
    var arrowColor:UIColor {
        set {
            _arrowColor = newValue;
        }
        
        get {
            return _arrowColor;
        }
    } //P.E.
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        //--
        self.opaque = false;
    } //C.E.
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    } //C.E.
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect);
        //--
        // Drawing code
        let currentContext:CGContextRef = UIGraphicsGetCurrentContext()!;
        
        CGContextSetFillColorWithColor(currentContext, _arrowColor.CGColor);
        
        let arrowLocation:CGPoint =  CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(self.bounds));
        let arrowSize:CGSize = self.frame.size;
        
        let arrowTip:CGPoint = CGPointMake(arrowLocation.x, arrowLocation.y + (arrowSize.height / 2));
        let arrowLeftFoot:CGPoint = CGPointMake(arrowLocation.x - (arrowSize.width / 2), arrowLocation.y - (arrowSize.height / 2));
        let arrowRightFoot:CGPoint = CGPointMake(arrowLocation.x + (arrowSize.width / 2), arrowLocation.y - (arrowSize.height / 2));
        
        // now we draw the triangle
        CGContextMoveToPoint(currentContext, arrowTip.x, arrowTip.y);
        CGContextAddLineToPoint(currentContext, arrowLeftFoot.x, arrowLeftFoot.y);
        CGContextAddLineToPoint(currentContext, arrowRightFoot.x, arrowRightFoot.y);
        
        CGContextClosePath(currentContext);
        CGContextDrawPath(currentContext, CGPathDrawingMode.Fill);
    } //F.E.
    
} //CLS END