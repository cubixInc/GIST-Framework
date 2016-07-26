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
    
    public func scrollToBottom(animated: Bool = true) {
        let sections = self.numberOfSections
        let rows = self.numberOfRowsInSection(sections - 1)
        self.scrollToRowAtIndexPath(NSIndexPath(forRow: rows - 1, inSection: sections - 1), atScrollPosition: .Bottom, animated: true)
    } //F.E.
    
    public func scrollToTop(animated: Bool = true) {
        self.setContentOffset(CGPoint.zero, animated: true);
    } //F.E.
    
    
} //E.E.
