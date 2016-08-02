//
//  BaseTableViewCell.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 14/06/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit

public class BaseUITableViewCell: UITableViewCell, BaseView {

    private var _data:AnyObject?
    public var data:AnyObject? {
        get {
            return _data;
        }
        
        set {
            _data = newValue;
        }
    } //P.E.
    
    public lazy var seperatorView:UIView = {
        let sView = UIView(frame: self.seperatorFrame);
        sView.hidden = true;
        self.addSubview(sView);
        return sView;
    }()
    
    @IBInspectable public var bgColorStyle:String? = nil {
        didSet {
            self.backgroundColor = SyncedColors.color(forKey: bgColorStyle);
        }
    }
    
    public var seperatorFrame:CGRect {
        get  {
            return CGRectMake(0, (seperatorOnTop ? 0:self.frame.size.height - 0.5), self.frame.size.width, 0.5);
        }
    } //P.E.
    
    @IBInspectable public var hasSeperator:Bool {
        get {
            return !self.seperatorView.hidden;
        }
        
        set {
            self.seperatorView.hidden = !newValue;
        }
    } //P.E.
    
    @IBInspectable public var seperatorColorStyle:String? = nil {
        didSet {
            self.seperatorView.backgroundColor = SyncedColors.color(forKey: seperatorColorStyle);
        }
    } //P.E.
    
    @IBInspectable public var seperatorOnTop:Bool = false {
        didSet {
            self.seperatorView.frame = self.seperatorFrame;
        }
    }
    
    @IBInspectable public var fontName:String? = "fontRegular" {
        didSet {
            self.textLabel?.font = UIFont.font(self.fontName, fontStyle: self.fontTitleStyle, sizedForIPad: sizeForIPad);
            
            self.detailTextLabel?.font = UIFont.font(self.fontName, fontStyle: self.fontDetailStyle, sizedForIPad: sizeForIPad);
        }
    }
    
    @IBInspectable public var fontTitleStyle:String? = "medium" {
        didSet {
            self.textLabel?.font = UIFont.font(self.fontName, fontStyle: self.fontTitleStyle, sizedForIPad: sizeForIPad);
        }
    }
    
    @IBInspectable public var fontDetailStyle:String? = "fontRegular" {
        didSet {
            self.detailTextLabel?.font = UIFont.font(self.fontName, fontStyle: self.fontDetailStyle, sizedForIPad: sizeForIPad);
        }
    }
    
    @IBInspectable public var fontColor:String? = nil {
        didSet {
            self.textLabel?.textColor = UIColor.color(forKey: fontColor);
        }
    }
    
    @IBInspectable public var detailColor:String? = nil {
        didSet {
            self.detailTextLabel?.textColor = UIColor.color(forKey: detailColor);
        }
    }
    
    @IBInspectable public var sizeForIPad:Bool = false;
    
    public convenience init(reuseIdentifier: String?) {
        self.init(style: UITableViewCellStyle.Default, reuseIdentifier: reuseIdentifier);
    } //F.E.
    
    override public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier);
        //--
        self.selectionStyle = UITableViewCellSelectionStyle.None;
        //--
        self.commonInitializer();
    } //F.E.
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder);
    } //F.E.
    
    override public func awakeFromNib() {
        super.awakeFromNib();
        //--
        self.commonInitializer();
    } //F.E.
    
    override public func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated);
    } //F.E.
    
    private func commonInitializer() {
        self.selectionStyle = UITableViewCellSelectionStyle.None;
        //--
        self.contentView.backgroundColor  = UIColor.clearColor();
        
        self.textLabel?.font = UIFont.font(self.fontName, fontStyle: self.fontTitleStyle, sizedForIPad: sizeForIPad);
        
        self.detailTextLabel?.font = UIFont.font(self.fontName, fontStyle: self.fontDetailStyle, sizedForIPad: sizeForIPad);
    } //F.E.
    
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
    
    override public func updateSyncedData() {
        super.updateSyncedData();
        //--
        self.contentView.updateSyncedData();
    } //F.E.
    
    override public func layoutSubviews() {
        super.layoutSubviews();
        //--
        self.seperatorView.frame = self.seperatorFrame;
    } //F.E.
    
    public func updateData(data:AnyObject?) {
        _data = data;
        //--
        self.updateSyncedData();
    } //F.E.

} //CLS END
