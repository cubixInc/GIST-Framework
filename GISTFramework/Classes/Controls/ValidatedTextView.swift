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
open class ValidatedTextView: BaseUITextView {

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
    
    private var _validityMsg:String?
    
    /**
     Validity msg for invalid input text. - Default text is 'Invalid'
     The msg can be a key of SyncEngine with a prefix '#'
     */
    @IBInspectable open var validityMsg:String {
        get {
            return _validityMsg ?? "Invalid";
        }
        
        set {
            _validityMsg = SyncedText.text(forKey: newValue);
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
    
    /// Flag for whether the input is valid or not.
    open var isValid:Bool {
        get {
            let cValid:Bool = (_isValid && (!validateEmpty || !_isEmpty));
            
            self.invalidSignBtn.isHidden = cValid;
            
            return cValid;
        }
    } //F.E.
    
    /// Overridden property to get text changes.
    open override var text: String! {
        didSet {
            self.validateText();
        }
    } //P.E.
    
    
    //MARK: - Constructors
    
    /// Overridden constructor to setup/ initialize components.
    ///
    /// - Parameters:
    ///   - frame: View Frame
    ///   - textContainer: NSTextContainer
    override init(frame: CGRect, textContainer: NSTextContainer?) {
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
    
    /// Observer to receive Text Changes
    ///
    /// - Parameter notification: Notification instance
    override func textDidChangeObserver(_ notification:Notification) {
        super.textDidChangeObserver(notification);
         
        self.validateText();
    } //F.E.
    
    //MARK: - Methods
    
    /// Validating in input and updating the flags of isValid and isEmpty.
    private func validateText() {
        _isEmpty = self.isEmpty();
        
        _isValid =
            ((minChar == 0) || self.isValidForMinChar(minChar)) &&
            ((maxChar == 0) || self.isValidForMaxChar(maxChar)) &&
            ((validateRegex == "") || self.isValidForRegex(validateRegex));
        
        self.invalidSignBtn.isHidden = (_isValid || _isEmpty);
    } //F.E.

    
    /// A common initializer to setup/initialize sub components.
    private func commonInit() {
        self.validateText();
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
    

} //CLS END
