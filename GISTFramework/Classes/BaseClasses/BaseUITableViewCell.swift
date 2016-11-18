//
//  BaseTableViewCell.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 14/06/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit

open class BaseUITableViewCell: UITableViewCell, BaseView {

    private var _data:Any?
    open var data:Any? {
        get {
            return _data;
        }
    } //P.E.
    
    open lazy var seperatorView:UIView = {
        let sView = UIView(frame: self.seperatorFrame);
        sView.isHidden = true;
        sView.backgroundColor = UIColor.lightGray;
        self.addSubview(sView);
        return sView;
    }()
    
    @IBInspectable open var bgColorStyle:String? = nil {
        didSet {
            guard (self.bgColorStyle != oldValue) else {
                return;
            }
            //--
            self.backgroundColor = SyncedColors.color(forKey: bgColorStyle);
        }
    }
    
    open var seperatorFrame:CGRect {
        get  {
            return CGRect(x: 0, y: (seperatorOnTop ? 0:self.frame.size.height - 0.5), width: self.frame.size.width, height: 0.5);
        }
    } //P.E.
    
    @IBInspectable open var hasSeperator:Bool {
        get {
            return !self.seperatorView.isHidden;
        }
        
        set {
            self.seperatorView.isHidden = !newValue;
        }
    } //P.E.
    
    @IBInspectable open var seperatorColorStyle:String? = nil {
        didSet {
            guard (self.seperatorColorStyle != oldValue) else {
                return;
            }
            //--
            self.seperatorView.backgroundColor = SyncedColors.color(forKey: seperatorColorStyle);
        }
    } //P.E.
    
    @IBInspectable open var seperatorOnTop:Bool = false {
        didSet {
            self.seperatorView.frame = self.seperatorFrame;
        }
    }
    
    @IBInspectable open var fontName:String? = "fontRegular" {
        didSet {
            guard (self.fontName != oldValue) else {
                return;
            }
            //--
            self.textLabel?.font = UIFont.font(self.fontName, fontStyle: self.fontTitleStyle, sizedForIPad: sizeForIPad);
            
            self.detailTextLabel?.font = UIFont.font(self.fontName, fontStyle: self.fontDetailStyle, sizedForIPad: sizeForIPad);
        }
    }
    
    @IBInspectable open var fontTitleStyle:String? = "medium" {
        didSet {
            guard (self.fontTitleStyle != oldValue) else {
                return;
            }
            //--
            self.textLabel?.font = UIFont.font(self.fontName, fontStyle: self.fontTitleStyle, sizedForIPad: sizeForIPad);
        }
    }
    
    @IBInspectable open var fontDetailStyle:String? = "fontRegular" {
        didSet {
            guard (self.fontDetailStyle != oldValue) else {
                return;
            }
            //--
            self.detailTextLabel?.font = UIFont.font(self.fontName, fontStyle: self.fontDetailStyle, sizedForIPad: sizeForIPad);
        }
    }
    
    @IBInspectable open var fontColor:String? = nil {
        didSet {
            guard (self.fontColor != oldValue) else {
                return;
            }
            //--
            self.textLabel?.textColor = UIColor.color(forKey: fontColor);
        }
    }
    
    @IBInspectable open var detailColor:String? = nil {
        didSet {
            guard (self.detailColor != oldValue) else {
                return;
            }
            //--
            self.detailTextLabel?.textColor = UIColor.color(forKey: detailColor);
        }
    }
    
    @IBInspectable open var sizeForIPad:Bool = false;
    
    public convenience init(reuseIdentifier: String?) {
        self.init(style: UITableViewCellStyle.default, reuseIdentifier: reuseIdentifier);
    } //F.E.
    
    override public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier);
        //--
        self.selectionStyle = UITableViewCellSelectionStyle.none;
        //--
        self.commonInit();
    } //F.E.
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder);
    } //F.E.
    
    /// Overridden method to setup/ initialize components.
    override open func awakeFromNib() {
        super.awakeFromNib();
        //--
        self.commonInit();
    } //F.E.
    
    override open func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated);
    } //F.E.
    
    /// A common initializer for sub components.
    private func commonInit() {
        self.selectionStyle = UITableViewCellSelectionStyle.none;
        //--
        self.contentView.backgroundColor  = UIColor.clear;
        
        self.textLabel?.font = UIFont.font(self.fontName, fontStyle: self.fontTitleStyle, sizedForIPad: sizeForIPad);
        
        self.detailTextLabel?.font = UIFont.font(self.fontName, fontStyle: self.fontDetailStyle, sizedForIPad: sizeForIPad);
    } //F.E.
    
    /// Updates layout and contents from SyncEngine. this is a protocol method BaseView that is called when the view is refreshed.
    public func updateView() {
        if let bgCStyle = self.bgColorStyle {
            self.bgColorStyle = bgCStyle;
        }
        
        if let sepColorStyle = self.seperatorColorStyle {
            self.seperatorColorStyle = sepColorStyle;
        }
        
        if let fName = self.fontName {
            self.fontName = fName;
        }
        
        if let fColor = self.fontColor {
            self.fontColor = fColor;
        }
        
        if let dColor = self.detailColor {
            self.detailColor = dColor;
        }
    } //F.E.
    
    /// Recursive update of layout and content from Sync Engine.
    override func updateSyncedData() {
        super.updateSyncedData();
        //--
        self.contentView.updateSyncedData();
    } //F.E.
    
    /// Overridden methed to update layout.
    override open func layoutSubviews() {
        super.layoutSubviews();
        //--
        self.seperatorView.frame = self.seperatorFrame;
    } //F.E.
    
    open func updateData(_ data:Any?) {
        _data = data;
        //--
        self.updateSyncedData();
    } //F.E.

} //CLS END
