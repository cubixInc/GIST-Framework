//
//  BaseUISegmentedControl.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 14/06/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit

public class BaseUISegmentedControl: UISegmentedControl, BaseView {

    @IBInspectable public var bgColorStyle:String? = nil {
        didSet {
            self.backgroundColor = SyncedColors.color(forKey: bgColorStyle);
        }
    }
    
    @IBInspectable public var tintColorStyle:String? {
        didSet {
            self.tintColor = SyncedColors.color(forKey: tintColorStyle);
        }
    }

    private var _titleKeys:[Int:String] = [Int:String]();
    
    public override init(items: [AnyObject]?) {
        super.init(items: items);
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame);
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib();
    } //F.E.
    
    private func commontInit() {
        for i:Int in 0..<numberOfSegments {
            if let txt:String = titleForSegmentAtIndex(i) where txt.hasPrefix("#") == true {
                self.setTitle(txt, forSegmentAtIndex: i); // Assigning again to set value from synced data
            }
        }
    } //F.E.
    
    public func updateView(){
        if let bColorStyle = self.bgColorStyle {
            self.bgColorStyle = bColorStyle;
        }
        
        if let tColorStyle =  self.tintColorStyle {
            self.tintColorStyle = tColorStyle;
        }
        
        for i:Int in 0..<numberOfSegments {
            if let key:String = _titleKeys[i] {
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
