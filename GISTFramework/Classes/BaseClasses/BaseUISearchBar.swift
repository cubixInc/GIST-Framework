//
//  BaseUISearchBar.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 14/06/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit

extension UISearchBar {
    var textField: UITextField? {
        get {
            return self.valueForKey("_searchField") as? UITextField
        }
    }
}

public class BaseUISearchBar: UISearchBar, BaseView {

    @IBInspectable public var bgColorStyle:String! = nil;
    
    @IBInspectable public var boarder:Int?;
    @IBInspectable public var boarderColorStyle:String?;
    
    @IBInspectable public var tintColorStyle:String?;
    @IBInspectable public var barTintColorStyle:String?;
    
    @IBInspectable public var cornerRadius:Int?;
    
    @IBInspectable public var fontStyle:String = "medium";
    @IBInspectable public var fontColorStyle:String! = nil;
    
    private var _placeholderKey:String?
    override public var placeholder: String? {
        get {
            return super.placeholder;
        }
        
        set {
            if let key:String = newValue where key.hasPrefix("#") == true{
                _placeholderKey = key; // holding key for using later
                //--
                super.placeholder = SyncedText.text(forKey: key);
            } else {
                super.placeholder = newValue;
            }
        }
    } //P.E.
    
    override public init(frame: CGRect) {
       
        super.init(frame: frame);
        
        self.updateView();
    }

    required public init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder);
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib();
        //--
        self.updateView();
    } //F.E.
    
    public func updateView() {
        //DOING NOTHING FOR NOW
        
        if let placeHoldertxt:String = self.placeholder where placeHoldertxt.hasPrefix("#") == true{
            self.placeholder = placeHoldertxt; // Assigning again to set value from synced data
        } else if _placeholderKey != nil {
            self.placeholder = _placeholderKey;
        }
        
        if let tintColorStyle:String = tintColorStyle {
            self.tintColor =  SyncedColors.color(forKey: tintColorStyle);
        }
        
        if let barTintColorStyle:String = barTintColorStyle {
            self.barTintColor =  SyncedColors.color(forKey: barTintColorStyle);
            //??self.backgroundColor =  SyncedColors.color(forKey: bgColor);
        }
        
        if let txtField:UITextField = self.textField {
            txtField.font = UIView.font(fontStyle);
            
            if (fontColorStyle != nil) {
                txtField.textColor = SyncedColors.color(forKey: fontColorStyle);
            }
            
            if let bgColor:String = bgColorStyle {
                txtField.backgroundColor =  SyncedColors.color(forKey: bgColor);
            }
            
            if let cornerRad:Int = cornerRadius {
                txtField.addRoundedCorners(UIView.convertToRatio(CGFloat(cornerRad)));
            }
            
            if let boder:Int = boarder {
                txtField.addBorder(SyncedColors.color(forKey: boarderColorStyle), width: boder);
            }
        }
        
    } //F.E.

} //CLS END
