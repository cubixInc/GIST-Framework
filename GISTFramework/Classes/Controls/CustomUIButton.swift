//
//  CustomButton.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 14/06/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit

/// CustomUIButton is a subclass of BaseUIButton having all the properties of a UIButton. it resizes the images according to device resolution.
open class CustomUIButton: BaseUIButton {
    
    //MARK: - Properties
    
    /// Button image background color key from SyncEngine.
    @IBInspectable open var imgBgColorStyle:String? = nil {
        didSet {
            self.imageView?.backgroundColor = SyncedColors.color(forKey: imgBgColorStyle);
        }
    }
    
    private var _titleOffSet:CGPoint = CGPoint.zero;
    
    /// Padding between image and title.
    @IBInspectable open var titleOffSet:CGPoint {
        set {
            _titleOffSet = newValue;
        }
        
        get {
            return GISTUtility.convertPointToRatio(_titleOffSet);
        }
    } //P.E.
    
    private var _containtOffSet:CGPoint = CGPoint.zero;
    
    /// Title and Image container pedding from the main container.
    @IBInspectable open var containtOffSet:CGPoint {
        set {
            _containtOffSet = newValue;
        }
        
        get {
            return _containtOffSet;
        }
    } //P.E.
    
    private var _containtCenter:Bool = true;
    
    /// Flag for whether to draw containt in the center.
    @IBInspectable open var containtCenter:Bool {
        set {
            _containtCenter = newValue;
        }
        
        get {
            return _containtCenter;
        }
    } //P.E.
    
    private var _reversedOrder:Bool = false;
    
    /**
     Flag for whether to draw containt in the reverse order. (e.g. title and then Image.)
     The native behavior of UIButton is, image first and then title text.
    */
    @IBInspectable open var reversedOrder:Bool {
        set {
            _reversedOrder = newValue;
        }
        
        get {
            return _reversedOrder;
        }
    } //P.E.
    
    @IBInspectable open var imageFixedSize:CGSize = CGSize.zero;
    
    /// Fixing offset of internal calculations use.
    internal var offSetFixPoint:CGPoint {
        get {
            let offSetV:CGPoint = self.titleOffSet;
             
            let offSetFixV:CGPoint = CGPoint(x: (offSetV.x == 0 || !_containtCenter) ?0:self.titleLabel!.frame.size.width + offSetV.x, y: (offSetV.y == 0 || !_containtCenter) ?0:self.titleLabel!.frame.size.height + offSetV.y);
            
            return offSetFixV;
        }
    } //P.E.
    
    @IBInspectable open var respectContentRTL:Bool = GIST_GLOBAL.respectRTL {
        didSet {
            self.imageView!.frame = self.imageViewFrame;
            self.titleLabel!.frame = self.titleLabelFrame;
        }
    } //P.E.
    
