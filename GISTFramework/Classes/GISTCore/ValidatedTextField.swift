//
//  ValidatedTextField.swift
//  Tst1
//
//  Created by Shoaib Abdul on 06/09/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit

@objc public protocol ValidatedTextFieldDelegate {
    optional func validatedTextFieldInvalidSignDidTap(validatedTextField:ValidatedTextField, sender:UIButton);
} //P.E.

public class ValidatedTextField: BaseUITextField {
    
    @IBInspectable var validateEmpty:Bool = false;
    
    @IBInspectable var validateEmail:Bool = false;
    @IBInspectable var validateURL:Bool = false;
    @IBInspectable var validateNumeric:Bool = false;
    @IBInspectable var validateAlphabetic:Bool = false;
    @IBInspectable var validateRegex:String?;
    
    @IBInspectable var minChar:Int?;
    @IBInspectable var maxChar:Int?;
    
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
        let cBtn:BaseUIButton = BaseUIButton(type: UIButtonType.Custom);
        cBtn.backgroundColor = UIColor.clearColor();
        cBtn.hidden = true;
        cBtn.frame = CGRect(x: self.frame.size.width - self.frame.size.height, y: 0, width: self.frame.size.height, height: self.frame.size.height);
        cBtn.contentMode = UIViewContentMode.ScaleAspectFit;
        //??cBtn.containtOffSet = GISTUtility.convertPointToRatio(CGPoint(x: 10, y: 0));
        
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
    
    private func validateText() {
        _isEmpty = self.isEmpty();
        
        _isValid =
            (!validateEmail || self.isValidEmail()) &&
            (!validateURL || self.isValidUrl()) &&
            (!validateNumeric || self.isNumeric()) &&
            (!validateAlphabetic || self.isAlphabetic()) &&
            ((minChar == nil) || self.isValidForMinChar(minChar!)) &&
            ((maxChar == nil) || self.isValidForMaxChar(maxChar!)) &&
            ((validateRegex == nil) || self.isValidForRegex(validateRegex!));
        
        
        self.invalidSignBtn.hidden = (_isValid || _isEmpty);
    } //F.E.
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        //--
        self.commonInit();
    } //F.E.
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    } //F.E.
    
    public override func awakeFromNib() {
        super.awakeFromNib();
        //--
        self.commonInit();
    } //F.E.
    
    private func commonInit() {
        self.validateText();
    } //F.E.
    
    public override func textFieldDidEndEditing(textField: UITextField) {
        super.textFieldDidEndEditing(textField);
        //--
        self.validateText();
    } //F.E.
    
    public func isEmpty()->Bool {
        guard (self.text != nil) else {
            return true;
        }
        
        return (self.text! == "");
    } //F.E.
    
    private func isValidEmail()->Bool {
        guard (self.text != nil) else {
            return false;
        }
        
        let emailRegex:String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let predicate:NSPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        
        return predicate.evaluateWithObject(self.text!);
    } //F.E.
    
    private func isValidUrl() -> Bool {
        guard (self.text != nil) else {
            return false;
        }
        
        let regexURL: String = "(http://|https://)?((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+"
        let predicate:NSPredicate = NSPredicate(format: "SELF MATCHES %@", regexURL)
        return predicate.evaluateWithObject(self.text)
    } //F.E.
    
    private func isNumeric() -> Bool {
        guard (self.text != nil) else {
            return false;
        }
        
        return Double(self.text!) != nil;
    } //F.E.
    
    private func isAlphabetic() -> Bool {
        guard (self.text != nil) else {
            return false;
        }
        
        for chr in self.text!.characters {
            if (!(chr >= "a" && chr <= "z") && !(chr >= "A" && chr <= "Z") ) {
                return false
            }
        }
        return true;
    } //F.E.
    
    private func isValidForMinChar(noOfChar:Int) -> Bool {
        guard (self.text != nil) else {
            return false;
        }
        
        return (self.text!.utf16.count >= noOfChar);
    } //F.E.
    
    private func isValidForMaxChar(noOfChar:Int) -> Bool {
        guard (self.text != nil) else {
            return false;
        }
        
        return (self.text!.utf16.count <= noOfChar);
    } //F.E.
    
    private func isValidForRegex(regex:String)->Bool {
        guard (self.text != nil) else {
            return false;
        }
        
        let predicate:NSPredicate = NSPredicate(format: "SELF MATCHES %@", regex)
        
        return predicate.evaluateWithObject(self.text!);
    } //F.E.
    
    public override func layoutSubviews() {
        super.layoutSubviews();
        //--
        self.invalidSignBtn.frame = CGRect(x: self.frame.size.width - self.frame.size.height, y: 0, width: self.frame.size.height, height: self.frame.size.height);
    } //F.E.
    
    
    func invalidSignBtnHandler(sender:UIButton) {
        (self.delegate as? ValidatedTextFieldDelegate)?.validatedTextFieldInvalidSignDidTap?(self, sender: sender)
    } //F.E.
} //CLS END
