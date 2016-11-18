//
//  BaseUISegmentedControl.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 14/06/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit

open class BaseUISegmentedControl: UISegmentedControl, BaseView {

    @IBInspectable open var sizeForIPad:Bool = false;
    
    @IBInspectable open var bgColorStyle:String? = nil {
        didSet {
            self.backgroundColor = SyncedColors.color(forKey: bgColorStyle);
        }
    }
    
    @IBInspectable open var tintColorStyle:String? {
        didSet {
            self.tintColor = SyncedColors.color(forKey: tintColorStyle);
        }
    }
    
    @IBInspectable open var fontName:String = "fontRegular" {
        didSet {
            self.font = UIFont.font(fontName, fontStyle: fontStyle, sizedForIPad: self.sizeForIPad);
        }
    }
    
    @IBInspectable open var fontStyle:String = "medium" {
        didSet {
            self.font = UIFont.font(fontName, fontStyle: fontStyle, sizedForIPad: self.sizeForIPad);
        }
    }
    
    open var font:UIFont? = nil {
        didSet {
            self.setTitleTextAttributes([NSFontAttributeName:self.font!], for: UIControlState());
        }
    };

    private var _titleKeys:[Int:String] = [Int:String]();
    
    
    /// Overridden constructor to setup/ initialize components.
    ///
    /// - Parameter items: Segment Items
    public override init(items: [Any]?) {
        super.init(items: items);
        //--
        self.commontInit();
    }
    
    /// Overridden constructor to setup/ initialize components.
    ///
    /// - Parameter frame: View frame
    public override init(frame: CGRect) {
        super.init(frame: frame);
        //--
        self.commontInit();
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    /// Overridden method to setup/ initialize components.
    override open func awakeFromNib() {
        super.awakeFromNib();
        //--
        self.commontInit();
    } //F.E.
    
    /// Common initazier for setting up items.
    private func commontInit() {
        self.font = UIFont.font(fontName, fontStyle: fontStyle, sizedForIPad: self.sizeForIPad);
        
        for i:Int in 0..<numberOfSegments {
            if let txt:String = titleForSegment(at: i) , txt.hasPrefix("#") == true {
                self.setTitle(txt, forSegmentAt: i); // Assigning again to set value from synced data
            }
        }
    } //F.E.
    
    /// Updates layout and contents from SyncEngine. this is a protocol method BaseView that is called when the view is refreshed.
    public func updateView(){
        if let bColorStyle = self.bgColorStyle {
            self.bgColorStyle = bColorStyle;
        }
        
        if let tColorStyle =  self.tintColorStyle {
            self.tintColorStyle = tColorStyle;
        }
        
        for i:Int in 0..<numberOfSegments {
            if let key:String = _titleKeys[i] {
                self.setTitle(key, forSegmentAt: i);
            }
        }
    } //F.E.
    
    override open func setTitle(_ title: String?, forSegmentAt segment: Int) {
        if let key:String = title , key.hasPrefix("#") == true {
            //--
            _titleKeys[segment] = key;  // holding key for using later
            super.setTitle(SyncedText.text(forKey: key), forSegmentAt: segment);
        } else {
            super.setTitle(title, forSegmentAt: segment);
        }
    } //P.E.
    
} //CLS END
