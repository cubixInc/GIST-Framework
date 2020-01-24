//
//  FloatingLabelTextField.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 14/03/2017.
//  Copyright © 2017 Social Cubix. All rights reserved.
//

import UIKit

open class FloatingLabelTextField: ValidatedTextField {
    
    // MARK: Animation timing
    
    /// The value of the title appearing duration
    open var titleFadeInDuration:TimeInterval = 0.2
    /// The value of the title disappearing duration
    open var titleFadeOutDuration:TimeInterval = 0.3
    
    // MARK: Title
    
    /// The String to display when the textfield is not editing and the input is not empty.
    @IBInspectable open var title:String? {
        didSet {
            self.updateControl();
        }
    } //P.E.
    
    /// The String to display when the textfield is editing and the input is not empty.
    @IBInspectable open var titleSelected:String? {
        didSet {
            self.updateControl();
        }
    } //P.E.
    
    // MARK: Font Style
    
    /// Font size/style key from Sync Engine.
    
    /// Font name key from Sync Engine.
    @IBInspectable open var titleFontName:String = GIST_CONFIG.fontName {
        didSet {
            self.titleLabel.fontName = self.titleFontName;
        }
    }
    
    @IBInspectable open var titleFontStyle:String = GIST_CONFIG.fontStyle {
        didSet {
            self.titleLabel.fontStyle = self.titleFontStyle;
        }
    } //P.E.
    
    // MARK: Colors
    
    /// A UIColor value that determines the text color of the title label when in the normal state
    @IBInspectable open var titleColor:String? {
        didSet {
            self.updateTitleColor();
        }
    }
    
    /// A UIColor value that determines the text color of the title label when editing
    @IBInspectable open var titleColorSelected:String? {
        didSet {
            self.updateTitleColor();
        }
    }
    
    /// A UIColor value that determines the color of the bottom line when in the normal state
    @IBInspectable open var lineColor:String? {
        didSet {
            self.updateLineView();
        }
    }
    
    /// A UIColor value that determines the color of the line in a selected state
    @IBInspectable open var lineColorSelected:String? {
        didSet {
            self.updateLineView();
        }
    } //P.E.
    
    /// A UIColor value that determines the color used for the title label and the line when the error message is not `nil`
    @IBInspectable open var errorColor:String? {
        didSet {
            self.updateColors();
        }
    } //P.E.
    
    // MARK: Title Case
    
    /// Flag for upper case formatting
    @IBInspectable open var uppercaseTitle:Bool = false {
        didSet {
            self.updateControl();
        }
    }
    
    // MARK: Line height
    
    /// A CGFloat value that determines the height for the bottom line when the control is in the normal state
    @IBInspectable open var lineHeight:CGFloat = GIST_CONFIG.seperatorWidth {
        didSet {
            self.updateLineView();
            self.setNeedsDisplay();
        }
    } //P.E.
    
    /// A CGFloat value that determines the height for the bottom line when the control is in a selected state
    @IBInspectable open var lineHeightSelected:CGFloat = GIST_CONFIG.seperatorWidth {
        didSet {
            self.updateLineView();
            self.setNeedsDisplay();
        }
    }
    
    // MARK: View components
    
    /// The internal `UIView` to display the line below the text input.
    open var lineView:UIView!
    
    /// The internal `UILabel` that displays the selected, deselected title or the error message based on the current state.
    open var titleLabel:BaseUILabel!
    
    // MARK: Properties
    
    /**
     Identifies whether the text object should hide the text being entered.
     */
    override open var isSecureTextEntry:Bool {
        set {
            super.isSecureTextEntry = newValue;
            self.fixCaretPosition();
        }
        get {
            return super.isSecureTextEntry;
        }
    }
    
    /// The backing property for the highlighted property
    fileprivate var _highlighted = false;
    
    /// A Boolean value that determines whether the receiver is highlighted. When changing this value, highlighting will be done with animation
    override open var isHighlighted:Bool {
        get {
            return _highlighted
        }
        set {
            _highlighted = newValue;
            self.updateTitleColor();
            self.updateLineView();
        }
    }
    
    /// A Boolean value that determines whether the textfield is being edited or is selected.
    open var editingOrSelected:Bool {
        get {
            return super.isEditing || self.isSelected;
        }
    }
    
