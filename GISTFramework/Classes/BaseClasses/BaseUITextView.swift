//
//  BaseTextView.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 14/06/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit

public class BaseUITextView: UITextView, BaseView {

    @IBInspectable public var sizeForIPad:Bool = false;
    
    @IBInspectable public var bgColorStyle:String? = nil {
        didSet {
            self.backgroundColor = SyncedColors.color(forKey: bgColorStyle);
        }
    }
    
    @IBInspectable public var border:Int = 0 {
        didSet {
            if let borderCStyle:String = borderColorStyle {
                self.addBorder(SyncedColors.color(forKey: borderCStyle), width: border)
            }
        }
    }
    
    @IBInspectable public var borderColorStyle:String? = nil {
        didSet {
            if let borderCStyle:String = borderColorStyle {
                self.addBorder(SyncedColors.color(forKey: borderCStyle), width: border)
            }
        }
    }
    
    @IBInspectable public var cornerRadius:Int = 0 {
        didSet {
            self.addRoundedCorners(GISTUtility.convertToRatio(CGFloat(cornerRadius), sizedForIPad: sizeForIPad));
        }
    }
    
    @IBInspectable public var rounded:Bool = false {
        didSet {
            if rounded {
                self.addRoundedCorners();
            }
        }
    }
    
    @IBInspectable public var hasDropShadow:Bool = false {
        didSet {
            if (hasDropShadow) {
                self.addDropShadow();
            } else {
                // TO HANDLER
            }
        }
    }
    
    @IBInspectable public var fontName:String = "fontRegular" {
        didSet {
            self.font = UIFont.font(fontName, fontStyle: fontStyle, sizedForIPad: self.sizeForIPad);
        }
    }
    
    @IBInspectable public var fontStyle:String = "medium" {
        didSet {
            self.font = UIFont.font(fontName, fontStyle: fontStyle, sizedForIPad: self.sizeForIPad);
        }
    }
    
    @IBInspectable public var fontColorStyle:String? = nil {
        didSet {
            self.textColor = SyncedColors.color(forKey: fontColorStyle);
        }
    }
    
    @IBInspectable public var placeholderColorStyle:String? = nil {
        didSet {
            self.lblPlaceholder.textColor = SyncedColors.color(forKey: placeholderColorStyle);
        }
    } //P.E.
    
    @IBInspectable public var placeholder:String? {
        set {
            if (newValue != nil) {
                self.lblPlaceholder.text = newValue;
                self.lblPlaceholder.sizeToFit();
                //--
                self.addTextDidChangeObserver();
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
    
    private var _lblPlaceholder:BaseUILabel?
    private var lblPlaceholder:BaseUILabel {
        get {
            
            if (_lblPlaceholder == nil) {
                _lblPlaceholder = BaseUILabel(frame: CGRect(x: 3, y: 6, width: 0, height: 0)); //sizeToFit method to reset its frame
                _lblPlaceholder!.numberOfLines = 1;
                
                _lblPlaceholder!.sizeForIPad = self.sizeForIPad;
                _lblPlaceholder!.fontName = self.fontName;
                _lblPlaceholder!.fontStyle = self.fontStyle;
                
                _lblPlaceholder!.textColor = UIColor(white: 0.80, alpha: 1);
                _lblPlaceholder!.backgroundColor = UIColor.clearColor();
                //--
                self.addSubview(_lblPlaceholder!);
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
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        //--
        self.commonInit()
    } //F.E.
    
    private func commonInit() {
        self.font = UIFont.font(fontName, fontStyle: fontStyle, sizedForIPad: self.sizeForIPad);
    }
    
    public func updateView()  {
        
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
    
    override public func layoutSubviews() {
        super.layoutSubviews();
        //--
        if rounded {
            self.addRoundedCorners();
        }
    } //F.E.
    
    //MARK: - TEXT DID CHANGE OBSERVER HANDLING
    private func addTextDidChangeObserver() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(textDidChangeObserver), name: UITextViewTextDidChangeNotification, object: nil);
    } //F.E.
    
    private func removeTextDidChangeObserver() {
        NSNotificationCenter.defaultCenter().removeObserver(self);
    } //F.E.

    //MARK: - Observer
    internal func textDidChangeObserver(notification:NSNotification) {
        if (self.placeholder == nil) {
            return;
        }
        //--
        if (self.text.characters.count == 0) {
            self.lblPlaceholder.alpha = 1;
        } else {
            self.lblPlaceholder.alpha = 0;
        }
    } //F.E.
    
    deinit {
        self.removeTextDidChangeObserver();
    }

} //CLS END
