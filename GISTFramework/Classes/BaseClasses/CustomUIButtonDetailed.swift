//
//  CustomButton.swift
//  eGrocery
//
//  Created by Shoaib on 3/10/15.
//  Copyright (c) 2015 cubixlabs. All rights reserved.
//

import UIKit

class CustomUIButtonDetailed: CustomUIButton {
    
    @IBInspectable var detailText:String? {
        get {
            return self.detailLabel.text;
        }
        
        set {
            self.detailLabel.text = newValue;
        }
    } //P.E.
    
    @IBInspectable var dFontStyle:String = "Medium";
    @IBInspectable var dFontColorStyle:String?;
    
    private var _detailOffSet:CGPoint = CGPoint.zero;
    @IBInspectable var detailOffSet:CGPoint {
        set {
            _detailOffSet = newValue;
        }
        
        get {
            return UIView.convertPointToRatio(_detailOffSet);
        }
    } //P.E.
    
    private var _detailLabel: BaseUILabel?;
    var detailLabel: BaseUILabel {
        get {
            if (_detailLabel == nil) {
                _detailLabel = BaseUILabel();
                _detailLabel!.textAlignment = NSTextAlignment.Center;
                _detailLabel!.backgroundColor = UIColor.clearColor();
                self.addSubview(_detailLabel!);
            }
            
            return _detailLabel!;
        }
    } //P.E.
    
    internal override var offSetFix:CGPoint {
        get {
            let offSetV1:CGPoint = self.titleOffSet;
            let offSetV2:CGPoint = self.detailOffSet;
            //--
            let offSetFixV:CGPoint = CGPoint(x: (offSetV1.x == 0 || !self.containtCenter) ?0:self.titleLabel!.frame.size.width + self.detailLabel.frame.size.width + offSetV1.x + offSetV2.x, y: (offSetV1.y == 0 || !self.containtCenter) ?0:self.titleLabel!.frame.size.height + self.detailLabel.frame.size.height + offSetV1.y + offSetV1.y);
            
            return offSetFixV;
        }
    } //P.E.
    
    private var detailLabelFrame:CGRect {
        get {
            let offSet:CGPoint = self.detailOffSet;
            //--
            var rFrame:CGRect = self.detailLabel.frame;
            
            if (offSet.x == 0) {
                rFrame.origin.x = self.imageView!.frame.origin.x + ((self.imageView!.frame.size.width - rFrame.size.width) / 2.0);
            } else if (self.reversedOrder) {
                rFrame.origin.x = self.titleLabel!.frame.origin.x - rFrame.size.width - offSet.x;
            } else {
                rFrame.origin.x = self.titleLabel!.frame.origin.x + self.titleLabel!.frame.size.width + offSet.x;
            }
            
            
            if (offSet.y == 0) {
                rFrame.origin.y = self.imageView!.frame.origin.y + ((self.imageView!.frame.size.height - rFrame.size.height) / 2.0);
            } else if (self.reversedOrder) {
                rFrame.origin.y = self.titleLabel!.frame.origin.y - rFrame.size.height - offSet.y;
            } else {
                rFrame.origin.y = self.titleLabel!.frame.origin.y + self.titleLabel!.frame.size.height + offSet.y;
            }
            
            return rFrame;
        }
    } //F.E.
    
    override func updateView()  {
        super.updateView();
        
        self.detailLabel.font = self.titleLabel!.font;
        
        self.detailLabel.fontStyle = self.dFontStyle;
        self.detailLabel.fontColorStyle = self.dFontColorStyle;
        
        self.detailLabel.updateView();
    } //F.E.
    
    override func layoutSubviews() {
        super.layoutSubviews();
        //--
        self.detailLabel.sizeToFit();
        //--
        self.detailLabel.frame = self.detailLabelFrame;
    } //F.E.
} //CLS END
