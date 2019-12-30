import UIKit

@objc public protocol AnimatedTextInputDelegate: class {
    @objc optional func animatedTextInputDidBeginEditing(animatedTextInput: AnimatedTextInput)
    @objc optional func animatedTextInputDidEndEditing(animatedTextInput: AnimatedTextInput)
    @objc optional func animatedTextInputDidChange(animatedTextInput: AnimatedTextInput)
    @objc optional func animatedTextInput(animatedTextInput: AnimatedTextInput, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    @objc optional func animatedTextInputShouldBeginEditing(animatedTextInput: AnimatedTextInput) -> Bool
    @objc optional func animatedTextInputShouldEndEditing(animatedTextInput: AnimatedTextInput) -> Bool
    @objc optional func animatedTextInputShouldReturn(animatedTextInput: AnimatedTextInput) -> Bool
}

open class AnimatedTextInput: UIControl, BaseView, TextInputDelegate {

    //MARK: - Properties
    
    /// The String to display when the textfield is not editing and the input is not empty.
    @IBInspectable open var title:String? {
        didSet {
            
        }
    } //P.E.
    
    private var _placeholder:String? = "Placeholder";
    @IBInspectable open var placeholder:String? {
        set {
            if let key:String = newValue , key.hasPrefix("#") == true {
                _placeholder = SyncedText.text(forKey: key);
            } else {
                _placeholder = newValue;
            }
            
            placeholderLayer.string = _placeholder
        }
        
        get {
            return _placeholder;
        }
    }
    
    @IBInspectable open var multilined:Bool = false {
        didSet {
            self.type = (multilined) ? .multiline:.standard;
        }
    }
    
    /// Max Character Count Limit for the text field.
    @IBInspectable open var maxCharLimit: Int = 255;
    
    
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
            self.addRoundedCorners(GISTUtility.convertToRatio(CGFloat(cornerRadius), sizedForIPad: iStyle.sizeForIPad));
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
    
    @IBInspectable var autoCapitalization: String {
        set {
            self.autocapitalization = UITextAutocapitalizationType.textAutocapitalizationType(for: newValue);
        }
        
        get {
            return "\(self.autocapitalization)";
        }
    }
    
    @IBInspectable var autoCorrection: String {
        set {
            self.autocorrection = UITextAutocorrectionType.textAutocorrectionType(for: newValue);
        }
        
        get {
            return "\(self.autocorrection)";
        }
    }
    
    @IBInspectable var keyboard: String {
        set {
            self.keyboardType = UIKeyboardType.keyboardType(for: newValue);
        }
        
        get {
            return "\(self.keyboardType)";
        }
    }
    
    @IBInspectable var returnKey: String {
        set {
            self.returnKeyType = UIReturnKeyType.returnKeyType(for: newValue);
        }
        
        get {
            return "\(self.returnKeyType)";
        }
    }
    
    /// Parameter key for service - Default Value is nil
    @IBInspectable open var paramKey:String?;
    
    typealias AnimatedTextInputType = AnimatedTextInputFieldConfigurator.AnimatedTextInputType

    private var _tapAction: (() -> Void)?
    
    open  weak var delegate: AnimatedTextInputDelegate?
    open fileprivate(set) var isActive = false

    var type: AnimatedTextInputType = .standard {
        didSet {
            configureType()
        }
    }

    open var autocapitalization: UITextAutocapitalizationType {
        get {
            return self.textInput.autocapitalization;
        }
        
        set {
            self.textInput.autocapitalization = newValue;
        }
    }
    
    open var autocorrection: UITextAutocorrectionType {
        get {
            return self.textInput.autocorrection;
        }
        
        set {
            self.textInput.autocorrection = newValue;
        }
    }
    
    open var keyboardType: UIKeyboardType {
        get {
            return self.textInput.keyboardType;
        }
        
        set {
            self.textInput.keyboardType = newValue;
        }
    }
    
