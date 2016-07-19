//
//  BaseTextView.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 14/06/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit

public class BaseUITextView: UITextView, BaseView {

    @IBInspectable public var bgColorStyle:String! = nil;
    
    @IBInspectable public var boarder:Int = 0;
    @IBInspectable public var boarderColorStyle:String! = nil;
    
    @IBInspectable public var cornerRadius:Int = 0;
    @IBInspectable public var rounded:Bool = false;
    
    @IBInspectable public var hasDropShadow:Bool = false;
    
    @IBInspectable public var fontStyle:String = "medium";
    @IBInspectable public var fontColorStyle:String! = nil;

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
    
    @IBInspectable public var placeholderColorStyle:String? {
        set {
            if (newValue != nil) {
                _lblPlaceholder?.textColor = SyncedColors.color(forKey: newValue!);
            }
        }
        
        get {
            return nil; //TEMPERORILY BECAUSE CAN NOT RETURN COLOR STYLE FOR NOW
        }
    } //P.E.
    
    private var _lblPlaceholder:BaseUILabel?
    private var lblPlaceholder:BaseUILabel {
        get {
            
            if (_lblPlaceholder == nil) {
                _lblPlaceholder = BaseUILabel(frame: CGRect(x: 3, y: 6, width: 0, height: 0)); //sizeToFit method to reset its frame
                _lblPlaceholder!.numberOfLines = 1;
                _lblPlaceholder!.font = self.font;
                _lblPlaceholder!.textColor = UIColor(white: 0.80, alpha: 1);
                _lblPlaceholder!.backgroundColor = UIColor.clearColor();
                //--
                self.addSubview(_lblPlaceholder!);
            }
            
            return _lblPlaceholder!
        }
    } //P.E.
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        //--
        self.updateView()
    } //F.E.
    
    public func updateView()  {
        self.font = (self.font != nil) ?UIFont(name: self.font!.fontName, size: UIView.convertFontSizeToRatio(self.font!.pointSize, fontStyle: fontStyle)):UIView.font(fontStyle);
        //--
        _lblPlaceholder?.font = self.font;
        _lblPlaceholder?.fontStyle = self.fontStyle;
        _lblPlaceholder?.updateView();
        //--
        _lblPlaceholder?.sizeToFit();

        
        if (fontColorStyle != nil) {
            self.textColor = SyncedColors.color(forKey: fontColorStyle);
        }

        if (boarder > 0) {
            self.addBorder(SyncedColors.color(forKey: boarderColorStyle), width: boarder)
        }
        
        if (bgColorStyle != nil) {
            self.backgroundColor = SyncedColors.color(forKey: bgColorStyle);
        }
        
        if (cornerRadius != 0) {
            self.addRoundedCorners(UIView.convertToRatio(CGFloat(cornerRadius)));
        }
        
        if(hasDropShadow) {
            self.addDropShadow();
        }
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
