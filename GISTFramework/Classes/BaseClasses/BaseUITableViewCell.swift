//
//  BaseTableViewCell.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 14/06/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit

/// BaseUITableViewCell is a subclass of UITableViewCell and implements BaseView. It has some extra proporties and support for SyncEngine.
open class BaseUITableViewCell: UITableViewCell, BaseView {

    //MARK: - Properties
    
    /// Flag for whether to resize the values for iPad.
    @IBInspectable open var sizeForIPad:Bool = GIST_CONFIG.sizeForIPad;
    
    /// Background color key from SyncEngine.
    @IBInspectable open var bgColorStyle:String? = nil {
        didSet {
            guard (self.bgColorStyle != oldValue) else {
                return;
            }
             
            self.backgroundColor = SyncedColors.color(forKey: bgColorStyle);
        }
    }
    
    // Calculated seperator frame Rect - Overridable
    open var seperatorFrame:CGRect {
        get  {
            return CGRect(x: 0, y: (seperatorOnTop ? 0:self.frame.size.height - 0.5), width: self.frame.size.width, height: 0.5);
        }
    } //P.E.
    
    /// Flag for showing seperator
    @IBInspectable open var hasSeperator:Bool {
        get {
            return !self.seperatorView.isHidden;
        }
        
        set {
            self.seperatorView.isHidden = !newValue;
        }
    } //P.E.
    
    /// Seperator Color key from SyncEngine.
    @IBInspectable open var seperatorColorStyle:String? = nil {
        didSet {
            guard (self.seperatorColorStyle != oldValue) else {
                return;
            }
             
            self.seperatorView.backgroundColor = SyncedColors.color(forKey: seperatorColorStyle);
        }
    } //P.E.
    
    /// Flag for showing seperator on the top.
    @IBInspectable open var seperatorOnTop:Bool = false {
        didSet {
            self.seperatorView.frame = self.seperatorFrame;
        }
    }
    
    /// Font name key from Sync Engine.
    @IBInspectable open var fontName:String? = GIST_CONFIG.fontName {
        didSet {
            guard (self.fontName != oldValue) else {
                return;
            }
             
            self.textLabel?.font = UIFont.font(self.fontName, fontStyle: self.fontStyle, sizedForIPad: sizeForIPad);
            
            self.detailTextLabel?.font = UIFont.font(self.fontName, fontStyle: self.fontDetailStyle, sizedForIPad: sizeForIPad);
        }
    }
    
    /// Font size/ style key from Sync Engine.
    @IBInspectable open var fontStyle:String? = GIST_CONFIG.fontStyle {
        didSet {
            guard (self.fontStyle != oldValue) else {
                return;
            }
             
            self.textLabel?.font = UIFont.font(self.fontName, fontStyle: self.fontStyle, sizedForIPad: sizeForIPad);
        }
    }
    
    /// Detail text font name key from SyncEngine.
    @IBInspectable open var fontDetailStyle:String? = GIST_CONFIG.fontStyle {
        didSet {
            guard (self.fontDetailStyle != oldValue) else {
                return;
            }
             
            self.detailTextLabel?.font = UIFont.font(self.fontName, fontStyle: self.fontDetailStyle, sizedForIPad: sizeForIPad);
        }
    }
    
    
    /// Font Color key from SyncEngine.
    @IBInspectable open var fontColor:String? = nil {
        didSet {
            guard (self.fontColor != oldValue) else {
                return;
            }
             
            self.textLabel?.textColor = UIColor.color(forKey: fontColor);
        }
    }
    
    /// Detail text font color key from SyncEngine.
    @IBInspectable open var detailColor:String? = nil {
        didSet {
            guard (self.detailColor != oldValue) else {
                return;
            }
             
            self.detailTextLabel?.textColor = UIColor.color(forKey: detailColor);
        }
    }
    
    private var _data:Any?
    
    /// Holds Table View Cell Data.
    open var data:Any? {
        get {
            return _data;
        }
    } //P.E.
    
    //Lazy instance for table view seperator view.
    open lazy var seperatorView:UIView = {
        let sView = UIView(frame: self.seperatorFrame);
        sView.isHidden = true;
        sView.backgroundColor = UIColor.lightGray;
        self.addSubview(sView);
        return sView;
    }()
    
    class var cellID : String {
        return "\(self)ID"
    } //P.E.
    
    //MARK: - Constructor
    
    /// Convenience constructor with cell reuseIdentifier - by default style = UITableViewCellStyle.default.
    ///
    /// - Parameter reuseIdentifier: Reuse identifier
    public convenience init(reuseIdentifier: String?) {
        self.init(style: UITableViewCellStyle.default, reuseIdentifier: reuseIdentifier);
    } //F.E.
    
    /// Overridden constructor to setup/ initialize components.
    ///
    /// - Parameters:
    ///   - style: Table View Cell Style
    ///   - reuseIdentifier: Reuse identifier
    override public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier);
         
        self.selectionStyle = UITableViewCellSelectionStyle.none;
         
        self.commonInit();
    } //F.E.
    
    /// Required constructor implemented.
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder);
    } //F.E.
    
    //MARK: - Overridden Methods
    
    /// Overridden method to setup/ initialize components.
    override open func awakeFromNib() {
        super.awakeFromNib();
         
        self.commonInit();
    } //F.E.
    
    
    /// Overridden method to receive selected states of table view cell
    ///
    /// - Parameters:
    ///   - selected: Flag for Selected State
    ///   - animated: Flag for Animation
    override open func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated);
    } //F.E.
    
    /// Recursive update of layout and content from Sync Engine.
    override func updateSyncedData() {
        super.updateSyncedData();
         
        self.contentView.updateSyncedData();
    } //F.E.
    
    /// Overridden methed to update layout.
    override open func layoutSubviews() {
        super.layoutSubviews();
        
        self.seperatorView.frame = self.seperatorFrame;
    } //F.E.
    
    //MARK: - Methods
    
    /// A common initializer to setup/initialize sub components.
    private func commonInit() {
        self.selectionStyle = UITableViewCellSelectionStyle.none;
         
        self.contentView.backgroundColor  = UIColor.clear;
        
        self.textLabel?.font = UIFont.font(self.fontName, fontStyle: self.fontStyle, sizedForIPad: sizeForIPad);
        
        self.detailTextLabel?.font = UIFont.font(self.fontName, fontStyle: self.fontDetailStyle, sizedForIPad: sizeForIPad);
    } //F.E.
    
    /// Updates layout and contents from SyncEngine. this is a protocol method BaseView that is called when the view is refreshed.
    func updateView() {
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
    
    /// This method should be called in cellForRowAt:indexPath. it also must be overriden in all sub classes of BaseUITableViewCell to update the table view cell's content.
    ///
    /// - Parameter data: Cell Data
    open func updateData(_ data:Any?) {
        _data = data;
         
        self.updateSyncedData();
    } //F.E.

} //CLS END