    open var keyboardAppearance: UIKeyboardAppearance {
        get { return textInput.currentKeyboardAppearance }
        set { textInput.currentKeyboardAppearance = newValue }
    }
    
    open var returnKeyType: UIReturnKeyType = .default {
        didSet {
            textInput.changeReturnKeyType(with: returnKeyType)
        }
    }
    
    open var clearButtonMode: UITextField.ViewMode = .whileEditing {
        didSet {
            textInput.changeClearButtonMode(with: clearButtonMode)
        }
    }

    // Some letters like 'g' or 'á' were not rendered properly, the frame need to be about 20% higher than the font size
    open var frameHeightCorrectionFactor : Double = 1.2 {
        didSet {
            layoutPlaceholderLayer()
        }
        
    }
    
    open var placeholderAlignment: CATextLayer.Alignment = .natural {
        didSet {
            placeholderLayer.alignmentMode = CATextLayerAlignmentMode(rawValue: String(describing: placeholderAlignment))
        }
    }
    
    //External GIST Style
    open var style: AnimatedTextInputStyle? {
        didSet {
            //Externel Style
            self.iStyle = InternalAnimatedTextInputStyle(style);
        }
    }
    
    //Internal Style
    var iStyle: InternalAnimatedTextInputStyle = InternalAnimatedTextInputStyle(nil) {
        didSet {
            configureStyle()
        }
    }

    open var text: String? {
        get {
            return textInput.currentText
        }
        set {
            if !textInput.view.isFirstResponder {
               (newValue != nil && !newValue!.isEmpty) ? configurePlaceholderAsInactiveHint() : configurePlaceholderAsDefault()
            }
            textInput.currentText = newValue
        }
    }

    open var selectedTextRange: UITextRange? {
        get { return textInput.currentSelectedTextRange }
        set { textInput.currentSelectedTextRange = newValue }
    }

    open var beginningOfDocument: UITextPosition? {
        get { return textInput.currentBeginningOfDocument }
    }

    open var font: UIFont? {
        get { return textInput.font }
        set { textAttributes = [NSAttributedString.Key.font: newValue as Any] }
    }

    open var textColor: UIColor? {
        get { return textInput.textColor }
        set { textAttributes = [NSAttributedString.Key.foregroundColor: newValue as Any] }
    }

    open var lineSpacing: CGFloat? {
        get {
            guard let paragraph = textAttributes?[NSAttributedString.Key.paragraphStyle] as? NSParagraphStyle else { return nil }
            return paragraph.lineSpacing
        }
        set {
            guard let spacing = newValue else { return }
            let paragraphStyle = textAttributes?[NSAttributedString.Key.paragraphStyle] as? NSMutableParagraphStyle ?? NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = spacing
            textAttributes = [NSAttributedString.Key.paragraphStyle: paragraphStyle]
        }
    }
    
    @IBInspectable open var isSecureTextEntry: Bool {
        get {
            return self.textInput.isSecureTextEntry;
        }
        
        set {
            self.textInput.isSecureTextEntry = newValue;
        }
    }

    open var textAlignment: NSTextAlignment? {
        get {
            guard let paragraph = textInput.textAttributes?[NSAttributedString.Key.paragraphStyle] as? NSParagraphStyle else { return nil }
            return paragraph.alignment
        }
        set {
            guard let alignment = newValue else { return }
            let paragraphStyle = textAttributes?[NSAttributedString.Key.paragraphStyle] as? NSMutableParagraphStyle ?? NSMutableParagraphStyle()
            paragraphStyle.alignment = alignment
            textAttributes = [NSAttributedString.Key.paragraphStyle: paragraphStyle]
        }
    }

    open var tailIndent: CGFloat? {
        get {
            guard let paragraph = textAttributes?[NSAttributedString.Key.paragraphStyle] as? NSParagraphStyle else { return nil }
            return paragraph.tailIndent
        }
        set {
            guard let indent = newValue else { return }
            let paragraphStyle = textAttributes?[NSAttributedString.Key.paragraphStyle] as? NSMutableParagraphStyle ?? NSMutableParagraphStyle()
            paragraphStyle.tailIndent = indent
            textAttributes = [NSAttributedString.Key.paragraphStyle: paragraphStyle]
        }
    }

