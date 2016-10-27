//
//  BaseTextView.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 14/06/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit

open class BaseUITextView: UITextView, BaseView {

    @IBInspectable open var sizeForIPad:Bool = false;
    
    @IBInspectable open var bgColorStyle:String? = nil {
        didSet {
            self.backgroundColor = SyncedColors.color(forKey: bgColorStyle);
        }
    }
    
    @IBInspectable open var border:Int = 0 {
        didSet {
            if let borderCStyle:String = borderColorStyle {
                self.addBorder(SyncedColors.color(forKey: borderCStyle), width: border)
            }
        }
    }
    
    @IBInspectable open var borderColorStyle:String? = nil {
        didSet {
            if let borderCStyle:String = borderColorStyle {
                self.addBorder(SyncedColors.color(forKey: borderCStyle), width: border)
            }
        }
    }
    
    @IBInspectable open var cornerRadius:Int = 0 {
        didSet {
            self.addRoundedCorners(GISTUtility.convertToRatio(CGFloat(cornerRadius), sizedForIPad: sizeForIPad));
        }
    }
    
    @IBInspectable open var rounded:Bool = false {
        didSet {
            if rounded {
                self.addRoundedCorners();
            }
        }
    }
    
    @IBInspectable open var hasDropShadow:Bool = false {
        didSet {
            if (hasDropShadow) {
                self.addDropShadow();
            } else {
                // TO HANDLER
            }
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
    
    @IBInspectable open var fontColorStyle:String? = nil {
        didSet {
            self.textColor = SyncedColors.color(forKey: fontColorStyle);
        }
    }
    
    @IBInspectable open var placeholderColorStyle:String? = nil {
        didSet {
            self.lblPlaceholder.textColor = SyncedColors.color(forKey: placeholderColorStyle);
        }
    } //P.E.
    
    @IBInspectable open var placeholder:String? {
        set {
            if (newValue != nil) {
                self.lblPlaceholder.text = newValue;
                self.lblPlaceholder.sizeToFit();
                //--
                self.addTextDidChangeObserver();
                //-
                self.updatePlaceholderState();
            } else {
                if (_lblPlaceholder != nil) {
                    _lblPlaceholder!.removeFromSuperview();
                    _lblPlaceholder = nil;
                    //--
                    self.removeTextDidChangeObserver();
                }
            }
        }
        //--
        get {
            return _lblPlaceholder?.text;
        }
    } //P.E.
    
    open override var text: String! {
        didSet {
            self.updatePlaceholderState();
        }
    }
    
    fileprivate var _lblPlaceholder:BaseUILabel?
    fileprivate var lblPlaceholder:BaseUILabel {
        get {
            
            if (_lblPlaceholder == nil) {
                _lblPlaceholder = BaseUILabel(frame: CGRect(x: 3, y: 6, width: 0, height: 0)); //sizeToFit method to reset its frame
                _lblPlaceholder!.numberOfLines = 1;
                
                _lblPlaceholder!.sizeForIPad = self.sizeForIPad;
                _lblPlaceholder!.fontName = self.fontName;
                _lblPlaceholder!.fontStyle = self.fontStyle;
                
                _lblPlaceholder!.textColor = UIColor(white: 0.80, alpha: 1);
                _lblPlaceholder!.backgroundColor = UIColor.clear;
                //--
                self.addSubview(_lblPlaceholder!);
                //--
                self.updatePlaceholderState();
            }
            
            return _lblPlaceholder!
        }
    } //P.E.
    
    override public init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer);
        //--
        self.commonInit()
    } //F.E.
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        //--
        self.commonInit()
    } //F.E.
    
    fileprivate func commonInit() {
        self.font = UIFont.font(fontName, fontStyle: fontStyle, sizedForIPad: self.sizeForIPad);
        //-
        self.updatePlaceholderState();
    }
    
    open func updateView()  {
        
        self.font = UIFont.font(fontName, fontStyle: fontStyle, sizedForIPad: self.sizeForIPad);
        
        if let bgCStyle:String = self.bgColorStyle {
            self.bgColorStyle = bgCStyle;
        }
        
        if let borderCStyle:String = self.borderColorStyle {
            self.borderColorStyle = borderCStyle;
        }
        
        if let fntClrStyle = self.fontColorStyle {
            self.fontColorStyle = fntClrStyle;
        }
        
        //Updating Placeholder
        _lblPlaceholder?.updateView();
    } //F.E.
    
    fileprivate func updatePlaceholderState() {
        //Checking if _lblPlaceholder is initialized or not
        if (_lblPlaceholder != nil) {
            self.lblPlaceholder.isHidden = (self.text.characters.count > 0);
        }
    } //F.E.
    
    override open func layoutSubviews() {
        super.layoutSubviews();
        //--
        if rounded {
            self.addRoundedCorners();
        }
    } //F.E.
    
    //MARK: - Text change Observer Handling
    fileprivate func addTextDidChangeObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChangeObserver), name: NSNotification.Name.UITextViewTextDidChange, object: nil);
    } //F.E.
    
    fileprivate func removeTextDidChangeObserver() {
        NotificationCenter.default.removeObserver(self);
    } //F.E.

    //MARK: - Observer
    internal func textDidChangeObserver(_ notification:Notification) {
        if (self.placeholder == nil) {
            return;
        }
        //--
        self.updatePlaceholderState();
    } //F.E.
    
    deinit {
        self.removeTextDidChangeObserver();
    }

} //CLS END
