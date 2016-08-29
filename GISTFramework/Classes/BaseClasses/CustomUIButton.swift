//
//  CustomButton.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 14/06/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit

public class CustomUIButton: BaseUIButton {
    
    @IBInspectable public var imgBgColorStyle:String? = nil {
        didSet {
            self.imageView?.backgroundColor = SyncedColors.color(forKey: imgBgColorStyle);
        }
    }
    
    private var _titleOffSet:CGPoint = CGPoint.zero;
    @IBInspectable public var titleOffSet:CGPoint {
        set {
            _titleOffSet = newValue;
        }
        
        get {
            return UIView.convertPointToRatio(_titleOffSet);
        }
    } //P.E.
    
    private var _containtOffSet:CGPoint = CGPoint.zero;
    @IBInspectable public var containtOffSet:CGPoint {
        set {
            _containtOffSet = newValue;
        }
        
        get {
            return _containtOffSet;
        }
    } //P.E.
    
    private var _containtCenter:Bool = true;
    @IBInspectable public var containtCenter:Bool {
        set {
            _containtCenter = newValue;
        }
        
        get {
            return _containtCenter;
        }
    } //P.E.
    
    private var _reversedOrder:Bool = false;
    @IBInspectable public var reversedOrder:Bool {
        set {
            _reversedOrder = newValue;
        }
        
        get {
            return _reversedOrder;
        }
    } //P.E.
    
    internal var offSetFix:CGPoint {
        get {
            let offSetV:CGPoint = self.titleOffSet;
            //--
            let offSetFixV:CGPoint = CGPoint(x: (offSetV.x == 0 || !_containtCenter) ?0:self.titleLabel!.frame.size.width + offSetV.x, y: (offSetV.y == 0 || !_containtCenter) ?0:self.titleLabel!.frame.size.height + offSetV.y);
            
            return offSetFixV;
        }
    } //P.E.

