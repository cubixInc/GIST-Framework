//
//  PinCodeTextField.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 28/04/2017.
//  Copyright © 2017 Social Cubix. All rights reserved.
//

import UIKit

open class PinCodeTextField: BaseUIView, UIKeyInput {
    @IBInspectable public var lineWidth: CGFloat = 12;
    @IBInspectable public var lineHeight: CGFloat = 2;
    @IBInspectable public var lineHSpacing: CGFloat = 10;
    @IBInspectable public var lineVMargin: CGFloat = 2;
    @IBInspectable public var characterLimit: Int = 4;
    
    @IBInspectable public var secureText: Bool = false;
    @IBInspectable public var lineSepration: Bool = true;
    
    @IBInspectable public var text: String? {
        didSet {
            self.updateView();
        }
    }
    
    /// Set placeholder text from SyncEngine (Hint '#' prefix).
    @IBInspectable open var placeholder:String? = nil {
        didSet {
            self.updateLabels();
        }
    } //P.E.
    
    /// Font name key from Sync Engine.
    @IBInspectable open var fontName:String = GIST_CONFIG.fontName {
        didSet {
            self.updateLabels();
        }
    }
    
    /// Font size/style key from Sync Engine.
    @IBInspectable open var fontStyle:String = GIST_CONFIG.fontStyle {
        didSet {
            self.updateLabels();
        }
    }
    
    /// Font color key from Sync Engine.
    @IBInspectable open var fontColorStyle:String? = nil {
        didSet {
            self.updateLabels();
        }
    }
    
    /// Placeholder text font color key from Sync Engine.
    @IBInspectable open var placeholderColorStyle:String? = nil {
        didSet {
            self.updateLabels();
        }
    } //P.E.
    
    @IBInspectable public var underlineColorStyle: String? = nil {
        didSet {
            self.updateLines();
        }
    } //P.E.
    
    
    open var font: UIFont {
        get {
            return UIFont.font(self.fontName, fontStyle: self.fontStyle, sizedForIPad: self.sizeForIPad);
        }
    }
    
    public var keyboardType: UIKeyboardType = UIKeyboardType.numberPad;
    public var allowedCharacterSet: CharacterSet = CharacterSet.alphanumerics
    
    fileprivate var _delegate:PinCodeTextFieldDelegate?
    @IBOutlet open var delegate:AnyObject? {
        didSet {
            _delegate = delegate as? PinCodeTextFieldDelegate;
        }
    } //P.E.

