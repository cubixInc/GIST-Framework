import UIKit

class AnimatedTextField: UITextField {

    enum TextFieldType {
        case text
        case password
        case numeric
        case selection
    }

    fileprivate let defaultPadding: CGFloat = -16
    fileprivate let clearButtonPadding: CGFloat = -8

    var rightViewPadding: CGFloat
    weak public var textInputDelegate: TextInputDelegate?

    public var textAttributes: [NSAttributedString.Key: Any]?
    public var contentInset: UIEdgeInsets = .zero

    fileprivate var disclosureButtonAction: (() -> Void)?

    override init(frame: CGRect) {
        self.rightViewPadding = defaultPadding

        super.init(frame: frame)

        setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        self.rightViewPadding = defaultPadding

        
        super.init(coder: aDecoder)

        setup()
    }

    fileprivate func setup() {
        delegate = self
        addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    @discardableResult override public func becomeFirstResponder() -> Bool {
        //NSParagraphStyleAttributeName
        if let alignment = (textAttributes?[NSAttributedString.Key.paragraphStyle] as? NSMutableParagraphStyle)?.alignment {
            textAlignment = alignment
        }
        return super.becomeFirstResponder()
    }

    override public func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        return super.rightViewRect(forBounds: bounds).offsetBy(dx: rightViewPadding, dy: 0)
    }

    override public func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
        return super.clearButtonRect(forBounds: bounds).offsetBy(dx: clearButtonPadding, dy: 0)
    }
    
    override public func textRect(forBounds bounds: CGRect) -> CGRect {
        var width = bounds.width
        if clearButtonMode == .always || clearButtonMode == .unlessEditing {
            width = bounds.width - clearButtonRect(forBounds: bounds).width * 2
        }
        return CGRect(x: bounds.origin.x + contentInset.left,
                      y: bounds.origin.y + contentInset.top,
                      width: width - contentInset.left - contentInset.right,
                      height: bounds.height - contentInset.top - contentInset.bottom)
    }

    override public func editingRect(forBounds bounds: CGRect) -> CGRect {
        var width = bounds.width
        if clearButtonMode != .never {
            width = bounds.width - clearButtonRect(forBounds: bounds).width * 2
        } else if let _ = rightView {
            width = bounds.width - rightViewRect(forBounds: bounds).width * 2
        }
        return CGRect(x: bounds.origin.x + contentInset.left,
                      y: bounds.origin.y + contentInset.top,
                      width: width - contentInset.left - contentInset.right,
                      height: bounds.height - contentInset.top - contentInset.bottom)
    }

    func add(disclosureButton button: UIButton, action: @escaping (() -> Void)) {
        let selector = #selector(disclosureButtonPressed)
        if disclosureButtonAction != nil, let previousButton = rightView as? UIButton {
            previousButton.removeTarget(self, action: selector, for: .touchUpInside)
        }
        disclosureButtonAction = action
        button.addTarget(self, action: selector, for: .touchUpInside)
        rightView = button
    }

    @objc fileprivate func disclosureButtonPressed() {
        disclosureButtonAction?()
    }

    @objc fileprivate func textFieldDidChange() {
        if let text = text {
            attributedText = NSAttributedString(string: text, attributes: textAttributes)
        }
        textInputDelegate?.textInputDidChange(textInput: self)
    }
}

extension AnimatedTextField: TextInput {

    public func currentPosition(from: UITextPosition, offset: Int) -> UITextPosition? {
        return position(from: from, offset: offset)
    }
    
    public func changeClearButtonMode(with newClearButtonMode: UITextField.ViewMode) {
        clearButtonMode = newClearButtonMode
    }

    public var currentText: String? {
        get { return text }
        set { self.text = newValue }
    }

    public var currentSelectedTextRange: UITextRange? {
        get { return self.selectedTextRange }
        set { self.selectedTextRange = newValue }
    }

    open var currentBeginningOfDocument: UITextPosition? {
        get { return self.beginningOfDocument }
    }
}

extension AnimatedTextField: TextInputError {

    public func configureErrorState(with message: String?) {
        placeholder = message
    }

    public func removeErrorHintMessage() {
        placeholder = nil
    }
}

extension AnimatedTextField: UITextFieldDelegate {

    public func textFieldDidBeginEditing(_ textField: UITextField) {
        textInputDelegate?.textInputDidBeginEditing(textInput: self)
    }

    public func textFieldDidEndEditing(_ textField: UITextField) {
        textInputDelegate?.textInputDidEndEditing(textInput: self)
    }

    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return textInputDelegate?.textInput(textInput: self, shouldChangeCharactersIn: range, replacementString: string) ?? true
    }

    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return textInputDelegate?.textInputShouldBeginEditing(textInput: self) ?? true
    }

    public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return textInputDelegate?.textInputShouldEndEditing(textInput: self) ?? true
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textInputDelegate?.textInputShouldReturn(textInput: self) ?? true
    }
}