    open var headIndent: CGFloat? {
        get {
            guard let paragraph = textAttributes?[NSAttributedString.Key.paragraphStyle] as? NSParagraphStyle else { return nil }
            return paragraph.headIndent
        }
        set {
            guard let indent = newValue else { return }
            let paragraphStyle = textAttributes?[NSAttributedString.Key.paragraphStyle] as? NSMutableParagraphStyle ?? NSMutableParagraphStyle()
            paragraphStyle.headIndent = indent
            textAttributes = [NSAttributedString.Key.paragraphStyle: paragraphStyle]
        }
    }

    open var textAttributes: [NSAttributedString.Key: Any]? {
        didSet {
            guard var textInputAttributes = textInput.textAttributes else {
                textInput.textAttributes = textAttributes
                return
            }
            guard textAttributes != nil else {
                textInput.textAttributes = nil
                return
            }
            textInput.textAttributes = textInputAttributes.merge(dict: textAttributes!)
        }
    }

    private var _inputAccessoryView: UIView?

    open override var inputAccessoryView: UIView? {
        set {
            _inputAccessoryView = newValue
        }

        get {
            return _inputAccessoryView
        }
    }

    open var contentInset: UIEdgeInsets? {
        didSet {
            guard let insets = contentInset else { return }
            textInput.contentInset = insets
        }
    }

    open override var isUserInteractionEnabled: Bool {
        didSet {
            textInput.isUserInteractionEnabled = self.isUserInteractionEnabled;
        }
    }
    
    fileprivate let lineView = AnimatedLine()
    fileprivate let placeholderLayer = CATextLayer()
    fileprivate let counterLabel = UILabel()
    fileprivate let lineWidth: CGFloat = GIST_CONFIG.seperatorWidth;
    fileprivate let counterLabelRightMargin: CGFloat = 15
    fileprivate let counterLabelTopMargin: CGFloat = 5

    fileprivate var isResigningResponder = false
    fileprivate var isPlaceholderAsHint = false
    fileprivate var hasCounterLabel = false
    internal    var textInput: TextInput!
    fileprivate var lineToBottomConstraint: NSLayoutConstraint!
    fileprivate var textInputTrailingConstraint: NSLayoutConstraint!
    fileprivate var disclosureViewWidthConstraint: NSLayoutConstraint!
    fileprivate var disclosureView: UIView?
    fileprivate var placeholderErrorText: String?

    fileprivate var placeholderPosition: CGPoint {
        let hintPosition = CGPoint(
            x: placeholderAlignment != .natural ? 0 : iStyle.leftMargin,
            y: iStyle.yHintPositionOffset
        )
        let defaultPosition = CGPoint(
            x: placeholderAlignment != .natural ? 0 : iStyle.leftMargin,
            y: iStyle.topMargin + iStyle.yPlaceholderPositionOffset
        )
        return isPlaceholderAsHint ? hintPosition : defaultPosition
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)

        setupCommonElements()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setupCommonElements()
    }
    
    override open var intrinsicContentSize: CGSize {
        let normalHeight = textInput.view.intrinsicContentSize.height
        return CGSize(width: UIView.noIntrinsicMetric, height: normalHeight + iStyle.topMargin + iStyle.bottomMargin)
    }

    open override func updateConstraints() {
        addLineViewConstraints()
        addTextInputConstraints()
        addCharacterCounterConstraints()
        super.updateConstraints()
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        layoutPlaceholderLayer()
        
        if rounded {
            self.addRoundedCorners();
        }
        
        if (hasDropShadow) {
            self.addDropShadow();
        }
    }

