//
//  UITableView+Fade.swift
//  GISTFramework
//
//  Created by Shoaib on 5/18/15.
//  Copyright (c) 2015 Social Cubix. All rights reserved.
//

import UIKit

public extension UITableView {
    public func reloadData(animated:Bool, completion:(()->Void)? = nil) {
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
    
    public func scrollToBottom(animated: Bool = true) {
        
        let numOfSections = self.numberOfSections;
        guard (self.numberOfSections != 0) else {
            return;
        }
        
        let numOfRows = self.numberOfRowsInSection(self.numberOfSections - 1);
        guard (numOfRows != 0) else {
            return;
        }
        
        self.scrollToRowAtIndexPath(NSIndexPath(forRow: numOfRows - 1, inSection: numOfSections - 1), atScrollPosition: .Bottom, animated: animated)
    } //F.E.
    
    public func scrollToTop(animated: Bool = true) {
        self.setContentOffset(CGPoint.zero, animated: animated);
    } //F.E.
    
} //E.E.