    public var imageViewFrame:CGRect {
        get {
            
            var rFrame:CGRect = CGRect();
            //--
            if (self.imageView!.image != nil)
            {
                let imgSize:CGSize = self.imageView!.image!.size;
                //--
                let imgRatio:CGFloat = (imgSize.height / imgSize.width);
                //--
                
                rFrame.size.width =  UIView.convertToRatio(imgSize.width);
                rFrame.size.height =  imgRatio * rFrame.width;
                //--
                
                let offSetFix:CGPoint = self.offSetFix;
                
                switch (self.contentMode)
                {
                    
                case .Top:
                    rFrame.origin.x = (self.frame.size.width - rFrame.size.width - offSetFix.x)/2.0;
                    
                    if (_reversedOrder) {
                        rFrame.origin.y = _containtOffSet.y + offSetFix.y;
                    } else {
                        rFrame.origin.y = _containtOffSet.y;
                    }
                    break;
                    
                case .TopLeft:
                    if (_reversedOrder) {
                        rFrame.origin.x = _containtOffSet.x + offSetFix.x;
                        rFrame.origin.y = _containtOffSet.y + offSetFix.y;
                    } else {
                        rFrame.origin.x = _containtOffSet.x;
                        rFrame.origin.y = _containtOffSet.y;
                    }
                    break;
                    
                case .TopRight:
                    if (_reversedOrder) {
                        rFrame.origin.x = (self.frame.size.width - rFrame.size.width) - _containtOffSet.x;
                        rFrame.origin.y = _containtOffSet.y + offSetFix.y;
                    } else {
                        rFrame.origin.x = (self.frame.size.width - rFrame.size.width - offSetFix.x) - _containtOffSet.x;
                        rFrame.origin.y = _containtOffSet.y;
                    }
                    break;
                    
                case .Bottom:
                    rFrame.origin.x = (self.frame.size.width - rFrame.size.width - offSetFix.x)/2.0;
                    
                    if (_reversedOrder) {
                        rFrame.origin.y = (self.frame.size.height - rFrame.size.height) - _containtOffSet.y;
                    } else {
                        rFrame.origin.y = (self.frame.size.height - rFrame.size.height - offSetFix.y) - _containtOffSet.y;
                    }
                    break;
                    
                case .BottomLeft:
                    if (_reversedOrder) {
                        rFrame.origin.x = _containtOffSet.x + offSetFix.x;
                        rFrame.origin.y = (self.frame.size.height - rFrame.size.height) - _containtOffSet.y;
                    } else {
                        rFrame.origin.x = _containtOffSet.x;
                        rFrame.origin.y = (self.frame.size.height - rFrame.size.height - offSetFix.y) - _containtOffSet.y;
                    }
                    break;
                    
                case .BottomRight:
                    if (_reversedOrder) {
                        rFrame.origin.x = (self.frame.size.width - rFrame.size.width) - _containtOffSet.x;
                        rFrame.origin.y = (self.frame.size.height - rFrame.size.height) - _containtOffSet.y;
                    } else {
                        rFrame.origin.x = (self.frame.size.width - rFrame.size.width - offSetFix.x) - _containtOffSet.x;
                        rFrame.origin.y = (self.frame.size.height - rFrame.size.height - offSetFix.y) - _containtOffSet.y;
                    }
                    break;
                    
                case .Left:
                    rFrame.origin.y = (self.frame.size.height - rFrame.size.height - offSetFix.y)/2.0;
                    
                    if (_reversedOrder) {
                        rFrame.origin.x = _containtOffSet.x + offSetFix.x;
                    } else {
                        rFrame.origin.x = _containtOffSet.x;
                    }
                    break;
                    
                case .Right:
                    rFrame.origin.y = (self.frame.size.height - rFrame.size.height - offSetFix.y)/2.0;
                    
                    if (_reversedOrder) {
                        rFrame.origin.x = (self.frame.size.width - rFrame.size.width) - _containtOffSet.x;
                    } else {
                        rFrame.origin.x = (self.frame.size.width - rFrame.size.width - offSetFix.x) - _containtOffSet.x;
                    }
                    break;
                    
                default:
                    if (_reversedOrder) {
                        rFrame.origin = CGPoint(x: (self.frame.size.width - rFrame.size.width + offSetFix.x)/2.0, y: (self.frame.size.height - rFrame.size.height + offSetFix.y)/2.0);
                    } else {
                        rFrame.origin = CGPoint(x: (self.frame.size.width - rFrame.size.width - offSetFix.x)/2.0, y: (self.frame.size.height - rFrame.size.height - offSetFix.y)/2.0);
                    }
                    break;
                }
            }
            else
            {
                rFrame = self.imageView!.frame;
            }
            
            return rFrame;
        }
    } //P.E.
    
    public var titleLabelFrame:CGRect {
        get {
            let offSet:CGPoint = self.titleOffSet;
            //--
            var rFrame:CGRect = self.titleLabel!.frame;
            
            if (offSet.x == 0) {
                rFrame.origin.x = self.imageView!.frame.origin.x + ((self.imageView!.frame.size.width - self.titleLabel!.frame.size.width) / 2.0);
            } else if (_reversedOrder) {
                rFrame.origin.x = self.imageView!.frame.origin.x - self.titleLabel!.frame.size.width - offSet.x;
            } else {
                rFrame.origin.x = self.imageView!.frame.origin.x + self.imageView!.frame.size.width + offSet.x;
            }
            
            
            if (offSet.y == 0) {
                rFrame.origin.y = self.imageView!.frame.origin.y + ((self.imageView!.frame.size.height - self.titleLabel!.frame.size.height) / 2.0);
            } else if (_reversedOrder) {
                rFrame.origin.y = self.imageView!.frame.origin.y - self.titleLabel!.frame.size.height - offSet.y;
            } else {
                rFrame.origin.y = self.imageView!.frame.origin.y + self.imageView!.frame.size.height + offSet.y;
            }
            
            return rFrame;
        }
    } //F.E.
    
    override public var contentMode:UIViewContentMode {
        get {
            return super.contentMode;
        }
        
        set {
            super.contentMode = newValue;
        }
    } //P.E.
    
    override public func layoutSubviews() {
        super.layoutSubviews();
        //--
        self.titleLabel!.sizeToFit();
        //--
        self.imageView!.frame = self.imageViewFrame;
        self.titleLabel!.frame = self.titleLabelFrame;
    } //F.E.

} //CLS END
