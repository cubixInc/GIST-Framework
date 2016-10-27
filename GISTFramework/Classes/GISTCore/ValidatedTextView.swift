//
//  ValidatedTextView.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 09/09/2016.
//
//

import UIKit

@objc public protocol ValidatedTextViewDelegate {
    @objc optional func validatedTextViewInvalidSignDidTap(_ validatedTextField:ValidatedTextView, sender:UIButton);
} //P.E.

open class ValidatedTextView: BaseUITextView {

    @IBInspectable var validateEmpty:Bool = false;
    
    @IBInspectable var validateRegex:String = "";
    
    @IBInspectable var minChar:Int = 0;
    @IBInspectable var maxChar:Int = 0;
    
    @IBInspectable var invalidSign:UIImage? = nil {
        didSet {
            invalidSignBtn.setImage(invalidSign, for: UIControlState());
        }
    } //P.E.
    
    fileprivate var _validityMsg:String?
    @IBInspectable open var validityMsg:String {
        get {
            return _validityMsg ?? "Invalid";
        }
        
        set {
            _validityMsg = SyncedText.text(forKey: newValue);
        }
        
    } //P.E.
    
    fileprivate lazy var invalidSignBtn:BaseUIButton =  {
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
    
    fileprivate var _isEmpty:Bool = true;
    
    fileprivate var _isValid:Bool = false;
    open var isValid:Bool {
        get {
            let cValid:Bool = (_isValid && (!validateEmpty || !_isEmpty));
            
            self.invalidSignBtn.isHidden = cValid;
            
            return cValid;
        }
    } //F.E.
    
    open override var text: String! {
        didSet {
            self.validateText();
        }
    } //P.E.
    
    fileprivate func validateText() {
        _isEmpty = self.isEmpty();
        
        _isValid =
            ((minChar == 0) || self.isValidForMinChar(minChar)) &&
            ((maxChar == 0) || self.isValidForMaxChar(maxChar)) &&
            ((validateRegex == "") || self.isValidForRegex(validateRegex));
        
        self.invalidSignBtn.isHidden = (_isValid || _isEmpty);
    } //F.E.
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer);
        //--
        self.commonInit();
    } //F.E.
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    } //F.E.
    
    open override func awakeFromNib() {
        super.awakeFromNib();
        //--
        self.commonInit();
    } //F.E.
    
    fileprivate func commonInit() {
        self.validateText();
    } //F.E.
    
    open func isEmpty()->Bool {
        return GISTUtility.isEmpty(self.text);
    } //F.E.
    
    fileprivate func isValidForMinChar(_ noOfChar:Int) -> Bool {
        return GISTUtility.isValidForMinChar(self.text, noOfChar: noOfChar);
    } //F.E.
    
    fileprivate func isValidForMaxChar(_ noOfChar:Int) -> Bool {
        return GISTUtility.isValidForMaxChar(self.text, noOfChar: noOfChar);
    } //F.E.
    
    fileprivate func isValidForRegex(_ regex:String)->Bool {
        return GISTUtility.isValidForRegex(self.text, regex: regex);
    } //F.E.
    
    open override func layoutSubviews() {
        super.layoutSubviews();
        //--
        let sizeWH:CGFloat = GISTUtility.convertToRatio(60);
        self.invalidSignBtn.frame = CGRect(x: self.frame.size.width - sizeWH, y: 0, width: sizeWH, height: sizeWH);
    } //F.E.
    
    func invalidSignBtnHandler(_ sender:UIButton) {
        (self.delegate as? ValidatedTextViewDelegate)?.validatedTextViewInvalidSignDidTap?(self, sender: sender)
    } //F.E.
    
    override func textDidChangeObserver(_ notification:Notification) {
        super.textDidChangeObserver(notification);
        //--
        self.validateText();
    } //F.E.
} //CLS END
