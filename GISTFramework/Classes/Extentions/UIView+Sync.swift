//
//  UIView+Sync.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 08/05/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit

// MARK: - UIView Extension for Sync Engine to update layout at runtime.
extension UIView {
    
    /// Recursive update of layout and content from Sync Engine.
    func updateSyncedData() {
        (self as? BaseView)?.updateView();
         
        for viw in self.subviews{
            (viw as? BaseView)?.updateView();
             
            if let tblViw:UITableView =  viw as? UITableView {
                tblViw.reloadData();
            }
            
            if let colViw:UICollectionView =  viw as? UICollectionView {
                colViw.reloadData();
            }
        }
    } //F.E.
} //E.E.
