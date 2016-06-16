//
//  BaseUISegmentedControl.swift
//  eGrocery
//
//  Created by Shoaib on 2/25/15.
//  Copyright (c) 2015 cubixlabs. All rights reserved.
//

import UIKit

class BaseUISegmentedControl: UISegmentedControl, BaseView {

    @IBInspectable var bgColorStyle:String! = nil;
    
    @IBInspectable var tintColorStyle:String! = nil;

    private var _titleKeys:[Int:String] = [Int:String]();
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //--
        self.updateView()
    } //F.E.
    
    func updateView(){
        if (tintColorStyle != nil) {
            self.tintColor = SyncedColors.color(forKey: tintColorStyle);
        }
        
        if (bgColorStyle != nil) {
            self.backgroundColor = SyncedColors.color(forKey: bgColorStyle);
        }
        
        for i:Int in 0..<numberOfSegments {
            if let txt:String = titleForSegmentAtIndex(i) where txt.hasPrefix("#") == true {
                self.setTitle(txt, forSegmentAtIndex: i); // Assigning again to set value from synced data
            } else if let key:String = _titleKeys[i] {
                self.setTitle(key, forSegmentAtIndex: i);
            }
        }
    } //F.E.
    
    override func setTitle(title: String?, forSegmentAtIndex segment: Int) {
        if let key:String = title where key.hasPrefix("#") == true {
            //--
            _titleKeys[segment] = key;  // holding key for using later
            super.setTitle(SyncedText.text(forKey: key), forSegmentAtIndex: segment);
        } else {
            super.setTitle(title, forSegmentAtIndex: segment);
        }
    } //P.E.
    
} //F.E.
