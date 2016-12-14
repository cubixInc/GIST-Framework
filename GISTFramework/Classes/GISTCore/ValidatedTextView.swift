//
//  ValidatedTextView.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 09/09/2016.
//
//

import UIKit

@objc public protocol ValidatedTextViewDelegate {
    optional func validatedTextViewInvalidSignDidTap(validatedTextField:ValidatedTextView, sender:UIButton);
} //P.E.

public class ValidatedTextView: BaseUITextView {

    @IBInspectable var validateEmpty:Bool = false;
    
    @IBInspectable var validateRegex:String = "";
    
    @IBInspectable var minChar:Int = 0;
    @IBInspectable var maxChar:Int = 0;
    
    @IBInspectable var invalidSign:UIImage? = nil {
        didSet {
            invalidSignBtn.setImage(invalidSign, forState: UIControlState.Normal);
        }
    } //P.E.
    
    private var _validityMsg:String?
    @IBInspectable public var validityMsg:String {
        get {
            return _validityMsg ?? "Invalid";
        }
        
        set {
            _validityMsg = SyncedText.text(forKey: newValue);
        }
        
    } //P.E.
    
    private lazy var invalidSignBtn:BaseUIButton =  {
        let cBtn:CustomUIButton = CustomUIButton(type: UIButtonType.Custom);
        cBtn.backgroundColor = UIColor.clearColor();
        cBtn.hidden = true;
        let sizeWH:CGFloat = GISTUtility.convertToRatio(60);
        cBtn.frame = CGRect(x: self.frame.size.width - sizeWH, y: 0, width: sizeWH, height: sizeWH);
        cBtn.contentMode = UIViewContentMode.Right;
        cBtn.containtOffSet = GISTUtility.convertPointToRatio(CGPoint(x: 10, y: 0));
        
        cBtn.addTarget(self, action: #selector(invalidSignBtnHandler(_:)), forControlEvents: UIControlEvents.TouchUpInside);
        
        self.addSubview(cBtn);
        return cBtn;
    } ();
    
    private var _isEmpty:Bool = true;
    
    private var _isValid:Bool = false;
    public var isValid:Bool {
        get {
            let cValid:Bool = (_isValid && (!validateEmpty || !_isEmpty));
            
            self.invalidSignBtn.hidden = cValid;
            
            return cValid;
        }
    } //F.E.
    
    public override var text: String! {
        didSet {
            self.validateText();
        }
    } //P.E.
    
    private func validateText() {
        _isEmpty = self.isEmpty();
        
        _isValid =
            ((minChar == 0) || self.isValidForMinChar(minChar)) &&
            ((maxChar == 0) || self.isValidForMaxChar(maxChar)) &&
            ((validateRegex == "") || self.isValidForRegex(validateRegex));
        
        self.invalidSignBtn.hidden = (_isValid || _isEmpty);
    } //F.E.
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer);
        
        self.commonInit();
    } //F.E.
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    } //F.E.
    
    public override func awakeFromNib() {
        super.awakeFromNib();
        
        self.commonInit();
    } //F.E.
    
    private func commonInit() {
        self.validateText();
    } //F.E.
    
    public func isEmpty()->Bool {
        return GISTUtility.isEmpty(self.text);
    } //F.E.
    
    private func isValidForMinChar(noOfChar:Int) -> Bool {
        return GISTUtility.isValidForMinChar(self.text, noOfChar: noOfChar);
    } //F.E.
    
    private func isValidForMaxChar(noOfChar:Int) -> Bool {
        return GISTUtility.isValidForMaxChar(self.text, noOfChar: noOfChar);
    } //F.E.
    
    private func isValidForRegex(regex:String)->Bool {
        return GISTUtility.isValidForRegex(self.text, regex: regex);
    } //F.E.
    
    public override func layoutSubviews() {
        super.layoutSubviews();
        
        let sizeWH:CGFloat = GISTUtility.convertToRatio(60);
        self.invalidSignBtn.frame = CGRect(x: self.frame.size.width - sizeWH, y: 0, width: sizeWH, height: sizeWH);
    } //F.E.
    
    func invalidSignBtnHandler(sender:UIButton) {
        (self.delegate as? ValidatedTextViewDelegate)?.validatedTextViewInvalidSignDidTap?(self, sender: sender)
    } //F.E.
    
    override func textDidChangeObserver(notification:NSNotification) {
        super.textDidChangeObserver(notification);
        
        self.validateText();
    } //F.E.
} //CLS END
