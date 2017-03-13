//
//  BaseUISegmentedControl.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 14/06/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit

/// BaseUISegmentedControl is a subclass of UISegmentedControl and implements BaseView. It has some extra proporties and support for SyncEngine.
open class BaseUISegmentedControl: UISegmentedControl, BaseView {
    
    //MARK: - Properties
    
    /// Flag for whether to resize the values for iPad.
    @IBInspectable open var sizeForIPad:Bool = GIST_CONFIG.sizeForIPad;
    
    /// Background color key from Sync Engine.
    @IBInspectable open var bgColorStyle:String? = nil {
        didSet {
            self.backgroundColor = SyncedColors.color(forKey: bgColorStyle);
        }
    }
    
    /// Navigation tint Color key from SyncEngine.
    @IBInspectable open var tintColorStyle:String? {
        didSet {
            self.tintColor = SyncedColors.color(forKey: tintColorStyle);
        }
    }
    
    /// Font name key from Sync Engine.
    @IBInspectable open var fontName:String = GIST_CONFIG.fontName {
        didSet {
            self.font = UIFont.font(fontName, fontStyle: fontStyle, sizedForIPad: self.sizeForIPad);
        }
    }
    
    /// Font size/style key from Sync Engine.
    @IBInspectable open var fontStyle:String = GIST_CONFIG.fontStyle {
        didSet {
            self.font = UIFont.font(fontName, fontStyle: fontStyle, sizedForIPad: self.sizeForIPad);
        }
    }
    
    /// Extended proprty font for Segmented Controler Items
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
         
        self.commontInit();
    }
    
    /// Overridden constructor to setup/ initialize components.
    ///
    /// - Parameter frame: View frame
    public override init(frame: CGRect) {
        super.init(frame: frame);
         
        self.commontInit();
    }
    
    /// Required constructor implemented.
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    /// Overridden method to setup/ initialize components.
    override open func awakeFromNib() {
        super.awakeFromNib();
         
        self.commontInit();
    } //F.E.
    
    /// Overridden method to set title using Sync Engine key (Hint '#').
    ///
    /// - Parameters:
    ///   - title: Segment Title
    ///   - segment: Segment Index
    override open func setTitle(_ title: String?, forSegmentAt segment: Int) {
        if let key:String = title , key.hasPrefix("#") == true {
             
            _titleKeys[segment] = key;  // holding key for using later
            super.setTitle(SyncedText.text(forKey: key), forSegmentAt: segment);
        } else {
            super.setTitle(title, forSegmentAt: segment);
        }
    } //P.E.
    
    //MARK: - Methods
    
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
    func updateView(){
        
        //Re-assigning if there are any changes from server
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
    
} //CLS END
