//
//  BaseLabel.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 14/06/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit

/// BaseUILabel is a subclass of UILabel and implements BaseView. It extents UILabel with some extra proporties and supports SyncEngine.
open class BaseUILabel: UILabel, BaseView {
    
    //MARK: - Properties
    
    /// Flag for whether to resize the values for iPad.
    @IBInspectable open var sizeForIPad:Bool = GIST_CONFIG.sizeForIPad;
    
    /// Background color key from Sync Engine.
    @IBInspectable open var bgColorStyle:String? = nil {
        didSet {
            self.backgroundColor = SyncedColors.color(forKey: bgColorStyle);
        }
    }
    
    /// Width of View Border.
    @IBInspectable open var border:Int = 0 {
        didSet {
            if let borderCStyle:String = borderColorStyle {
                self.addBorder(SyncedColors.color(forKey: borderCStyle), width: border)
            }
        }
    }
    
    /// Border color key from Sync Engine.
    @IBInspectable open var borderColorStyle:String? = nil {
        didSet {
            if let borderCStyle:String = borderColorStyle {
                self.addBorder(SyncedColors.color(forKey: borderCStyle), width: border)
            }
        }
    }
    
    /// Corner Radius for View.
    @IBInspectable open var cornerRadius:Int = 0 {
        didSet {
            self.addRoundedCorners(GISTUtility.convertToRatio(CGFloat(cornerRadius), sizedForIPad: sizeForIPad));
        }
    }
    
    /// Flag for making circle/rounded view.
    @IBInspectable open var rounded:Bool = false {
        didSet {
            if rounded {
                self.addRoundedCorners();
            }
        }
    }
    
    /// Flag for Drop Shadow.
    @IBInspectable open var hasDropShadow:Bool = false {
        didSet {
            if (hasDropShadow) {
                self.addDropShadow();
            } else {
                // TO HANDLER
            }
        }
    }
    
    @IBInspectable open var underlinedText:Bool = false {
        didSet {
            if (underlinedText) {
                let attString:NSMutableAttributedString=NSMutableAttributedString(string: (self.text?.capitalized)! as String)
                attString.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.styleSingle.rawValue , range: NSRange(location: 0, length: attString.length))
                self.attributedText = attString
            } else {
                // TO HANDLER
            }
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
    
    /// Font color key from Sync Engine.
    @IBInspectable open var fontColorStyle:String? = nil {
        didSet {
            self.textColor = SyncedColors.color(forKey: fontColorStyle);
        }
    }
    
    @IBInspectable open var topAligned:Bool = false;
    
    private var _textKey: String?
    override open var text: String? {
        get {
            return super.text;
        }
        
        set {
            if let key:String = newValue , key.hasPrefix("#") == true {
                _textKey = key; // holding key for using later
                
                super.text = SyncedText.text(forKey: key);
            } else {
                super.text = newValue;
            }
        }
    } //P.E.
    
    //MARK: - Constructors
    
    /// Overridden constructor to setup/ initialize components.
    ///
    /// - Parameter frame: View frame
    public override init(frame: CGRect) {
        super.init(frame: frame);
        
        self.commontInit();
    } //C.E.
    
    /// Required method implemented
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    } //C.E.
    
    //MARK: - Overridden Methods
    
    /// Overridden method to setup/ initialize components.
    override open func awakeFromNib() {
        super.awakeFromNib();
        
        self.commontInit();
    } //F.E.
    
    /// Overridden methed to update layout.
    override open func layoutSubviews() {
        super.layoutSubviews();
        
        //Referesh on update layout
        if rounded {
            self.rounded = true;
        }
    } //F.E.
    
    override open func drawText(in rect:CGRect) {
        guard self.topAligned, let lblText = self.text else {  return super.drawText(in: rect) }
        
        let attributedText = NSAttributedString(string: lblText, attributes: [NSFontAttributeName: font])
        
        var newRect = rect;
        newRect.size.height = attributedText.boundingRect(with: rect.size, options: .usesLineFragmentOrigin, context: nil).size.height
        
        if numberOfLines != 0 {
            newRect.size.height = min(newRect.size.height, CGFloat(numberOfLines) * font.lineHeight)
        }
        
        super.drawText(in: newRect)
    } //F.E.
    
    //MARK: - Methods
    
    /// Common initazier for setting up items.
    private func commontInit() {
        self.font = UIFont.font(fontName, fontStyle: fontStyle, sizedForIPad: self.sizeForIPad);
        
        //Updating text with synced data
        if let txt:String = self.text , txt.hasPrefix("#") == true {
            self.text = txt; // Assigning again to set value from synced data
        } else if _textKey != nil {
            self.text = _textKey;
        }
    } //F.E.
    
    /// Updates layout and contents from SyncEngine. this is a protocol method BaseView that is called when the view is refreshed.
    func updateView() {
        //Setting font
        self.font = UIFont.font(fontName, fontStyle: fontStyle, sizedForIPad: self.sizeForIPad);
        
        //Re-assigning if there are any changes from server
        if let bgCStyle:String = self.bgColorStyle {
            self.bgColorStyle = bgCStyle;
        }
        
        if let borderCStyle:String = self.borderColorStyle {
            self.borderColorStyle = borderCStyle;
        }
        
        if let fntClrStyle = self.fontColorStyle {
            self.fontColorStyle = fntClrStyle;
        }
        
        if let txtKey:String = _textKey {
            self.text = txtKey;
        }
    } //F.E.
    
    
} //CLS END
