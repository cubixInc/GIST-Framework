//
//  GradientUtility.swift
//  GistDev
//
//  Created by Shoaib on 2/5/18.
//  Copyright © 2018 Social Cubix. All rights reserved.
//

import UIKit

public extension UIView {
    
    func applyGradient(_ colors:[UIColor], type:GradientType, locations:[NSNumber]? = nil) -> CAGradientLayer{
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        
        gradientLayer.colors = colors.map { (c) -> CGColor in
            return c.cgColor
        }
        
        gradientLayer.setGradient(type);
        gradientLayer.locations = locations;
        
        self.layer.insertSublayer(gradientLayer, at: 0);
        
        return gradientLayer;
    } //F.E.
    
    
} //F.E.

public extension CAGradientLayer {
    
    func setGradient(_ type:GradientType) {
        let points = type.points();
        
        self.startPoint = points.start;
        self.endPoint = points.end;
    } //F.E.
    
} //E.E.

public enum GradientType {
    case leftRight
    case rightLeft
    case topBottom
    case bottomTop
    case topLeftBottomRight
    case bottomRightTopLeft
    case topRightBottomLeft
    case bottomLeftTopRight
    
    fileprivate func points() -> (start: CGPoint, end: CGPoint) {
        switch self {
        case .leftRight:
            return (start: CGPoint(x: 0, y: 0.5), end: CGPoint(x: 1, y: 0.5))
        case .rightLeft:
            return (start: CGPoint(x: 1, y: 0.5), end: CGPoint(x: 0, y: 0.5))
        case .topBottom:
            return (start: CGPoint(x: 0.5, y: 0), end: CGPoint(x: 0.5, y: 1))
        case .bottomTop:
            return (start: CGPoint(x: 0.5, y: 1), end: CGPoint(x: 0.5, y: 0))
        case .topLeftBottomRight:
            return (start: CGPoint(x: 0, y: 0), end: CGPoint(x: 1, y: 1))
        case .bottomRightTopLeft:
            return (start: CGPoint(x: 1, y: 1), end: CGPoint(x: 0, y: 0))
        case .topRightBottomLeft:
            return (start: CGPoint(x: 1, y: 0), end: CGPoint(x: 0, y: 1))
        case .bottomLeftTopRight:
            return (start: CGPoint(x: 0, y: 1), end: CGPoint(x: 1, y: 0))
        }
    }
    
    public  static func gradientType(for type:String) -> GradientType {
        switch type {
        case "leftRight":
            return .leftRight
        case "rightLeft":
            return .rightLeft
        case "topBottom":
            return .topBottom
        case "bottomTop":
            return .bottomTop
        case "topLeftBottomRight":
            return .topLeftBottomRight
        case "bottomRightTopLeft":
            return .bottomRightTopLeft
        case "topRightBottomLeft":
            return .topRightBottomLeft
        case "bottomLeftTopRight":
            return .bottomLeftTopRight
        default:
            return .leftRight
        }
        
    } //F.E.
} //E.E.


