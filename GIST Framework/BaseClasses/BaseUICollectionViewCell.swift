//
//  BaseCollectionViewCell.swift
//  eGrocery
//
//  Created by Shoaib on 4/20/15.
//  Copyright (c) 2015 cubixlabs. All rights reserved.
//

import UIKit

class BaseUICollectionViewCell: UICollectionViewCell, BaseView {
    private var _data:AnyObject?
    var data:AnyObject? {
        get {
            return _data;
        }
        
        set {
            _data = newValue;
        }
    } //P.E.
    
    override func awakeFromNib() {
        super.awakeFromNib()
    } //F.E.
    
    func updateData(data:AnyObject?) {
        _data = data;
        //--
        self.updateSyncedData();
    } //F.E.
    
    func updateView() {
        //DOING NOTHING FOR NOW
    } //F.E.
    
    override func updateSyncedData() {
        super.updateSyncedData();
        //--
        self.contentView.updateSyncedData();
    } //F.E.
} //CLS END
