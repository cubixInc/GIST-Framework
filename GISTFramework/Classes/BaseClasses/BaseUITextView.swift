//
//  BaseTextView.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 14/06/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit

/// BaseUITextView is a subclass of UITextView and implements BaseView. It has some extra proporties and support for SyncEngine.
open class BaseUITextView: UITextView, BaseView {

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
    
    /// Font name key from Sync Engine.
    @IBInspectable open var fontName:String = GIST_CONFIG.fontName {
        didSet {
            //There should be same font name for the placeholder text
            _lblPlaceholder?.fontName = fontName;
            
            self.font = UIFont.font(fontName, fontStyle: fontStyle, sizedForIPad: self.sizeForIPad);
        }
    }
    
    /// Font size/style key from Sync Engine.
    @IBInspectable open var fontStyle:String = GIST_CONFIG.fontStyle {
        didSet {
            //There should be same font style for the placeholder text
            _lblPlaceholder?.fontStyle = fontStyle;
            
            self.font = UIFont.font(fontName, fontStyle: fontStyle, sizedForIPad: self.sizeForIPad);
        }
    }
    
    /// Font color key from Sync Engine.
    @IBInspectable open var fontColorStyle:String? = nil {
        didSet {
            self.textColor = SyncedColors.color(forKey: fontColorStyle);
        }
    }
    
    /// Placeholder text font color key from Sync Engine.
    @IBInspectable open var placeholderColorStyle:String? = nil {
        didSet {
            self.lblPlaceholder.textColor = SyncedColors.color(forKey: placeholderColorStyle);
        }
    } //P.E.
    
    /// Sete placeholder text from SyncEngine (Hint '#' prefix).
    @IBInspectable open var placeholder:String? {
        set {
            if (newValue != nil) {
                self.lblPlaceholder.text = newValue;
                
                self.addTextDidChangeObserver();
                //-
                self.updatePlaceholderState();
            } else {
                if (_lblPlaceholder != nil) {
                    _lblPlaceholder!.removeFromSuperview();
                    _lblPlaceholder = nil;
                     
                    self.removeTextDidChangeObserver();
                }
            }
        }
         
        get {
            return _lblPlaceholder?.text;
        }
    } //P.E.
    
    ///Overridden property to handle placeholder visiblility.
    open override var text: String! {
        didSet {
            self.updatePlaceholderState();
        }
    } //P.E.
    
    ///Overridden property to handle placeholder Text Alignment
    open override var textAlignment: NSTextAlignment {
        get {
            return super.textAlignment;
        }
        
        set {
            _lblPlaceholder?.textAlignment = newValue;
            super.textAlignment = newValue;
        }
    } //P.E.
    
    private var _lblPlaceholder:BaseUILabel?

    /// UILable instance for text view placeholder text.
    private var lblPlaceholder:BaseUILabel {
        get {
            
            if (_lblPlaceholder == nil) {
                _lblPlaceholder = BaseUILabel(frame: self.lblPlaceholderFrame);
                _lblPlaceholder!.numberOfLines = 0;
                
                _lblPlaceholder!.topAligned = true;
                
                _lblPlaceholder!.sizeForIPad = self.sizeForIPad;
                _lblPlaceholder!.fontName = self.fontName;
                _lblPlaceholder!.fontStyle = self.fontStyle;
                
                _lblPlaceholder!.textColor = UIColor(white: 0.80, alpha: 1);
                _lblPlaceholder!.backgroundColor = UIColor.clear;
                
                _lblPlaceholder!.textAlignment = self.textAlignment;
                
                _lblPlaceholder!.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight];
                
                self.addSubview(_lblPlaceholder!);
                
                 
                self.updatePlaceholderState();
            }
            
            return _lblPlaceholder!
        }
    } //P.E.
    
    // Calculated placeholder frame Rect
    private var lblPlaceholderFrame:CGRect {
        get {
            return CGRect(x: 3, y: 7, width: self.frame.size.width - 6, height: self.frame.size.height - 7);
        }
    } //P.E.
    
    //MARK: - Constructors
    
    /// Overridden method to setup/ initialize components.
    ///
    /// - Parameters:
    ///   - frame: View Frame
    ///   - textContainer: Text Container
    override public init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer);
        
        self.commonInit()
    } //C.E.
    
    /// Required constructor implemented.
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    } //C.E.
    
    //MARK: - Distructor
    
    deinit {
        self.removeTextDidChangeObserver();
    }
    
    //MARK: - Overridden Methods
    
    /// Overridden method to setup/ initialize components.
    override open func awakeFromNib() {
        super.awakeFromNib()
         
        self.commonInit()
    } //F.E.
    
    /// Overridden method to update frames
    override open func layoutSubviews() {
        super.layoutSubviews();
        
        if rounded {
            self.addRoundedCorners();
        }
        
        //Resizing Placeholder
        _lblPlaceholder?.frame = self.lblPlaceholderFrame;
    } //F.E.
    
    //MARK: - Methods
    
    /// A common initializer to setup/initialize sub components.
    private func commonInit() {
        self.font = UIFont.font(fontName, fontStyle: fontStyle, sizedForIPad: self.sizeForIPad);
        
        self.updatePlaceholderState();
    } //F.E.
    
    /// Updates layout and contents from SyncEngine. this is a protocol method BaseView that is called when the view is refreshed.
    func updateView()  {
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
        
        //Updating Placeholder
        _lblPlaceholder?.updateView();
    } //F.E.
    
    
    /// Updatating visiblity of placeholder text.
    private func updatePlaceholderState() {
        //Checking if _lblPlaceholder is initialized or not
        if (_lblPlaceholder != nil) {
            self.lblPlaceholder.isHidden = (self.text.characters.count > 0);
        }
    } //F.E.
    
    //MARK: - Text change observer handling
    
    /// Adding observer for UITextView Text Change.
    private func addTextDidChangeObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChangeObserver), name: NSNotification.Name.UITextViewTextDidChange, object: nil);
    } //F.E.
    
    /// Removing observer for UITextView.
    private func removeTextDidChangeObserver() {
        NotificationCenter.default.removeObserver(self);
    } //F.E.

    /// Observer for text changes.
    internal func textDidChangeObserver(_ notification:Notification) {
        if (self.placeholder == nil) {
            return;
        }
         
        self.updatePlaceholderState();
    } //F.E.
    
} //CLS END


