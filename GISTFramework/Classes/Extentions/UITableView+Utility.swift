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
                //--
                self.fadeIn();
                //--
                completion?();
            })
        } else {
            self.reloadData();
            //--
            completion?();
        }
    } //F.E.
    
    public func scrollToBottom(_ animated: Bool = true) {
        
        let numOfSections = self.numberOfSections;
        guard (self.numberOfSections != 0) else {
            return;
        }
        
        let numOfRows = self.numberOfRows(inSection: self.numberOfSections - 1);
        guard (numOfRows != 0) else {
            return;
        }
        
        self.scrollToRow(at: IndexPath(row: numOfRows - 1, section: numOfSections - 1), at: .bottom, animated: true)
    } //F.E.
    
    public func scrollToTop(_ animated: Bool = true) {
        self.setContentOffset(CGPoint.zero, animated: true);
    } //F.E.
    
} //E.E.
