//
//  UIImageExtension.swift
//  GISTFramework
//
//  Created by Alizain on 23/05/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//


import Foundation
import UIKit

public extension UIImage {
    
    public func scaleAndRotateImage(maxSize: CGFloat) -> UIImage {
        
        let imgRef = self.CGImage!
        
        let width = CGFloat(CGImageGetWidth(imgRef))
        let height = CGFloat(CGImageGetHeight(imgRef))
        var transform = CGAffineTransformIdentity
        var bounds = CGRectMake(0, 0, width, height)
        
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
        let imageSize = CGSizeMake(width, height)
        var boundHeight : CGFloat = 0.0
        
        let ori = self.imageOrientation
        
        switch(ori) {
        case .Up:
            transform = CGAffineTransformIdentity
            break
            
        case .Down:
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height)
            transform = CGAffineTransformRotate(transform, CGFloat(M_PI))
            break
            
        case .Left:
            boundHeight = bounds.size.height
            bounds.size.height = bounds.size.width
            bounds.size.width = boundHeight
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width)
            transform = CGAffineTransformRotate(transform, CGFloat(3.0 * M_PI / 2.0))
            break
            
        case .Right:
            boundHeight = bounds.size.height
            bounds.size.height = bounds.size.width
            bounds.size.width = boundHeight
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0)
            transform = CGAffineTransformRotate(transform, CGFloat(M_PI / 2.0))
            break
            
        case .UpMirrored:
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0)
            transform = CGAffineTransformScale(transform, -1.0, -1.0)
            break
            
        case .DownMirrored:
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height)
            transform = CGAffineTransformScale(transform, 1.0, -1.0)
            break
            
        case .LeftMirrored:
            boundHeight = bounds.size.height
            bounds.size.height = bounds.size.width
            bounds.size.width = boundHeight
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width)
            transform = CGAffineTransformScale(transform, -1.0, 1.0)
            transform = CGAffineTransformRotate(transform, CGFloat(3.0 * M_PI / 2.0))
            break
            
        case .RightMirrored:
            boundHeight = bounds.size.height
            bounds.size.height = bounds.size.width
            bounds.size.width = boundHeight
            transform = CGAffineTransformMakeScale(-1.0, 1.0)
            transform = CGAffineTransformRotate(transform, CGFloat(M_PI / 2.0))
            break
        }
        
        UIGraphicsBeginImageContext(bounds.size)
        let context = UIGraphicsGetCurrentContext()
        
        if ori == UIImageOrientation.Right || ori == UIImageOrientation.Left {
            CGContextScaleCTM(context!, -scaleRatio, scaleRatio)
            CGContextTranslateCTM(context!, -height, 0.0)
        } else {
            CGContextScaleCTM(context!, scaleRatio, -scaleRatio)
            CGContextTranslateCTM(context!, 0.0, -height)
        }
        
        CGContextConcatCTM(context!, transform)
        CGContextDrawImage(UIGraphicsGetCurrentContext()!, CGRectMake(0, 0, width, height), imgRef)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    } //F.E.
} //CLS END