    fileprivate func layoutPlaceholderLayer() {
        // Some letters like 'g' or 'á' were not rendered properly, the frame need to be about 20% higher than the font size
        let frameHeightCorrectionFactor: CGFloat = 1.2
        placeholderLayer.frame = CGRect(origin: placeholderPosition, size: CGSize(width: bounds.width, height: iStyle.textInputFont.pointSize * frameHeightCorrectionFactor))
    }

    // mark: Configuration

    fileprivate func addLineViewConstraints() {
        removeConstraints(constraints)
        pinLeading(toLeadingOf: lineView, constant: iStyle.leftMargin)
        pinTrailing(toTrailingOf: lineView, constant: iStyle.rightMargin)
        lineView.setHeight(to: lineWidth)
        let constant = hasCounterLabel ? -counterLabel.intrinsicContentSize.height - counterLabelTopMargin : 0
        lineToBottomConstraint = pinBottom(toBottomOf: lineView, constant: constant)
    }

    fileprivate func addTextInputConstraints() {
        pinLeading(toLeadingOf: textInput.view, constant: iStyle.leftMargin)
        if disclosureView == nil {
            textInputTrailingConstraint = pinTrailing(toTrailingOf: textInput.view, constant: iStyle.rightMargin)
        }
        pinTop(toTopOf: textInput.view, constant: iStyle.topMargin)
        textInput.view.pinBottom(toTopOf: lineView, constant: iStyle.bottomMargin)
    }

    fileprivate func setupCommonElements() {
        addLine()
        addPlaceHolder()
        addTapGestureRecognizer()
        addTextInput()
    }

    fileprivate func addLine() {
        lineView.defaultColor = iStyle.lineInactiveColor
        lineView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(lineView)
    }

    fileprivate func addPlaceHolder() {
        placeholderLayer.masksToBounds = false
        placeholderLayer.string = placeholder
        placeholderLayer.foregroundColor = iStyle.inactiveColor.cgColor
        placeholderLayer.fontSize = iStyle.textInputFont.pointSize
        placeholderLayer.font = iStyle.textInputFont
        placeholderLayer.contentsScale = UIScreen.main.scale
        placeholderLayer.backgroundColor = UIColor.clear.cgColor
        layoutPlaceholderLayer()
        layer.addSublayer(placeholderLayer)
    }

