//
//  UICollectionViewExtension.swift
//  FoodHunch
//
//  Created by Alizain on 23/05/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit

extension UICollectionViewController: UIViewControllerPreviewingDelegate {
    public func previewingContext(previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        return nil;
    }
    
    public func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {
        
    }
}
