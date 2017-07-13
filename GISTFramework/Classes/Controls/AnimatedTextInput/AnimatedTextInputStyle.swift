import UIKit

public protocol AnimatedTextInputStyle {
    var sizeForIPad:Bool? { get }
    
    var activeColor: String? { get }
    var inactiveColor: String? { get }
    var lineInactiveColor: String? { get }
    var errorColor: String? { get }
    
    var textFontName: String? { get }
    var textFontStyle: String? { get }
    
    var textFontColor: String? { get }
    
    var counterLabelFontName: String? { get }
    var counterLabelFontStyle: String? { get }
    
    var placeholderMinFontStyle: String? { get }
    
    var leftMargin: CGFloat? { get }
    var topMargin: CGFloat? { get }
    var rightMargin: CGFloat? { get }
    var bottomMargin: CGFloat? { get }
    
    var yHintPositionOffset: CGFloat? { get }
    var yPlaceholderPositionOffset: CGFloat? { get }
    
    var textAttributes: [String: Any]? { get }
}

struct InternalAnimatedTextInputStyle {
    let sizeForIPad:Bool;
    let activeColor: UIColor;
    let inactiveColor: UIColor;
    let lineInactiveColor: UIColor;
    let errorColor: UIColor;
    let textInputFont: UIFont;
    let textInputFontColor: UIColor;
    let placeholderMinFontSize: CGFloat;
    let counterLabelFont: UIFont;
    let leftMargin: CGFloat;
    let topMargin: CGFloat;
    let rightMargin: CGFloat;
    let bottomMargin: CGFloat;
    let yHintPositionOffset: CGFloat;
    let yPlaceholderPositionOffset: CGFloat;
    let textAttributes: [String: Any]?;

    init(_ style:AnimatedTextInputStyle?) {
        sizeForIPad = style?.sizeForIPad ?? GIST_CONFIG.sizeForIPad;
        
        activeColor = SyncedColors.color(forKey: style?.activeColor) ?? UIColor(red: 51.0/255.0, green: 175.0/255.0, blue: 236.0/255.0, alpha: 1.0);
        inactiveColor = SyncedColors.color(forKey: style?.inactiveColor) ?? UIColor.gray.withAlphaComponent(0.5);
        lineInactiveColor = SyncedColors.color(forKey: style?.lineInactiveColor) ?? UIColor.gray.withAlphaComponent(0.2);
        errorColor = SyncedColors.color(forKey: style?.errorColor) ?? UIColor.red;
        
        textInputFont = UIFont.font(style?.textFontName, fontStyle: style?.textFontStyle, sizedForIPad: sizeForIPad);
        
        textInputFontColor = SyncedColors.color(forKey: style?.textFontColor) ?? UIColor.black;
        
        placeholderMinFontSize =  GISTUtility.convertToRatio(CGFloat(SyncedFontStyles.style(forKey: style?.placeholderMinFontStyle ?? "small")));
        
        counterLabelFont =  UIFont.font(style?.counterLabelFontName, fontStyle: style?.counterLabelFontStyle, sizedForIPad: sizeForIPad);
        
        leftMargin = style?.leftMargin ?? 15;
        rightMargin = style?.rightMargin ?? 15;
        topMargin = GISTUtility.convertToRatio(style?.topMargin ?? 25);
        bottomMargin = GISTUtility.convertToRatio(style?.bottomMargin ?? 20);
        
        yHintPositionOffset = GISTUtility.convertToRatio(style?.yHintPositionOffset ?? 5);
        yPlaceholderPositionOffset = GISTUtility.convertToRatio(style?.yPlaceholderPositionOffset ?? 0);
        
        textAttributes = style?.textAttributes;
    }
} // CLS End


/*
public struct AnimatedTextInputStyleBlue: AnimatedTextInputStyle {

    public let activeColor = UIColor(red: 51.0/255.0, green: 175.0/255.0, blue: 236.0/255.0, alpha: 1.0)
    public let inactiveColor = UIColor.gray.withAlphaComponent(0.5)
    public let lineInactiveColor = UIColor.gray.withAlphaComponent(0.2)
    public let errorColor = UIColor.red
    public let textInputFont = UIFont.systemFont(ofSize: 14)
    public let textInputFontColor = UIColor.black
    public let placeholderMinFontSize: CGFloat = 9
    public let counterLabelFont: UIFont? = UIFont.systemFont(ofSize: 9)
    public let leftMargin: CGFloat = 25
    public let topMargin: CGFloat = 20
    public let rightMargin: CGFloat = 0
    public let bottomMargin: CGFloat = 10
    public let yHintPositionOffset: CGFloat = 7
    public let yPlaceholderPositionOffset: CGFloat = 0
    //Text attributes will override properties like textInputFont, textInputFontColor...
    public let textAttributes: [String: Any]? = nil

    public init() { }
}
*/
