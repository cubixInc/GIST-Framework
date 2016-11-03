//
//  BaseCollectionViewCell.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 14/06/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit

open class BaseUICollectionViewCell: UICollectionViewCell, BaseView {
    fileprivate var _data:Any?
    open var data:Any? {
        get {
            return _data;
        }
        
        set {
            _data = newValue;
        }
    } //P.E.
    
    override open func awakeFromNib() {
        super.awakeFromNib()
    } //F.E.
    
    open func updateData(_ data:Any?) {
        _data = data;
        //--
        self.updateSyncedData();
    } //F.E.
    
    open func updateView() {
        //DOING NOTHING FOR NOW
    } //F.E.
    
    override open func updateSyncedData() {
        super.updateSyncedData();
        //--
        self.contentView.updateSyncedData();
    } //F.E.
} //CLS END
