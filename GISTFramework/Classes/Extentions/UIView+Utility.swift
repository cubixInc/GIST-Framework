//
//  UIView+Utility.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 14/06/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit

public extension UIView {
    
    public class func loadWithNib(nibName:String, viewIndex:Int, owner: AnyObject) -> AnyObject {
        return NSBundle.mainBundle().loadNibNamed(nibName, owner: owner, options: nil)![viewIndex];
    } //F.E.
    
    public class func loadDynamicViewWithNib(nibName:String, viewIndex:Int, owner: AnyObject) -> AnyObject {
        
        let bundle = NSBundle(forClass: owner.dynamicType);
        let nib = UINib(nibName: nibName, bundle: bundle);
        
        // Assumes UIView is top level and only object in CustomView.xib file
        let rView: AnyObject = nib.instantiateWithOwner(owner, options: nil)[viewIndex];
        return rView;
    } //F.E.
    
    public func addBorder(color:UIColor?, width:Int){
        let layer:CALayer = self.layer;
        layer.borderColor = color?.CGColor
        layer.borderWidth = (CGFloat(width)/CGFloat(2)) as CGFloat
    } //F.E.
    
    public func addRoundedCorners() {
        self.addRoundedCorners(self.frame.size.width/2.0);
    } //F.E.
    
    public func addRoundedCorners(radius:CGFloat) {
        let layer:CALayer = self.layer;
        layer.cornerRadius = radius
        layer.masksToBounds = true
    } //F.E.
    
    public func addDropShadow() {
        let shadowPath:UIBezierPath=UIBezierPath(rect: self.bounds)
        let layer:CALayer = self.layer;
        
        layer.shadowColor = UIColor.blackColor().CGColor;
        layer.shadowOffset = CGSizeMake(1, 1);
        layer.shadowOpacity = 0.21
        layer.shadowRadius = 2.0
        layer.shadowPath = shadowPath.CGPath
        
        layer.masksToBounds = false;
    } //F.E.
    
    public func fadeIn() {
        self.alpha=0.0;
        self.hidden = false;
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.alpha=1.0;
        })
    } //F.E.
    
    public func fadeOut(completion:((finished:Bool)->())?) {
        self.alpha = 1.0
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.alpha=0.0;
            }) { (finish:Bool) -> Void in
                self.hidden = true;
                completion?(finished: finish)
        }
    } //F.E.
    
    public func shake() {
        let shake:CABasicAnimation = CABasicAnimation(keyPath: "position");
        shake.duration = 0.1;
        shake.repeatCount = 2;
        shake.autoreverses = true;
        shake.fromValue = NSValue(CGPoint: CGPoint(x: self.center.x - 5, y: self.center.y));
        shake.toValue = NSValue(CGPoint: CGPoint(x: self.center.x + 5, y: self.center.y));
        self.layer.addAnimation(shake, forKey: "position");
    } //F.E.
    
    public func removeAllSubviews() {
        for view in self.subviews {
            view.removeFromSuperview();
        }
    } //F.E.
    
} //E.E.
