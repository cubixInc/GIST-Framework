//
//  UITableView+Fade.swift
//  eGrocery
//
//  Created by Shoaib on 5/18/15.
//  Copyright (c) 2015 cubixlabs. All rights reserved.
//

import UIKit

public extension UITableView {
    public func reloadData(animated:Bool, completion:(()->Void)? = nil)
    {
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
} //E.E.
