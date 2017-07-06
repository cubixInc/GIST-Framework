//
//  MaskedPhoneTextFieldDelegate.swift
//  Pods
//
//  Created by Shoaib Abdul on 06/07/2017.
//
//

import UIKit
import PhoneNumberKit

@objc public protocol MaskedPhoneTextFieldDelegateListener: UITextFieldDelegate {
    
    /**
     Callback to return extracted value and to signal whether the user has complete input.
     */
    @objc optional func textField(
        _ textField: UITextField,
        didMaskPhoneWithExtractValue value: String
    )
    
} //P.E.

struct PhoneNumberConstants {
    static let defaultCountry = "US"
    static let defaultExtnPrefix = " ext. "
    static let longPhoneNumber = "999999999999999"
    static let minLengthForNSN = 2
    static let maxInputStringLength = 250
    static let maxLengthCountryCode = 3
    static let maxLengthForNSN = 16
    static let nonBreakingSpace = "\u{00a0}"
    static let plusChars = "+＋"
    static let validDigitsString = "0-9０-９٠-٩۰-۹"
    static let digitPlaceholder = "\u{2008}"
    static let separatorBeforeNationalNumber = " "
}

open class MaskedPhoneTextFieldDelegate: NSObject, UITextFieldDelegate {
    
    open weak var listener: MaskedPhoneTextFieldDelegateListener?
    
    let phoneNumberKit = PhoneNumberKit()
    
    /// Override region to set a custom region. Automatically uses the default region code.
    public var defaultRegion = PhoneNumberKit.defaultRegionCode() {
        didSet {
            partialFormatter.defaultRegion = defaultRegion
        }
    }
    
    public var isPartialFormatterEnabled = true
    
    var partialFormatter: PartialFormatter!;
    
    private var _textField: UITextField!;
    
    var withPrefix: Bool = true;
    
    let nonNumericSet: NSCharacterSet = {
        var mutableSet = NSMutableCharacterSet.decimalDigit().inverted
        mutableSet.remove(charactersIn: PhoneNumberConstants.plusChars)
        return mutableSet as NSCharacterSet
    }()
    
    //MARK: Status
    
    public var currentRegion: String {
        get {
            return partialFormatter.currentRegion
        }
    }
    
    //MARK: Lifecycle
    
    /**
     Init
     */
    public init(with textField:UITextField) {
        super.init();
        
        self.partialFormatter = PartialFormatter(phoneNumberKit: phoneNumberKit, defaultRegion: defaultRegion, withPrefix: withPrefix)
        
        _textField = textField;
        
        self.setup();
    }
    
    
    func setup(){
        _textField.autocorrectionType = .no
        _textField.keyboardType = UIKeyboardType.phonePad
    }
    
    public func applyMask() -> (formattedText:String, extractedValue:String) {
        
        var rawNumberString:String = "";
        var formattedNationalNumber = "";
        
        if let inputTxt = _textField.text {
            let filteredCharacters = inputTxt.characters.filter {
                return  String($0).rangeOfCharacter(from: self.nonNumericSet as CharacterSet) == nil
            }
            
            rawNumberString = String(filteredCharacters)
            formattedNationalNumber = partialFormatter.formatPartial(rawNumberString);
        }
        
        return (formattedNationalNumber, rawNumberString);
    } //F.E.
    
    // MARK: Phone number formatting
    
    /**
     *  To keep the cursor position, we find the character immediately after the cursor and count the number of times it repeats in the remaining string as this will remain constant in every kind of editing.
     */
    
    internal struct CursorPosition {
        let numberAfterCursor: String
        let repetitionCountFromEnd: Int
    }
    
