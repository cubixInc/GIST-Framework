//
//  BaseUISegmentedControl.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 14/06/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit

public class BaseUISegmentedControl: UISegmentedControl, BaseView {

    @IBInspectable public var bgColorStyle:String! = nil;
    
    @IBInspectable public var tintColorStyle:String! = nil;

    private var _titleKeys:[Int:String] = [Int:String]();
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        //--
        self.updateView()
    } //F.E.
    
    public func updateView(){
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
    
    override public func setTitle(title: String?, forSegmentAtIndex segment: Int) {
        if let key:String = title where key.hasPrefix("#") == true {
            //--
            _titleKeys[segment] = key;  // holding key for using later
            super.setTitle(SyncedText.text(forKey: key), forSegmentAtIndex: segment);
        } else {
            super.setTitle(title, forSegmentAtIndex: segment);
        }
    } //P.E.
    
} //CLS END
