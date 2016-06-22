//
//  BaseCollectionViewCell.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 14/06/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit

public class BaseUICollectionViewCell: UICollectionViewCell, BaseView {
    private var _data:AnyObject?
    public var data:AnyObject? {
        get {
            return _data;
        }
        
        set {
            _data = newValue;
        }
    } //P.E.
    
    override public func awakeFromNib() {
        super.awakeFromNib()
    } //F.E.
    
    public func updateData(data:AnyObject?) {
        _data = data;
        //--
        self.updateSyncedData();
    } //F.E.
    
    public func updateView() {
        //DOING NOTHING FOR NOW
    } //F.E.
    
    override public func updateSyncedData() {
        super.updateSyncedData();
        //--
        self.contentView.updateSyncedData();
    } //F.E.
} //CLS END