    internal func extractCursorPosition() -> CursorPosition? {
        var repetitionCountFromEnd = 0
        // Check that there is text in the UITextField
        
        guard let text = _textField.text, let selectedTextRange = _textField.selectedTextRange else {
            return nil
        }
        let textAsNSString = text as NSString
        let cursorEnd = _textField.offset(from: _textField.beginningOfDocument, to: selectedTextRange.end)
        // Look for the next valid number after the cursor, when found return a CursorPosition struct
        for i in cursorEnd ..< textAsNSString.length  {
            let cursorRange = NSMakeRange(i, 1)
            let candidateNumberAfterCursor: NSString = textAsNSString.substring(with: cursorRange) as NSString
            if (candidateNumberAfterCursor.rangeOfCharacter(from: nonNumericSet as CharacterSet).location == NSNotFound) {
                for j in cursorRange.location ..< textAsNSString.length  {
                    let candidateCharacter = textAsNSString.substring(with: NSMakeRange(j, 1))
                    if candidateCharacter == candidateNumberAfterCursor as String {
                        repetitionCountFromEnd += 1
                    }
                }
                return CursorPosition(numberAfterCursor: candidateNumberAfterCursor as String, repetitionCountFromEnd: repetitionCountFromEnd)
            }
        }
        return nil
    }
    
    // Finds position of previous cursor in new formatted text
    internal func selectionRangeForNumberReplacement(textField: UITextField, formattedText: String) -> NSRange? {
        let textAsNSString = formattedText as NSString
        var countFromEnd = 0
        guard let cursorPosition = extractCursorPosition() else {
            return nil
        }
        
        for i in stride(from: (textAsNSString.length - 1), through: 0, by: -1) {
            let candidateRange = NSMakeRange(i, 1)
            let candidateCharacter = textAsNSString.substring(with: candidateRange)
            if candidateCharacter == cursorPosition.numberAfterCursor {
                countFromEnd += 1
                if countFromEnd == cursorPosition.repetitionCountFromEnd {
                    return candidateRange
                }
            }
        }
        
        return nil
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // allow delegate to intervene
        guard self.listener?.textField?(textField, shouldChangeCharactersIn: range, replacementString: string) ?? true else {
            return false
        }
        
        guard let text = textField.text else {
            return false
        }
        
        guard isPartialFormatterEnabled else {
            return true
        }
        
        let textAsNSString = text as NSString
        let changedRange = textAsNSString.substring(with: range) as NSString
        let modifiedTextField = textAsNSString.replacingCharacters(in: range, with: string)
        
        let filteredCharacters = modifiedTextField.characters.filter {
            return  String($0).rangeOfCharacter(from: self.nonNumericSet as CharacterSet) == nil
        }
        let rawNumberString = String(filteredCharacters)
        
        let formattedNationalNumber = partialFormatter.formatPartial(rawNumberString as String)
        var selectedTextRange: NSRange?
        
        let nonNumericRange = (changedRange.rangeOfCharacter(from: nonNumericSet as CharacterSet).location != NSNotFound)
        if (range.length == 1 && string.isEmpty && nonNumericRange)
        {
            selectedTextRange = selectionRangeForNumberReplacement(textField: textField, formattedText: modifiedTextField)
            textField.text = modifiedTextField
        } else {
            selectedTextRange = selectionRangeForNumberReplacement(textField: textField, formattedText: formattedNationalNumber)
            textField.text = formattedNationalNumber
        }
        
        self.listener?.textField?(textField, didMaskPhoneWithExtractValue: rawNumberString);
        
        if let selectedTextRange = selectedTextRange, let selectionRangePosition = textField.position(from: _textField.beginningOfDocument, offset: selectedTextRange.location) {
            let selectionRange = textField.textRange(from: selectionRangePosition, to: selectionRangePosition)
            textField.selectedTextRange = selectionRange
        }
        
        return false
    }
    
    //MARK: UITextfield Delegate
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return self.listener?.textFieldShouldBeginEditing?(textField) ?? true
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        self.listener?.textFieldDidBeginEditing?(textField)
    }
    
    public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return self.listener?.textFieldShouldEndEditing?(textField) ?? true
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        self.listener?.textFieldDidEndEditing?(textField)
    }
    
    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return self.listener?.textFieldShouldClear?(textField) ?? true
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return self.listener?.textFieldShouldReturn?(textField) ?? true
    }
} //CLS END
