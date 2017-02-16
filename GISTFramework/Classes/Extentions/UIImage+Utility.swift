//
//  UIImageExtension.swift
//  GISTFramework
//
//  Created by Alizain on 23/05/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//


import Foundation
import UIKit

// MARK: - UIImage extention for Utility methods and property
public extension UIImage {
    
    /// Scaling image with image size and ratating image to identity if orientation is other than UIImageOrientation.up
    ///
    /// - Parameter maxSize: Maximum Image Size
    /// - Returns: Resized and Ratated UIImage
    public func scaleAndRotateImage(_ maxSize: CGFloat) -> UIImage {
        
        let imgRef = self.cgImage!
        
        let width = CGFloat(imgRef.width)
        let height = CGFloat(imgRef.height)
        var transform = CGAffineTransform.identity
        var bounds = CGRect(x: 0, y: 0, width: width, height: height)
        
        if width > maxSize || height < maxSize {
            let ratio = width / height
            
            if ratio > 1 {
                bounds.size.width = maxSize
                bounds.size.height = bounds.size.width / ratio
            } else {
                bounds.size.height = maxSize
                bounds.size.width = bounds.size.height * ratio
            }
        }
        
        let scaleRatio = bounds.size.width / width
        let imageSize = CGSize(width: width, height: height)
        var boundHeight : CGFloat = 0.0
        
        let ori = self.imageOrientation
        
        switch(ori) {
        case .up:
            transform = CGAffineTransform.identity
            break
            
        case .down:
            transform = CGAffineTransform(translationX: imageSize.width, y: imageSize.height)
            transform = transform.rotated(by: CGFloat(M_PI))
            break
            
        case .left:
            boundHeight = bounds.size.height
            bounds.size.height = bounds.size.width
            bounds.size.width = boundHeight
            transform = CGAffineTransform(translationX: 0.0, y: imageSize.width)
            transform = transform.rotated(by: CGFloat(3.0 * M_PI / 2.0))
            break
            
        case .right:
            boundHeight = bounds.size.height
            bounds.size.height = bounds.size.width
            bounds.size.width = boundHeight
            transform = CGAffineTransform(translationX: imageSize.height, y: 0.0)
            transform = transform.rotated(by: CGFloat(M_PI / 2.0))
            break
            
        case .upMirrored:
            transform = CGAffineTransform(translationX: imageSize.width, y: 0.0)
            transform = transform.scaledBy(x: -1.0, y: -1.0)
            break
            
        case .downMirrored:
            transform = CGAffineTransform(translationX: 0.0, y: imageSize.height)
            transform = transform.scaledBy(x: 1.0, y: -1.0)
            break
            
        case .leftMirrored:
            boundHeight = bounds.size.height
            bounds.size.height = bounds.size.width
            bounds.size.width = boundHeight
            transform = CGAffineTransform(translationX: imageSize.height, y: imageSize.width)
            transform = transform.scaledBy(x: -1.0, y: 1.0)
            transform = transform.rotated(by: CGFloat(3.0 * M_PI / 2.0))
            break
            
        case .rightMirrored:
            boundHeight = bounds.size.height
            bounds.size.height = bounds.size.width
            bounds.size.width = boundHeight
            transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            transform = transform.rotated(by: CGFloat(M_PI / 2.0))
            break
        }
        
        UIGraphicsBeginImageContext(bounds.size)
        let context = UIGraphicsGetCurrentContext()
        
        if ori == UIImageOrientation.right || ori == UIImageOrientation.left {
            context!.scaleBy(x: -scaleRatio, y: scaleRatio)
            context!.translateBy(x: -height, y: 0.0)
        } else {
            context!.scaleBy(x: scaleRatio, y: -scaleRatio)
            context!.translateBy(x: 0.0, y: -height)
        }
        
        context!.concatenate(transform)
        UIGraphicsGetCurrentContext()!.draw(imgRef, in: CGRect(x: 0, y: 0, width: width, height: height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    } //F.E.
    
    
    /// Mirroring the Image
    ///
    /// - Returns: mirrored image
    public func mirrored() -> UIImage {
        return UIImage(cgImage: self.cgImage!, scale:self.scale , orientation: UIImageOrientation.upMirrored)
    } //F.E.
} //CLS END