    fileprivate func addTapGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewWasTapped))
        addGestureRecognizer(tap)
    }

    fileprivate func addTextInput() {
        textInput = AnimatedTextInputFieldConfigurator.configure(with: type)
        textInput.textInputDelegate = self
        textInput.view.tintColor = iStyle.activeColor
        textInput.textColor = iStyle.textInputFontColor
        textInput.font = iStyle.textInputFont
        textInput.view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(textInput.view)
        invalidateIntrinsicContentSize()
    }

    fileprivate func updateCounter() {
        guard let counterText = counterLabel.text else { return }
        let components = counterText.components(separatedBy: "/")
        let characters = text?.count ?? 0
        counterLabel.text = "\(characters)/\(components[1])"
    }

    // mark: States and animations

    fileprivate func configurePlaceholderAsActiveHint() {
        isPlaceholderAsHint = true
        configurePlaceholderWith(iStyle.titleFont, fontSize: iStyle.placeholderMinFontSize,
                                 foregroundColor: iStyle.titleFontColor.cgColor,
                                 text: self.title ?? self.placeholder)
        lineView.fillLine(with: iStyle.activeColor)
    }

    fileprivate func configurePlaceholderAsInactiveHint() {
        isPlaceholderAsHint = true
        
        configurePlaceholderWith(iStyle.titleFont, fontSize: iStyle.placeholderMinFontSize,
                                 foregroundColor: iStyle.titleFontColor.cgColor,
                                 text: self.title ?? self.placeholder)
        lineView.animateToInitialState()
    }

    fileprivate func configurePlaceholderAsDefault() {
        isPlaceholderAsHint = false
        configurePlaceholderWith(iStyle.textInputFont, fontSize: iStyle.textInputFont.pointSize,
                                 foregroundColor: iStyle.inactiveColor.cgColor,
                                 text: placeholder)
        lineView.animateToInitialState()
    }

    fileprivate func configurePlaceholderAsErrorHint() {
        isPlaceholderAsHint = true
        configurePlaceholderWith(iStyle.titleFont, fontSize: iStyle.placeholderMinFontSize,
                                 foregroundColor: iStyle.errorColor.cgColor,
                                 text: placeholderErrorText)
        lineView.fillLine(with: iStyle.errorColor)
    }

    fileprivate func configurePlaceholderWith(_ font:UIFont, fontSize: CGFloat, foregroundColor: CGColor, text: String?) {
        placeholderLayer.fontSize = fontSize
        placeholderLayer.font = font;
        placeholderLayer.foregroundColor = foregroundColor
        placeholderLayer.string = text
        layoutPlaceholderLayer()
    }

    fileprivate func animatePlaceholder(to applyConfiguration: () -> Void) {
        let duration = 0.2
        let function = CAMediaTimingFunction(controlPoints: 0.3, 0.0, 0.5, 0.95)
        transactionAnimation(with: duration, timingFuncion: function, animations: applyConfiguration)
    }

    // mark: Behaviours

    public func onTap(action: @escaping () -> Void) {
        _tapAction = action;
    } //F.E.
    
    @objc fileprivate func viewWasTapped(sender: UIGestureRecognizer) {
        if let tapAction = _tapAction {
            tapAction()
        } else {
            becomeFirstResponder()
        }
    }

    fileprivate func styleDidChange() {
        lineView.defaultColor = iStyle.lineInactiveColor
        placeholderLayer.foregroundColor = iStyle.inactiveColor.cgColor
        let fontSize = iStyle.textInputFont.pointSize
        placeholderLayer.fontSize = fontSize
        placeholderLayer.font = iStyle.textInputFont
        textInput.view.tintColor = iStyle.activeColor
        textInput.textColor = iStyle.textInputFontColor
        textInput.font = iStyle.textInputFont
        invalidateIntrinsicContentSize()
        layoutIfNeeded()
    }

    @discardableResult override open func becomeFirstResponder() -> Bool {
        isActive = true
        let firstResponder = textInput.view.becomeFirstResponder()
        counterLabel.textColor = iStyle.activeColor
        placeholderErrorText = nil
        animatePlaceholder(to: configurePlaceholderAsActiveHint)
        return firstResponder
    }

    override open var isFirstResponder: Bool {
        return textInput.view.isFirstResponder
    }

    @discardableResult override open func resignFirstResponder() -> Bool {
        guard !isResigningResponder else { return true }
        isActive = false
        isResigningResponder = true
        let resignFirstResponder = textInput.view.resignFirstResponder()
        isResigningResponder = false
        counterLabel.textColor = iStyle.inactiveColor

        if let textInputError = textInput as? TextInputError {
            textInputError.removeErrorHintMessage()
        }

        // If the placeholder is showing an error we want to keep this state. Otherwise revert to inactive state.
        if placeholderErrorText == nil {
            animateToInactiveState()
        }
        return resignFirstResponder
    }

    fileprivate func animateToInactiveState() {
        guard let text = textInput.currentText, !text.isEmpty else {
            animatePlaceholder(to: configurePlaceholderAsDefault)
            return
        }
        animatePlaceholder(to: configurePlaceholderAsInactiveHint)
    }

    override open var canResignFirstResponder: Bool {
        return textInput.view.canResignFirstResponder
    }

    override open var canBecomeFirstResponder: Bool {
        guard !isResigningResponder else { return false }
        if let disclosureView = disclosureView, disclosureView.isFirstResponder {
            return false
        }
        return textInput.view.canBecomeFirstResponder
    }

    open func show(error errorMessage: String, placeholderText: String? = nil) {
        placeholderErrorText = errorMessage
        if let textInput = textInput as? TextInputError {
            textInput.configureErrorState(with: placeholderText)
        }
        animatePlaceholder(to: configurePlaceholderAsErrorHint)
    }

    open func clearError() {
        placeholderErrorText = nil
        if let textInputError = textInput as? TextInputError {
            textInputError.removeErrorHintMessage()
        }
        if isActive {
            animatePlaceholder(to: configurePlaceholderAsActiveHint)
        } else {
            animateToInactiveState()
        }
    }

    fileprivate func configureType() {
        textInput.view.removeFromSuperview()
        addTextInput()
    }
    
    open func applyStyle() {
        self.configureStyle();
    } //F.E.

    fileprivate func configureStyle() {
        styleDidChange()
        if isActive {
            configurePlaceholderAsActiveHint()
        } else {
            isPlaceholderAsHint ? configurePlaceholderAsInactiveHint() : configurePlaceholderAsDefault()
        }
    }

    open func showCharacterCounterLabel(with maximum: Int? = nil) {
        hasCounterLabel = true
        let characters = text?.count ?? 0
        if let maximumValue = maximum {
            counterLabel.text = "\(characters)/\(maximumValue)"
        } else {
            counterLabel.text = "\(characters)"
        }
        
        counterLabel.textColor = isActive ? iStyle.activeColor : iStyle.inactiveColor
        counterLabel.font = iStyle.counterLabelFont
        counterLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(counterLabel)
        invalidateIntrinsicContentSize()
    }

    fileprivate func addCharacterCounterConstraints() {
        guard hasCounterLabel else { return }
        lineToBottomConstraint.constant = -counterLabel.intrinsicContentSize.height - counterLabelTopMargin
        lineView.pinBottom(toTopOf: counterLabel, constant: counterLabelTopMargin)
        pinTrailing(toTrailingOf: counterLabel, constant: counterLabelRightMargin)
    }

    open func removeCharacterCounterLabel() {
        hasCounterLabel = false
        counterLabel.removeConstraints(counterLabel.constraints)
        counterLabel.removeFromSuperview()
        lineToBottomConstraint.constant = 0
        invalidateIntrinsicContentSize()
    }

    open func addDisclosureView(disclosureView: UIView) {
        if let constraint = textInputTrailingConstraint {
            removeConstraint(constraint)
        }
        self.disclosureView?.removeFromSuperview()
        self.disclosureView = disclosureView
        addSubview(disclosureView)
        textInputTrailingConstraint = textInput.view.pinTrailing(toLeadingOf: disclosureView, constant: 0)
        disclosureView.alignHorizontalAxis(toSameAxisOfView: textInput.view)
        disclosureView.pinBottom(toBottomOf: self, constant: 12)
        disclosureView.pinTrailing(toTrailingOf: self, constant: 16)
    }

    open func removeDisclosureView() {
        guard disclosureView != nil else { return }
        disclosureView?.removeFromSuperview()
        disclosureView = nil
        textInput.view.removeConstraint(textInputTrailingConstraint)
        textInputTrailingConstraint = pinTrailing(toTrailingOf: textInput.view, constant: iStyle.rightMargin)
    }

    open func position(from: UITextPosition, offset: Int) -> UITextPosition? {
        return textInput.currentPosition(from: from, offset: offset)
    }
    
    //MARK: - Methods
    
    open func textInputDidBeginEditing(textInput: TextInput) {
        becomeFirstResponder()
        delegate?.animatedTextInputDidBeginEditing?(animatedTextInput: self)
    }

    open func textInputDidEndEditing(textInput: TextInput) {
        resignFirstResponder()
        delegate?.animatedTextInputDidEndEditing?(animatedTextInput: self)
    }

    open func textInputDidChange(textInput: TextInput) {
        updateCounter()
        delegate?.animatedTextInputDidChange?(animatedTextInput: self)
    }

    open func textInput(textInput: TextInput, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let rtn:Bool = delegate?.animatedTextInput?(animatedTextInput: self, shouldChangeCharactersIn: range, replacementString: string) ?? true;
        
        //IF CHARACTERS-LIMIT <= ZERO, MEANS NO RESTRICTIONS ARE APPLIED
        if (self.maxCharLimit <= 0 || rtn == false || string == "") {
            return rtn;
        }
        
        guard let text = textInput.currentText else { return true }
        
        let newLength = text.utf16.count + string.utf16.count - range.length
        return (newLength <= self.maxCharLimit) // Bool
    }

    open func textInputShouldBeginEditing(textInput: TextInput) -> Bool {
        return delegate?.animatedTextInputShouldBeginEditing?(animatedTextInput: self) ?? true
    }

    open func textInputShouldEndEditing(textInput: TextInput) -> Bool {
        return delegate?.animatedTextInputShouldEndEditing?(animatedTextInput: self) ?? true
    }

    open func textInputShouldReturn(textInput: TextInput) -> Bool {
        return delegate?.animatedTextInputShouldReturn?(animatedTextInput: self) ?? true
    }
    
    open func add(disclosureButton button: UIButton, action: @escaping (() -> Void)) {
        if let animatedTextField:AnimatedTextField = self.textInput as? AnimatedTextField {
            animatedTextField.add(disclosureButton: button, action: action);
        }
    }
}