    //MARK: Private
    fileprivate var labels: [BaseUILabel] = []
    fileprivate var underlines: [BaseUIView] = []
    
    
    //MARK: Init and awake
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit();
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        commonInit();
    }
    
    private func commonInit() {
        updateView()
    }
    
    //MARK: Overrides
    override open func layoutSubviews() {
        layoutCharactersAndPlaceholders();
        super.layoutSubviews()
    }
    
    override open var canBecomeFirstResponder: Bool {
        return true;
    }
    
    override open func becomeFirstResponder() -> Bool {
        _delegate?.textFieldDidBeginEditing?(self)
        return super.becomeFirstResponder()
    }
    
    override open func resignFirstResponder() -> Bool {
        _delegate?.textFieldDidEndEditing?(self)
        return super.resignFirstResponder()
    }
    
    //MARK: Private
    func updateView() {
        if (needToRecreateUnderlines()) {
            recreateUnderlines()
        }
        if (needToRecreateLabels()) {
            recreateLabels()
        }
        updateLabels()
        setNeedsLayout()
    }
    
    private func needToRecreateUnderlines() -> Bool {
        return characterLimit != underlines.count
    }
    
    private func needToRecreateLabels() -> Bool {
        return characterLimit != labels.count
    }
    
    private func recreateUnderlines() {
        underlines.forEach{ $0.removeFromSuperview() }
        underlines.removeAll()
        characterLimit.times {
            let underline = createUnderline()
            underlines.append(underline)
            addSubview(underline)
        }
    }
    
    private func recreateLabels() {
        labels.forEach{ $0.removeFromSuperview() }
        labels.removeAll()
        characterLimit.times {
            let label = createLabel()
            labels.append(label)
            addSubview(label)
        }
    }
    
    private func updateLabels() {
        for label in labels {
            let index = labels.firstIndex(of: label) ?? 0
            let currentCharacter = self.character(atIndex: index)
            label.text = currentCharacter.map { String($0) }
            label.font = font
            let isplaceholder = isPlaceholder(index)
            label.fontColorStyle = labelColor(isPlaceholder: isplaceholder)
        }
    }
    
    private func updateLines() {
        for line in underlines {
            line.bgColorStyle = self.underlineColorStyle;
        }
    }
    
    private func labelColor(isPlaceholder placeholder: Bool) -> String? {
        return placeholder ? self.placeholderColorStyle : self.fontColorStyle
    }
    
    func character(atIndex i: Int) -> Character? {
        let inputTextCount = text?.count ?? 0
        let character: Character?
        if i < inputTextCount {
            let string = text ?? ""
            character = isSecureTextEntry ? "•" : string[string.index(string.startIndex, offsetBy: i)]
        } else {
            character = self.placeholder?.first
        }
        
        return character
    }
    
    private func isPlaceholder(_ i: Int) -> Bool {
        let inputTextCount = text?.count ?? 0
        return i >= inputTextCount
    }
    
    private func createLabel() -> BaseUILabel {
        let label = BaseUILabel(frame: CGRect())
        label.fontName = self.fontName;
        label.fontStyle = self.fontStyle;
        label.backgroundColor = UIColor.clear
        label.textAlignment = .center
        return label
    }
    
    private func createUnderline() -> BaseUIView {
        let underline = BaseUIView()
        underline.bgColorStyle = self.underlineColorStyle
        return underline
    }
    
    private func layoutCharactersAndPlaceholders() {
        
        let seperation:Bool = (characterLimit % 2 == 0) ? lineSepration:false;
        
        let marginsCount = seperation ? characterLimit : (characterLimit - 1);
        let totalMarginsWidth = lineHSpacing * CGFloat(marginsCount)
        let totalUnderlinesWidth = lineWidth * CGFloat(characterLimit)
        
        let totalLabelHeight = font.ascender + font.descender
        let underlineY = bounds.height / 2 + totalLabelHeight / 2 + lineVMargin
        
        var currentX: CGFloat = bounds.width / 2 - (totalUnderlinesWidth + totalMarginsWidth) / 2
        
        for i:Int in 0 ..< labels.count {
            labels[i].frame = CGRect(x: currentX, y: 0, width: lineWidth, height: bounds.height);
            
            underlines[i].frame = CGRect(x: currentX, y: underlineY, width: lineWidth, height: lineHeight);
            
            currentX += lineWidth + lineHSpacing
            
            if (seperation && i == (labels.count / 2) - 1) {
                currentX += lineHSpacing;
            }
        }
    } //F.E.
    
    //MARK: Touches
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let location = touch.location(in: self)
        if (bounds.contains(location)) {
            if (_delegate?.textFieldShouldBeginEditing?(self) ?? true) {
                let _ = becomeFirstResponder()
            }
        }
    }
    
    
    //MARK: Text processing
    func canInsertCharacter(_ character: String) -> Bool {
        let newText = text.map { $0 + character } ?? character
        let isNewline = character.hasOnlyNewlineSymbols
        let isCharacterMatchingCharacterSet = character.trimmingCharacters(in: allowedCharacterSet).isEmpty
        let isLengthWithinLimit = newText.count <= characterLimit
        return !isNewline && isCharacterMatchingCharacterSet && isLengthWithinLimit
    }
    
    //UIKeyInput Delegate Methods and Properties
    public var hasText: Bool {
        return text?.isEmpty ?? false
    }
    
    public var isSecureTextEntry: Bool {
        get {
            return self.secureText;
        }
        
        @objc(setSecureTextEntry:) set {
            self.secureText = newValue
        }
    } //P.E.
    
    public func insertText(_ charToInsert: String) {
        if charToInsert.hasOnlyNewlineSymbols {
            
            if (_delegate?.textFieldShouldReturn?(self) ?? true) {
                let _ = resignFirstResponder()
            }
        }
        else if canInsertCharacter(charToInsert) {
            let newText = text.map { $0 + charToInsert } ?? charToInsert
            text = newText
            _delegate?.textFieldValueChanged?(self)
            if (newText.count == characterLimit) {
                if (_delegate?.textFieldShouldEndEditing?(self) ?? true) {
                    let _ = resignFirstResponder()
                }
            }
        }
    }
    
    public func deleteBackward() {
        guard hasText else { return }
        text?.removeLast()
        _delegate?.textFieldValueChanged?(self)
    }
    
} //CLS END

@objc public protocol PinCodeTextFieldDelegate: class {
    @objc optional func textFieldShouldBeginEditing(_ textField: PinCodeTextField) -> Bool // return false to disallow editing.
    
    @objc optional func textFieldDidBeginEditing(_ textField: PinCodeTextField) // became first responder
    
    @objc optional func textFieldValueChanged(_ textField: PinCodeTextField) // text value changed
    
    @objc optional func textFieldShouldEndEditing(_ textField: PinCodeTextField) -> Bool // return true to allow editing to stop and to resign first responder status at the last character entered event. NO to disallow the editing session to end
    
    @objc optional func textFieldDidEndEditing(_ textField: PinCodeTextField) // called when pinCodeTextField did end editing
    
    @objc optional func textFieldShouldReturn(_ textField: PinCodeTextField) -> Bool // called when 'return' key pressed. return false to ignore.
} //P.E.
