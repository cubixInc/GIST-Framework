//
//  UIView+Utility.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 14/06/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit

public extension UIView {
    
    public class func loadWithNib(_ nibName:String, viewIndex:Int, owner: AnyObject) -> Any {
        return Bundle.main.loadNibNamed(nibName, owner: owner, options: nil)![viewIndex];
    } //F.E.
    
    public class func loadDynamicViewWithNib(_ nibName:String, viewIndex:Int, owner: AnyObject) -> Any {
        
        let bundle = Bundle(for: type(of: owner));
        let nib = UINib(nibName: nibName, bundle: bundle);
        
        // Assumes UIView is top level and only object in CustomView.xib file
        let rView: Any = nib.instantiate(withOwner: owner, options: nil)[viewIndex];
        return rView;
    } //F.E.
    
    public func addBorder(_ color:UIColor?, width:Int){
        let layer:CALayer = self.layer;
        layer.borderColor = color?.cgColor
        layer.borderWidth = (CGFloat(width)/CGFloat(2)) as CGFloat
    } //F.E.
    
    public func addRoundedCorners() {
        self.addRoundedCorners(self.frame.size.width/2.0);
    } //F.E.
    
    public func addRoundedCorners(_ radius:CGFloat) {
        let layer:CALayer = self.layer;
        layer.cornerRadius = radius
        layer.masksToBounds = true
    } //F.E.
    
    public func addDropShadow() {
        let shadowPath:UIBezierPath=UIBezierPath(rect: self.bounds)
        let layer:CALayer = self.layer;
        
        layer.shadowColor = UIColor.black.cgColor;
        layer.shadowOffset = CGSize(width: 1, height: 1);
        layer.shadowOpacity = 0.21
        layer.shadowRadius = 2.0
        layer.shadowPath = shadowPath.cgPath
        
        layer.masksToBounds = false;
    } //F.E.
    
    public func fadeIn() {
        self.alpha=0.0;
        self.isHidden = false;
        UIView.animate(withDuration: 0.25, animations: { () -> Void in
            self.alpha=1.0;
        })
    } //F.E.
    
    public func fadeOut(_ completion:((_ finished:Bool)->())?) {
        self.alpha = 1.0
        UIView.animate(withDuration: 0.25, animations: { () -> Void in
            self.alpha=0.0;
            }, completion: { (finish:Bool) -> Void in
                self.isHidden = true;
                completion?(finish)
        }) 
    } //F.E.
    
    public func shake() {
        let shake:CABasicAnimation = CABasicAnimation(keyPath: "position");
        shake.duration = 0.1;
        shake.repeatCount = 2;
        shake.autoreverses = true;
        shake.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 5, y: self.center.y));
        shake.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 5, y: self.center.y));
        self.layer.add(shake, forKey: "position");
    } //F.E.
    
    public func removeAllSubviews() {
        for view in self.subviews {
            view.removeFromSuperview();
        }
    } //F.E.
    
} //E.E.
