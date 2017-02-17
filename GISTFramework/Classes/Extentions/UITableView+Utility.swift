//
//  UITableView+Fade.swift
//  GISTFramework
//
//  Created by Shoaib on 5/18/15.
//  Copyright (c) 2015 Social Cubix. All rights reserved.
//

import UIKit

// MARK: - UITableView extension for Utility Method
public extension UITableView {
    public func reloadData(_ animated:Bool, completion:(()->Void)? = nil) {
        if (animated) {
            self.fadeOut({ (finished) -> () in
                self.reloadData();
                 
                self.fadeIn();
                 
                completion?();
            })
        } else {
            self.reloadData();
             
            completion?();
        }
    } //F.E.
    
    public func scrollToBottom(_ animated: Bool = true) {
        
        let delay = 0.1 * Double(NSEC_PER_SEC)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            let numberOfSections = self.numberOfSections
            let numberOfRows = self.numberOfRows(inSection: numberOfSections-1)
            
            if numberOfRows > 0 {
                let indexPath = IndexPath(row: numberOfRows-1, section: (numberOfSections-1));
                
                self.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: animated)
            }
        }
    } //F.E.
    
    public func scrollToTop(_ animated: Bool = true) {
        self.setContentOffset(CGPoint.zero, animated: animated);
    } //F.E.
    
} //E.E.
