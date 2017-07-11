import UIKit

public class AnimatedTextInputStyle {
    
    public var sizeForIPad:Bool = GIST_CONFIG.sizeForIPad;
    
    public var activeColorStyle: String?;
    public var inactiveColorStyle: String?;
    public var lineInactiveColorStyle: String?;
    public var errorColorStyle: String?;
    
    public var textFontName: String? = GIST_CONFIG.fontName;
    public var textFontStyle: String? = GIST_CONFIG.fontStyle;
    
    public var textFontColorStyle: String?;
    
    public var counterLabelFontName: String? = GIST_CONFIG.fontName;
    public var counterLabelFontStyle: String? = GIST_CONFIG.fontStyle;
    
    public var placeholderMinFontStyle: String = "small";
    
    private var _leftMargin: CGFloat = GISTUtility.convertToRatio(10);
    public var leftMargin: CGFloat {
        get {
            return _leftMargin;
        }
        
        set {
            _leftMargin = GISTUtility.convertToRatio(newValue);
        }
    }
    
    private var _topMargin: CGFloat = GISTUtility.convertToRatio(25);
    public var topMargin: CGFloat {
        get {
            return _topMargin;
        }
        
        set {
            _topMargin = GISTUtility.convertToRatio(newValue);
        }
    }
    
    
    private var _rightMargin: CGFloat = GISTUtility.convertToRatio(10);
    public var rightMargin: CGFloat {
        get {
            return _rightMargin;
        }
        
        set {
            _rightMargin = GISTUtility.convertToRatio(newValue);
        }
    }
    
    private var _bottomMargin: CGFloat =  GISTUtility.convertToRatio(20);
    public var bottomMargin: CGFloat {
        get {
            return _bottomMargin;
        }
        
        set {
            _bottomMargin = GISTUtility.convertToRatio(newValue);
        }
    }
    
    private var _yHintPositionOffset: CGFloat =  GISTUtility.convertToRatio(5);
    public var yHintPositionOffset: CGFloat {
        get {
            return _yHintPositionOffset;
        }
        
        set {
            _yHintPositionOffset = GISTUtility.convertToRatio(newValue);
        }
    }
    
    private var _yPlaceholderPositionOffset: CGFloat = 0;
    public var yPlaceholderPositionOffset: CGFloat {
        get {
            return _yPlaceholderPositionOffset;
        }
        
        set {
            _yPlaceholderPositionOffset = GISTUtility.convertToRatio(newValue);
        }
    }
    
    public var textAttributes: [String: Any]? = nil
    
    var textInputFont:UIFont {
        get {
            return UIFont.font(textFontName, fontStyle: textFontStyle, sizedForIPad: sizeForIPad);
        }
    }
    
    var counterLabelFont:UIFont {
        get {
            return UIFont.font(counterLabelFontName, fontStyle: counterLabelFontStyle, sizedForIPad: sizeForIPad);
        }
    }
    
    var activeColor: UIColor {
        get {
            return SyncedColors.color(forKey: activeColorStyle) ?? UIColor(red: 51.0/255.0, green: 175.0/255.0, blue: 236.0/255.0, alpha: 1.0);
        }
    }
    
    var inactiveColor: UIColor {
        get {
            return SyncedColors.color(forKey: inactiveColorStyle) ?? UIColor.gray.withAlphaComponent(0.5);
        }
    }
    
    var lineInactiveColor: UIColor {
        get {
            return SyncedColors.color(forKey: lineInactiveColorStyle) ?? UIColor.gray.withAlphaComponent(0.2);
        }
    }
    
    var errorColor: UIColor {
        get {
            return SyncedColors.color(forKey: errorColorStyle) ?? UIColor.red;
        }
    }
    
    var textInputFontColor: UIColor {
        get {
            return SyncedColors.color(forKey: textFontColorStyle) ?? UIColor.black;
        }
    }
    
    var placeholderMinFontSize: CGFloat {
        get {
            let fSize:CGFloat = CGFloat(SyncedFontStyles.style(forKey: placeholderMinFontStyle))
            
            return GISTUtility.convertToRatio(fSize);
        }
    };
    
}

/*
class AnimatedTextInputStyle:NSObject {
    var activeColor: UIColor = UIColor(red: 51.0/255.0, green: 175.0/255.0, blue: 236.0/255.0, alpha: 1.0);
    var inactiveColor: UIColor = UIColor.gray.withAlphaComponent(0.5);
    var lineInactiveColor: UIColor = UIColor.gray.withAlphaComponent(0.2);
    var errorColor: UIColor = UIColor.red;
    var textInputFont: UIFont = UIFont.systemFont(ofSize: 14);
    var textInputFontColor: UIColor = UIColor.black;
    var placeholderMinFontSize: CGFloat = 9;
    var counterLabelFont: UIFont? =  UIFont.systemFont(ofSize: 9);
    var leftMargin: CGFloat = 25;
    var topMargin: CGFloat = 20;
    var rightMargin: CGFloat = 0;
    var bottomMargin: CGFloat = 10;
    var yHintPositionOffset: CGFloat = 7;
    var yPlaceholderPositionOffset: CGFloat = 0;
    
    Xvar textAttributes: [String: Any]? = nil
}
*/

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