    /// A Boolean value that determines whether the receiver has an error message.
    open var hasErrorMessage:Bool = false {
        didSet {
            self.updateControl(false);
        }
    }
    
    fileprivate var _renderingInInterfaceBuilder:Bool = false
    
    /// The text content of the textfield
    override open var text:String? {
        didSet {
            self.updateControl(false);
        }
    }
    
    /**
     The String to display when the input field is empty.
     The placeholder can also appear in the title label when both `title` `selectedTitle` and are `nil`.
     */
    override open var placeholder:String? {
        didSet {
            self.setNeedsDisplay();
            self.updateTitleLabel();
        }
    }
    
    // Determines whether the field is selected. When selected, the title floats above the textbox.
    open override var isSelected:Bool {
        didSet {
            self.updateControl(true);
        }
    }
    
    override open var fontName: String {
        didSet {
            self.titleLabel.fontName = self.fontName;
        }
    } // P.E.
    
    open override var isInvalidSignHidden: Bool {
        set {
            super.isInvalidSignHidden = newValue;
            
            let errorMsg:String = self.validityMsg ?? "";
            
            self.hasErrorMessage = (isInvalidSignHidden == false && errorMsg != "");
        }
        
        get {
            return super.isInvalidSignHidden
        }
    } //P.E.
    
    
    // MARK: - Initializers
    
