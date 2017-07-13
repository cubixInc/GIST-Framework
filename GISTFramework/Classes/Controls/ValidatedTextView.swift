//
//  ValidatedTextView.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 09/09/2016.
//
//

import UIKit

/// ValidatedTextView Protocol to receive events.
@objc public protocol ValidatedTextViewDelegate {
    @objc optional func validatedTextViewInvalidSignDidTap(_ validatedTextField:ValidatedTextView, sender:UIButton);
} //P.E.

/// ValidatedTextView is subclass of BaseUITextView with extra proporties to validate text input.
open class ValidatedTextView: BaseUITextView, UITextViewDelegate {

    //MARK: - Properties
    
    /// Bool flag for validating an empty text.
    @IBInspectable var validateEmpty:Bool = false;
    
    /// Bool flag for validating a valid alphabetic input.
    @IBInspectable var validateRegex:String = "";
    
    /// Validats minimum character limit.
    @IBInspectable var minChar:Int = 0;
    
    /// Validats maximum character limit.
    @IBInspectable var maxChar:Int = 0;
    
    /// Inspectable property for invalid sign image.
    @IBInspectable var invalidSign:UIImage? = nil {
        didSet {
            invalidSignBtn.setImage(invalidSign, for: UIControlState());
        }
    } //P.E.
    
    /**
     Validity msg for invalid input text. - Default text is 'Invalid'
     The msg can be a key of SyncEngine with a prefix '#'
     */
    @IBInspectable open var validityMsg:String? = nil;
    
    open var isInvalidSignHidden:Bool = true {
        didSet {
            self.invalidSignBtn.isHidden = isInvalidSignHidden;
        }
    } //P.E.
    
    /// Lazy Button instance for invalid sign.
    private lazy var invalidSignBtn:BaseUIButton =  {
        let cBtn:CustomUIButton = CustomUIButton(type: UIButtonType.custom);
        cBtn.backgroundColor = UIColor.clear;
        cBtn.isHidden = true;
        let sizeWH:CGFloat = GISTUtility.convertToRatio(60);
        cBtn.frame = CGRect(x: self.frame.size.width - sizeWH, y: 0, width: sizeWH, height: sizeWH);
        cBtn.contentMode = UIViewContentMode.right;
        cBtn.containtOffSet = GISTUtility.convertPointToRatio(CGPoint(x: 10, y: 0));
        
        cBtn.addTarget(self, action: #selector(invalidSignBtnHandler(_:)), for: UIControlEvents.touchUpInside);
        
        self.addSubview(cBtn);
        return cBtn;
    } ();
    
    private var _isEmpty:Bool = true;
    
    private var _isValid:Bool = false;
    
    private var _data:Any?
    
    /// Holds Data.
    open var data:Any? {
        get {
            return _data;
        }
    } //P.E.
    
    /// Flag for whether the input is valid or not.
    open var isValid:Bool {
        get {
            if (self.isFirstResponder) {
                self.validateText();
            }
            
            let cValid:Bool = (_isValid && (!validateEmpty || !_isEmpty));
            
            self.isInvalidSignHidden = cValid;
            
            return cValid;
        }
    } //F.E.
    
    /// Overridden property to get text changes.
    open override var text: String! {
        didSet {
            self.validateText();
        }
    } //P.E.
    
    ///Maintainig Own delegate.
    private weak var _delegate:UITextViewDelegate?;
    open override weak var delegate: UITextViewDelegate? {
        get {
            return _delegate;
        }
        
        set {
            _delegate = newValue;
        }
    } //P.E.
    
    
    //MARK: - Constructors
    
    /// Overridden constructor to setup/ initialize components.
    ///
    /// - Parameters:
    ///   - frame: View Frame
    ///   - textContainer: NSTextContainer
    override public init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer);
         
