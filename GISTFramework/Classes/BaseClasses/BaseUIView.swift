//
//  BaseView.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 14/06/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit

public class BaseUIView: UIView, BaseView {
    
    @IBInspectable public var sizeForIPad:Bool = false;

    @IBInspectable public var bgColorStyle:String? = nil {
        didSet {
            self.backgroundColor = SyncedColors.color(forKey: bgColorStyle);
        }
    }
    
    @IBInspectable public var boarder:Int = 0 {
        didSet {
            if let boarderCStyle:String = boarderColorStyle {
                self.addBorder(SyncedColors.color(forKey: boarderCStyle), width: boarder)
            }
        }
    }
    
    @IBInspectable public var boarderColorStyle:String? = nil {
        didSet {
            if let boarderCStyle:String = boarderColorStyle {
                self.addBorder(SyncedColors.color(forKey: boarderCStyle), width: boarder)
            }
        }
    }
    
    @IBInspectable public var cornerRadius:Int = 0 {
        didSet {
            self.addRoundedCorners(UIView.convertToRatio(CGFloat(cornerRadius), sizedForIPad: sizeForIPad));
        }
    }
    
    @IBInspectable public var rounded:Bool = false {
        didSet {
            if rounded {
                self.addRoundedCorners();
            }
        }
    }
    
    @IBInspectable public var hasDropShadow:Bool = false {
        didSet {
            if (hasDropShadow) {
                self.addDropShadow();
            } else {
                // TO HANDLER
            }
        }
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
    } //F.E.
    
    public func updateView(){
        if let bgCStyle:String = self.bgColorStyle {
            self.bgColorStyle = bgCStyle;
        }
        
        if let boarderCStyle:String = self.boarderColorStyle {
            self.boarderColorStyle = boarderCStyle;
        }
    } //F.E.
    
    override public func layoutSubviews() {
        super.layoutSubviews();
        //--
        if rounded {
            self.addRoundedCorners();
        }
    } //F.E.
    
} //CLS END