    /**
     Initializes the control
     - parameter frame the frame of the control
     */
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupFloatingLabel();
    }
    
    /**
     Intialzies the control by deserializing it
     - parameter coder the object to deserialize the control from
     */
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        
        self.setupFloatingLabel();
    }
    
    // MARK: - Methods
    
    fileprivate final func setupFloatingLabel() {
        self.borderStyle = .none;
        self.createTitleLabel();
        self.createLineView();
        self.updateColors();
        self.addEditingChangedObserver();
    }
    
    fileprivate func addEditingChangedObserver() {
        self.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
    }
    
    /**
     Invoked when the editing state of the textfield changes. Override to respond to this change.
     */
    @objc
    open func editingChanged() {
        self.updateControl(true);
        self.updateTitleLabel(true);
    }
    
    /**
     The formatter to use before displaying content in the title label. This can be the `title`, `selectedTitle` or the `errorMessage`.
     The default implementation converts the text to uppercase.
     */
    private func titleFormatter(_ txt:String) -> String {
        let rtnTxt:String = SyncedText.text(forKey: txt);
        
        return (self.uppercaseTitle == true) ? rtnTxt.uppercased():rtnTxt;
    } //F.E.
    
    // MARK: create components
    
    private func createTitleLabel() {
        let titleLabel = BaseUILabel()
        titleLabel.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        titleLabel.fontName = self.titleFontName;
        titleLabel.fontStyle = self.titleFontStyle;
        titleLabel.alpha = 0.0
        self.addSubview(titleLabel)
        self.titleLabel = titleLabel
    }
    
    private func createLineView() {
        
        if self.lineView == nil {
            let lineView = UIView()
            lineView.isUserInteractionEnabled = false;
            self.lineView = lineView
            self.configureDefaultLineHeight()
        }
        lineView.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        self.addSubview(lineView)
    }
    
    private func configureDefaultLineHeight() {
        //??let onePixel:CGFloat = 1.0 / UIScreen.main.scale
        self.lineHeight = GIST_CONFIG.seperatorWidth;
        self.lineHeightSelected = GIST_CONFIG.seperatorWidth;
    }
    
    // MARK: Responder handling
    
    open override func updateData(_ data: Any?) {
        super.updateData(data);
        
        let dicData:NSMutableDictionary? = data as? NSMutableDictionary;
        
        self.title = dicData?["title"] as? String;
    } //F.E.
    
    /**
     Attempt the control to become the first responder
     - returns: True when successfull becoming the first responder
     */
    @discardableResult
    override open func becomeFirstResponder() -> Bool {
        let result = super.becomeFirstResponder()
        self.updateControl(true)
        return result
    }
    
    /**
     Attempt the control to resign being the first responder
     - returns: True when successfull resigning being the first responder
     */
    @discardableResult
    override open func resignFirstResponder() -> Bool {
        let result =  super.resignFirstResponder()
        self.updateControl(true)
        return result
    }
    
    // MARK: - View updates
    
    private func updateControl(_ animated:Bool = false) {
        self.updateColors()
        self.updateLineView()
        self.updateTitleLabel(animated)
    }
    
    private func updateLineView() {
        if let lineView = self.lineView {
            lineView.frame = self.lineViewRectForBounds(self.bounds, editing: self.editingOrSelected)
        }
        self.updateLineColor()
    }
    
    // MARK: - Color updates
    
    /// Update the colors for the control. Override to customize colors.
    open func updateColors() {
        self.updateLineColor()
        self.updateTitleColor()
        self.updateTextColor()
    }
    
    private func updateLineColor() {
        if self.hasErrorMessage {
            self.lineView.backgroundColor = UIColor.color(forKey: self.errorColor) ?? UIColor.red;
        } else {
            self.lineView.backgroundColor = UIColor.color(forKey: (self.editingOrSelected && self.lineColorSelected != nil) ? (self.lineColorSelected) : self.lineColor);
        }
    }
    
    private func updateTitleColor() {
        if self.hasErrorMessage {
            self.titleLabel.textColor = UIColor.color(forKey: self.errorColor) ?? UIColor.red;
        } else {
            if ((self.editingOrSelected || self.isHighlighted) && self.titleColorSelected != nil) {
                self.titleLabel.textColor = UIColor.color(forKey: self.titleColorSelected);
            } else {
                self.titleLabel.textColor = UIColor.color(forKey: self.titleColor);
            }
        }
    }
    
    private func updateTextColor() {
        if self.hasErrorMessage {
            super.textColor = UIColor.color(forKey: self.errorColor);
        } else {
            super.textColor = UIColor.color(forKey: self.fontColorStyle);
        }
    }
    
    // MARK: - Title handling
    
    private func updateTitleLabel(_ animated:Bool = false) {
        
        var titleText:String? = nil
        if self.hasErrorMessage {
            titleText = self.titleFormatter(self.validityMsg!)
        } else {
            if self.editingOrSelected {
                titleText = self.selectedTitleOrTitlePlaceholder()
                if titleText == nil {
                    titleText = self.titleOrPlaceholder()
                }
            } else {
                titleText = self.titleOrPlaceholder()
            }
        }
        self.titleLabel.text = titleText
        
        self.updateTitleVisibility(animated)
    }
    
    private var _titleVisible = false
    
    /*
     *   Set this value to make the title visible
     */
    open func setTitleVisible(_ titleVisible:Bool, animated:Bool = false, animationCompletion: ((_ completed: Bool) -> Void)? = nil) {
        if(_titleVisible == titleVisible) {
            return
        }
        _titleVisible = titleVisible
        self.updateTitleColor()
        self.updateTitleVisibility(animated, completion: animationCompletion)
    }
    
    /**
     Returns whether the title is being displayed on the control.
     - returns: True if the title is displayed on the control, false otherwise.
     */
    open func isTitleVisible() -> Bool {
        return self.hasText || self.hasErrorMessage || _titleVisible
    }
    
    fileprivate func updateTitleVisibility(_ animated:Bool = false, completion: ((_ completed: Bool) -> Void)? = nil) {
        let alpha:CGFloat = self.isTitleVisible() ? 1.0 : 0.0
        let frame:CGRect = self.titleLabelRectForBounds(self.bounds, editing: self.isTitleVisible())
        let updateBlock = { () -> Void in
            self.titleLabel.alpha = alpha
            self.titleLabel.frame = frame
        }
        if animated {
            let animationOptions:UIView.AnimationOptions = .curveEaseOut;
            let duration = self.isTitleVisible() ? titleFadeInDuration : titleFadeOutDuration
            
            UIView.animate(withDuration: duration, delay: 0, options: animationOptions, animations: { () -> Void in
                updateBlock()
            }, completion: completion)
        } else {
            updateBlock()
            completion?(true)
        }
    }
    
    // MARK: - UITextField text/placeholder positioning overrides
    
    /**
     Calculate the rectangle for the textfield when it is not being edited
     - parameter bounds: The current bounds of the field
     - returns: The rectangle that the textfield should render in
     */
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        _ = super.textRect(forBounds: bounds);
        let titleHeight = self.titleHeight()
        let lineHeight = self.lineHeightSelected
        let rect = CGRect(x: 0, y: titleHeight, width: bounds.size.width, height: bounds.size.height - titleHeight - lineHeight)
        return rect
    }
    
    /**
     Calculate the rectangle for the textfield when it is being edited
     - parameter bounds: The current bounds of the field
     - returns: The rectangle that the textfield should render in
     */
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        let titleHeight = self.titleHeight()
        let lineHeight = self.lineHeightSelected
        let rect = CGRect(x: 0, y: titleHeight, width: bounds.size.width, height: bounds.size.height - titleHeight - lineHeight)
        return rect
    }
    
    /**
     Calculate the rectangle for the placeholder
     - parameter bounds: The current bounds of the placeholder
     - returns: The rectangle that the placeholder should render in
     */
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        let titleHeight = self.titleHeight()
        let lineHeight = self.lineHeightSelected
        let rect = CGRect(x: 0, y: titleHeight, width: bounds.size.width, height: bounds.size.height - titleHeight - lineHeight)
        return rect
    }
    
    // MARK: - Positioning Overrides
    
    /**
     Calculate the bounds for the title label. Override to create a custom size title field.
     - parameter bounds: The current bounds of the title
     - parameter editing: True if the control is selected or highlighted
     - returns: The rectangle that the title label should render in
     */
    open func titleLabelRectForBounds(_ bounds:CGRect, editing:Bool) -> CGRect {
        let titleHeight = self.titleHeight()
        if editing {
            return CGRect(x: 0, y: 0, width: bounds.size.width, height: titleHeight)
        }
        return CGRect(x: 0, y: titleHeight, width: bounds.size.width, height: titleHeight)
    }
    
    /**
     Calculate the bounds for the bottom line of the control. Override to create a custom size bottom line in the textbox.
     - parameter bounds: The current bounds of the line
     - parameter editing: True if the control is selected or highlighted
     - returns: The rectangle that the line bar should render in
     */
    open func lineViewRectForBounds(_ bounds:CGRect, editing:Bool) -> CGRect {
        let lineHeight:CGFloat = editing ? CGFloat(self.lineHeightSelected) : CGFloat(self.lineHeight)
        return CGRect(x: 0, y: bounds.size.height - lineHeight, width: bounds.size.width, height: lineHeight);
    }
    
    /**
     Calculate the height of the title label.
     -returns: the calculated height of the title label. Override to size the title with a different height
     */
    open func titleHeight() -> CGFloat {
        if let titleLabel = self.titleLabel,
            let font = titleLabel.font {
            return font.lineHeight
        }
        return GISTUtility.convertToRatio(15.0, sizedForIPad: self.sizeForIPad);
    }
    
    /**
     Calcualte the height of the textfield.
     -returns: the calculated height of the textfield. Override to size the textfield with a different height
     */
    open func textHeight() -> CGFloat {
        return self.font!.lineHeight + GISTUtility.convertToRatio(7.0, sizedForIPad: self.sizeForIPad);
    }
    
    // MARK: - Layout
    
    /// Invoked when the interface builder renders the control
    override open func prepareForInterfaceBuilder() {
        if #available(iOS 8.0, *) {
            super.prepareForInterfaceBuilder()
        }
        
        self.borderStyle = .none
        
        self.isSelected = true
        _renderingInInterfaceBuilder = true
        self.updateControl(false)
        self.invalidateIntrinsicContentSize()
    }
    
    /// Invoked by layoutIfNeeded automatically
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        self.titleLabel.frame = self.titleLabelRectForBounds(self.bounds, editing: self.isTitleVisible() || _renderingInInterfaceBuilder)
        self.lineView.frame = self.lineViewRectForBounds(self.bounds, editing: self.editingOrSelected || _renderingInInterfaceBuilder)
    }
    
    /**
     Calculate the content size for auto layout
     
     - returns: the content size to be used for auto layout
     */
    override open var intrinsicContentSize : CGSize {
        return CGSize(width: self.bounds.size.width, height: self.titleHeight() + self.textHeight())
    }
    
    // MARK: - Helpers
    
    fileprivate func titleOrPlaceholder() -> String? {
        if let title = self.title ?? self.placeholder {
            return self.titleFormatter(title)
        }
        return nil
    }
    
    fileprivate func selectedTitleOrTitlePlaceholder() -> String? {
        if let title = self.titleSelected ?? self.title ?? self.placeholder {
            return self.titleFormatter(title)
        }
        return nil
    }
} //CLS END