        self.commonInit();
    } //F.E.
    
    /// Required constructor implemented.
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    } //F.E.
    
    //MARK: - Overridden Methods
    
    /// Overridden method to setup/ initialize components.
    open override func awakeFromNib() {
        super.awakeFromNib();
         
        self.commonInit();
    } //F.E.
    
    /// Overridden methed to update layout.
    open override func layoutSubviews() {
        super.layoutSubviews();
         
        let sizeWH:CGFloat = GISTUtility.convertToRatio(60);
        self.invalidSignBtn.frame = CGRect(x: self.frame.size.width - sizeWH, y: 0, width: sizeWH, height: sizeWH);
    } //F.E.
    
    open func updateData(_ data: Any?) {
        _data = data;
        
        let dicData:NSMutableDictionary? = data as? NSMutableDictionary;
        
        //First set the validations
        self.validateEmpty = dicData?["validateEmpty"] as? Bool ?? false;
        self.validateRegex = dicData?["validateRegex"] as? String ?? "";
        
        //??self.validityMsg = dicData?["validityMsg"] as? String;
        
        //Set the text and placeholder
        self.text = dicData?["text"] as? String;
        self.placeholder = dicData?["placeholder"] as? String;
        
        //Set the character Limit
        self.minChar = dicData?["minChar"] as? Int ?? 0;
        self.maxChar = dicData?["maxChar"] as? Int ?? 0;
        
        //Set the is password check
        self.isSecureTextEntry = dicData?["isSecureTextEntry"] as? Bool ?? false;
        self.isUserInteractionEnabled = dicData?["isUserInteractionEnabled"] as? Bool ?? true;
        
        /*
        if let validated:Bool = dicData?["validated"] as? Bool, validated == true {
            self.isInvalidSignHidden = (_isValid && (!validateEmpty || !_isEmpty));
        }
        */
    } //F.E.
    
    /// Observer to receive Text Changes
    ///
    /// - Parameter notification: Notification instance
    override func textDidChangeObserver(_ notification:Notification) {
        super.textDidChangeObserver(notification);
    } //F.E.
    
    //MARK: - Methods
    
    /// Validating in input and updating the flags of isValid and isEmpty.
    private func validateText() {
        _isEmpty = self.isEmpty();
        
        _isValid =
            ((minChar == 0) || self.isValidForMinChar(minChar)) &&
            ((maxChar == 0) || self.isValidForMaxChar(maxChar)) &&
            ((validateRegex == "") || self.isValidForRegex(validateRegex));
        
        self.isInvalidSignHidden = (_isValid || _isEmpty);
        
        if let dicData:NSMutableDictionary = self.data as? NSMutableDictionary {
            dicData["isValid"] = (_isValid && (!validateEmpty || !_isEmpty));
            
            dicData["validText"] = self.text;
        }
    } //F.E.

    
    /// A common initializer to setup/initialize sub components.
    private func commonInit() {
        super.delegate = self;
    } //F.E.
    
    /// Validats for an empty text
    ///
    /// - Returns: Bool flag for a valid input.
    open func isEmpty()->Bool {
        return GISTUtility.isEmpty(self.text);
    } //F.E.
    
    /// Validats for minimum chararacter limit
    ///
    /// - Parameter noOfChar: No. of characters
    /// - Returns: Bool flag for a valid input.
    private func isValidForMinChar(_ noOfChar:Int) -> Bool {
        return GISTUtility.isValidForMinChar(self.text, noOfChar: noOfChar);
    } //F.E.
    
    /// Validats for minimum chararacter limit
    ///
    /// - Parameter noOfChar: No. of characters
    /// - Returns: Bool flag for a valid input.
    private func isValidForMaxChar(_ noOfChar:Int) -> Bool {
        return GISTUtility.isValidForMaxChar(self.text, noOfChar: noOfChar);
    } //F.E.
    
    /// Validats for a regex
    ///
    /// - Parameter regex: Regex
    /// - Returns: Bool flag for a valid input.
    private func isValidForRegex(_ regex:String)->Bool {
        return GISTUtility.isValidForRegex(self.text, regex: regex);
    } //F.E.
    
    /// Method to handle tap event for invalid sign button.
    ///
    /// - Parameter sender: Invalid Sign Button
    func invalidSignBtnHandler(_ sender:UIButton) {
        (self.delegate as? ValidatedTextViewDelegate)?.validatedTextViewInvalidSignDidTap?(self, sender: sender)
    } //F.E.
    
    public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return _delegate?.textViewShouldBeginEditing?(textView) ?? true;
    }
    
    public func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        return _delegate?.textViewShouldEndEditing?(textView) ?? true;
    }
    
    public func textViewDidBeginEditing(_ textView: UITextView) {
        _delegate?.textViewDidBeginEditing?(textView);
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        _delegate?.textViewDidEndEditing?(textView);
        
        //Updating text in the holding dictionary
        let dicData:NSMutableDictionary? = data as? NSMutableDictionary;
        dicData?["text"] = textView.text;
        
        
        //Validating the input
        self.validateText();
    }
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return _delegate?.textView?(textView, shouldChangeTextIn: range, replacementText: text) ?? true;
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        _delegate?.textViewDidChange?(textView);
    }
    
    public func textViewDidChangeSelection(_ textView: UITextView) {
        _delegate?.textViewDidChangeSelection?(textView);
    }
    
    
} //CLS END
