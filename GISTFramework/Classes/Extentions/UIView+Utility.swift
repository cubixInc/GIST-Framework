//
//  UIView+Utility.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 14/06/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit

// MARK: - UIView Utility Extension
public extension UIView {
    
    /// Rotate a view by specified degrees in CGFloat
    public var rotation:CGFloat {
        get {
            let radians:CGFloat = atan2(self.transform.b, self.transform.a)
            let degrees:CGFloat = radians * (180.0 / CGFloat(M_PI))
            return degrees;
        }
        
        set {
            let radians = newValue / 180.0 * CGFloat(M_PI)
            let rotation = self.transform.rotated(by: radians);
            self.transform = rotation
        }
    } //P.E.
    
    /// Loads nib from Bundle
    ///
    /// - Parameters:
    ///   - nibName: Nib Name
    ///   - viewIndex: View Index
    ///   - owner: Nib Owner AnyObject
    /// - Returns: UIView
    public class func loadWithNib(_ nibName:String, viewIndex:Int, owner: AnyObject) -> Any {
        return Bundle.main.loadNibNamed(nibName, owner: owner, options: nil)![viewIndex];
    } //F.E.
    
    /// Loads dynamic nib from Bundle
    ///
    /// - Parameters:
    ///   - nibName: Nib Name
    ///   - viewIndex: View Index
    ///   - owner: Nib Owner AnyObject
    /// - Returns: UIView
    public class func loadDynamicViewWithNib(_ nibName:String, viewIndex:Int, owner: AnyObject) -> Any {
        
        let bundle = Bundle(for: type(of: owner));
        let nib = UINib(nibName: nibName, bundle: bundle);
        
        let rView: Any = nib.instantiate(withOwner: owner, options: nil)[viewIndex];
        return rView;
    } //F.E.
    
    /// Adds Boarder for the View
    ///
    /// - Parameters:
    ///   - color: Border Color
    ///   - width: Border Width
    public func addBorder(_ color:UIColor?, width:Int){
        let layer:CALayer = self.layer;
        layer.borderColor = color?.cgColor
        layer.borderWidth = (CGFloat(width)/CGFloat(2)) as CGFloat
    } //F.E.
    
    /// Makes Rounded corners of View. it trims the view in circle
    public func addRoundedCorners() {
        self.addRoundedCorners(self.frame.size.width/2.0);
    } //F.E.
    
    /// Adds rounded corner with defined radius
    ///
    /// - Parameter radius: Radius Value
    public func addRoundedCorners(_ radius:CGFloat) {
        let layer:CALayer = self.layer;
        layer.cornerRadius = radius
        layer.masksToBounds = true
    } //F.E.
    
    /// Adds Drop shadow on the view
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
    
    /// Shows view with fadeIn animation
    ///
    /// - Parameters:
    ///   - duration: Fade duration - Default Value is 0.25
    ///   - completion: Completion block
    public func fadeIn(withDuration duration:Double = 0.25, _ completion:((_ finished:Bool)->())? = nil) {
        self.alpha = 0.0;
        self.isHidden = false;
        
        UIView.animate(withDuration: duration, animations: { () -> Void in
            self.alpha = 1.0;
        }, completion: { (finish:Bool) -> Void in
            completion?(finish)
        })
    } //F.E.
    
    // Hides view with fadeOut animation
    ///
    /// - Parameters:
    ///   - duration: Fade duration - Default Value is 0.25
    ///   - completion: Completion block
    public func fadeOut(withDuration duration:Double = 0.25, _ completion:((_ finished:Bool)->())? = nil) {
        self.alpha = 1.0
        UIView.animate(withDuration: duration, animations: { () -> Void in
            self.alpha=0.0;
            }, completion: { (finish:Bool) -> Void in
                self.isHidden = true;
                completion?(finish)
        }) 
    } //F.E.
    
    /// Shakes view in a static animation
    public func shake() {
        let shake:CABasicAnimation = CABasicAnimation(keyPath: "position");
        shake.duration = 0.1;
        shake.repeatCount = 2;
        shake.autoreverses = true;
        shake.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 5, y: self.center.y));
        shake.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 5, y: self.center.y));
        self.layer.add(shake, forKey: "position");
    } //F.E.
    
    /// Rempves all views from the view
    public func removeAllSubviews() {
        for view in self.subviews {
            view.removeFromSuperview();
        }
    } //F.E.
    
} //E.E.