    /**
     Calculated frame of button image view.
     It uses UIButton native UIViewContentMode to calculate frames.
     */
    open var imageViewFrame:CGRect {
        get {
            
            var rFrame:CGRect = CGRect();
             
            let imgSize:CGSize = self.imageView!.image?.size ?? CGSize(width: 0.1, height: 0.1);
            
            if (self.imageFixedSize.height > 0 && self.imageFixedSize.width > 0) {
                //Height and Width both are fixed
                rFrame.size = self.imageFixedSize;
            } else if (self.imageFixedSize.width > 0) {
                //Width is fixed
                let imgRatio:CGFloat = (imgSize.height / imgSize.width);
                
                rFrame.size.width =  GISTUtility.convertToRatio(self.imageFixedSize.width);
                rFrame.size.height =  imgRatio * rFrame.size.width;
            } else if (self.imageFixedSize.height > 0) {
                //Height is fixed
                let imgRatio:CGFloat = (imgSize.width / imgSize.height);
                
                rFrame.size.height = GISTUtility.convertToRatio(self.imageFixedSize.height);
                rFrame.size.width = imgRatio * rFrame.size.height;
            } else {
                //Aspect Ratio
                let imgRatio:CGFloat = (imgSize.height / imgSize.width);
                
                rFrame.size.width =  GISTUtility.convertToRatio(imgSize.width);
                rFrame.size.height =  imgRatio * rFrame.size.width;
            }
            
            let offSetFix:CGPoint = self.offSetFixPoint;
            
            var cContentMode:UIViewContentMode = self.contentMode;
            
            //Respect for Right to left Handling
            if ((self.respectContentRTL || self.respectRTL) && GIST_GLOBAL.isRTL) {
                switch cContentMode {
                case .left:
                    cContentMode = .right;
                    break;
                case .right:
                    cContentMode = .left;
                    break;
                case .topLeft:
                    cContentMode = .topRight;
                    break;
                case .topRight:
                    cContentMode = .topLeft;
                    break;
                case .bottomLeft:
                    cContentMode = .bottomRight;
                    break;
                case .bottomRight:
                    cContentMode = .bottomLeft;
                    break;
                default:
                    break;
                }
            }
            
            switch (cContentMode) {
                
            case .top:
                rFrame.origin.x = (self.frame.size.width - rFrame.size.width - offSetFix.x)/2.0;
                
                if (_reversedOrder) {
                    rFrame.origin.y = _containtOffSet.y + offSetFix.y;
                } else {
                    rFrame.origin.y = _containtOffSet.y;
                }
                break;
                
            case .topLeft:
                if (_reversedOrder) {
                    rFrame.origin.x = _containtOffSet.x + offSetFix.x;
                    rFrame.origin.y = _containtOffSet.y + offSetFix.y;
                } else {
                    rFrame.origin.x = _containtOffSet.x;
                    rFrame.origin.y = _containtOffSet.y;
                }
                break;
                
            case .topRight:
                if (_reversedOrder) {
                    rFrame.origin.x = (self.frame.size.width - rFrame.size.width) - _containtOffSet.x;
                    rFrame.origin.y = _containtOffSet.y + offSetFix.y;
                } else {
                    rFrame.origin.x = (self.frame.size.width - rFrame.size.width - offSetFix.x) - _containtOffSet.x;
                    rFrame.origin.y = _containtOffSet.y;
                }
                break;
                
            case .bottom:
                rFrame.origin.x = (self.frame.size.width - rFrame.size.width - offSetFix.x)/2.0;
                
                if (_reversedOrder) {
                    rFrame.origin.y = (self.frame.size.height - rFrame.size.height) - _containtOffSet.y;
                } else {
                    rFrame.origin.y = (self.frame.size.height - rFrame.size.height - offSetFix.y) - _containtOffSet.y;
                }
                break;
                
            case .bottomLeft:
                if (_reversedOrder) {
                    rFrame.origin.x = _containtOffSet.x + offSetFix.x;
                    rFrame.origin.y = (self.frame.size.height - rFrame.size.height) - _containtOffSet.y;
                } else {
                    rFrame.origin.x = _containtOffSet.x;
                    rFrame.origin.y = (self.frame.size.height - rFrame.size.height - offSetFix.y) - _containtOffSet.y;
                }
                break;
                
            case .bottomRight:
                if (_reversedOrder) {
                    rFrame.origin.x = (self.frame.size.width - rFrame.size.width) - _containtOffSet.x;
                    rFrame.origin.y = (self.frame.size.height - rFrame.size.height) - _containtOffSet.y;
                } else {
                    rFrame.origin.x = (self.frame.size.width - rFrame.size.width - offSetFix.x) - _containtOffSet.x;
                    rFrame.origin.y = (self.frame.size.height - rFrame.size.height - offSetFix.y) - _containtOffSet.y;
                }
                break;
                
            case .left:
                rFrame.origin.y = (self.frame.size.height - rFrame.size.height - offSetFix.y)/2.0;
                
                if (_reversedOrder) {
                    rFrame.origin.x = _containtOffSet.x + offSetFix.x;
                } else {
                    rFrame.origin.x = _containtOffSet.x;
                }
                break;
                
            case .right:
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
            
            return rFrame;
        }
    } //P.E.
    
    /**
     Calculated frame of title text lable.
     It uses image frame as a reference to calculate frames.
     */
    open var titleLabelFrame:CGRect {
        get {
            let offSet:CGPoint = self.titleOffSet;
             
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
    
    /// Overriden propert to get content mode changes.
    override open var contentMode:UIViewContentMode {
        get {
            return super.contentMode;
        }
        
        set {
            super.contentMode = newValue;
        }
    } //P.E.
    
    //MARK: - Overridden Methods
    
    /// Overridden methed to update layout.
    override open func layoutSubviews() {
        super.layoutSubviews();
         
        self.titleLabel!.sizeToFit();
         
        self.imageView!.frame = self.imageViewFrame;
        self.titleLabel!.frame = self.titleLabelFrame;
    } //F.E.

} //CLS END