public protocol TextInput {
    var view: UIView { get }
    var currentText: String? { get set }
    var font: UIFont? { get set }
    var textColor: UIColor? { get set }
    var textAttributes: [NSAttributedString.Key: Any]? { get set }
    var textInputDelegate: TextInputDelegate? { get set }
    var currentSelectedTextRange: UITextRange? { get set }
    var currentBeginningOfDocument: UITextPosition? { get }
    var currentKeyboardAppearance: UIKeyboardAppearance { get set }
    var contentInset: UIEdgeInsets { get set }
    var autocorrection: UITextAutocorrectionType {get set}
    var autocapitalization: UITextAutocapitalizationType {get set}
    
    func configureInputView(newInputView: UIView)
    func changeReturnKeyType(with newReturnKeyType: UIReturnKeyType)
    func currentPosition(from: UITextPosition, offset: Int) -> UITextPosition?
    func changeClearButtonMode(with newClearButtonMode: UITextField.ViewMode)
    
    var keyboardType: UIKeyboardType { get set } // default is UIKeyboardTypeDefault
    
    var enablesReturnKeyAutomatically: Bool { get set } // default is NO (when YES, will automatically disable return key when text widget has zero-length contents, and will automatically enable when text widget has non-zero-length contents)
    
    var isSecureTextEntry: Bool { get set } // default is NO

    var isUserInteractionEnabled: Bool { get set }
    
    func updateData(_ data: Any?);
}

public extension TextInput where Self: UIView {
    var view: UIView {
        return self
    }
}

public protocol TextInputDelegate: class {
    func textInputDidBeginEditing(textInput: TextInput)
    func textInputDidEndEditing(textInput: TextInput)
    func textInputDidChange(textInput: TextInput)
    func textInput(textInput: TextInput, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    func textInputShouldBeginEditing(textInput: TextInput) -> Bool
    func textInputShouldEndEditing(textInput: TextInput) -> Bool
    func textInputShouldReturn(textInput: TextInput) -> Bool
}

public protocol TextInputError {
    func configureErrorState(with message: String?)
    func removeErrorHintMessage()
}

public extension CATextLayer {
    /// Describes how individual lines of text are aligned within the layer.
    ///
    /// - natural: Natural alignment.
    /// - left: Left alignment.
    /// - right: Right alignment.
    /// - center: Center alignment.
    /// - justified: Justified alignment.
    enum Alignment {
        case natural
        case left
        case right
        case center
        case justified
    }
}

fileprivate extension Dictionary {
    mutating func merge(dict: [Key: Value]) -> Dictionary {
        for (key, value) in dict { self[key] = value }
        return self
    }
}

