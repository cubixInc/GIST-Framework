//
//  CustomUIImageView.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 23/08/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit

///THIS CLASS WAS TO REPLACE CustomImageView(inharited from UIView) but there were some unknown implementations of UIImageView (of UIKit) that are causing the bugs so keeping this class private to use in future after some fixes
private class CustomUIImageView: BaseUIImageView {
    
    
    //MARK: - Properties
    @IBInspectable open var respectContentRTL:Bool = GIST_GLOBAL.respectRTL {
        didSet {
            self.imageView!.frame = self.imageViewFrame;
        }
    } //P.E.
    
    private var _imageView:UIImageView?;
    
    /// Image View Lazy instance for drawing custom image.
    var imageView:UIImageView? {
        get {
            if (_imageView == nil) {
                _imageView = UIImageView();
                _imageView!.backgroundColor = UIColor.clear;
                self.addSubview(_imageView!);
                 
                //??self.clipsToBounds = true;
                 
                self.sendSubview(toBack: _imageView!);
            }
             
            return _imageView!;
        }
        
        set {
            _imageView = newValue;
        }
    } //P.E.
    
    /**
     Calculated frame of button image view.
     It uses UIButton native UIViewContentMode to calculate frames.
     */
    private var imageViewFrame:CGRect {
        get {
            
            var rFrame:CGRect = CGRect();
             
            if (self.imageView!.image != nil) {
                let imgSize:CGSize = self.imageView!.image!.size;
                 
                let imgRatio:CGFloat = (imgSize.height / imgSize.width);
                 
                if ((self.contentMode != UIViewContentMode.scaleAspectFit) && (self.contentMode != UIViewContentMode.scaleAspectFill)  && (self.contentMode != UIViewContentMode.scaleToFill)) {
                    rFrame.size.width =  GISTUtility.convertToRatio(imgSize.width);
                    rFrame.size.height =  imgRatio * rFrame.width;
                }
                
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
                 
                switch (self.contentMode) {
                    
                case .top:
                    rFrame.origin.x = (self.frame.size.width - rFrame.size.width)/2.0;
                    rFrame.origin.y = 0;
                    break;
                    
                case .topLeft:
                    rFrame.origin.x = 0;
                    rFrame.origin.y = 0;
                    break;
                    
                case .topRight:
                    rFrame.origin.x = (self.frame.size.width - rFrame.size.width);
                    rFrame.origin.y = 0;
                    break;
                    
                case .bottom:
                    rFrame.origin.x = (self.frame.size.width - rFrame.size.width)/2.0;
                    rFrame.origin.y = (self.frame.size.height - rFrame.size.height);
                    break;
                    
                case .bottomLeft:
                    rFrame.origin.x = 0;
                    rFrame.origin.y = (self.frame.size.height - rFrame.size.height);
                    break;
                    
                case .bottomRight:
                    rFrame.origin.x = (self.frame.size.width - rFrame.size.width);
                    rFrame.origin.y = (self.frame.size.height - rFrame.size.height);
                    break;
                    
                case .left:
                    rFrame.origin.x = 0;
                    rFrame.origin.y = (self.frame.size.height - rFrame.size.height)/2.0;
                    break;
                    
                case .right:
                    rFrame.origin.x = (self.frame.size.width - rFrame.size.width);
                    rFrame.origin.y = (self.frame.size.height - rFrame.size.height)/2.0;
                    break;
                    
                case .scaleToFill:
                    rFrame.origin = CGPoint.zero;
                    rFrame.size = self.frame.size;
                    break;
                    
                case .scaleAspectFit:
                    if (imgSize.width > imgSize.height) {
                        rFrame.size.width = self.frame.size.width;
                        rFrame.size.height =  imgRatio * rFrame.width;
                    } else {
                        rFrame.size.height = self.frame.size.height;
                        rFrame.size.width =  rFrame.height / imgRatio;
                    }
                     
                    rFrame.origin = CGPoint(x: (self.frame.size.width - rFrame.size.width)/2.0,y: (self.frame.size.height - rFrame.size.height)/2.0);
                    break;
                    
                case .scaleAspectFill:
                    if (imgSize.width < imgSize.height) {
                        rFrame.size.width = self.frame.size.width;
                        rFrame.size.height =  imgRatio * rFrame.size.width;
                    } else {
                        rFrame.size.height = self.frame.size.height;
                        rFrame.size.width =  rFrame.size.height / imgRatio;
                    }
                     
                    rFrame.origin = CGPoint(x: (self.frame.size.width - rFrame.size.width)/2.0,y: (self.frame.size.height - rFrame.size.height)/2.0);
                    break;
                    
                    
                default:
                    rFrame.origin = CGPoint(x: (self.frame.size.width - rFrame.size.width)/2.0,y: (self.frame.size.height - rFrame.size.height)/2.0);
                    break;
                }
            } else {
                rFrame.size =  self.frame.size;
                 
                rFrame.origin = CGPoint(x: (self.frame.size.width - rFrame.size.width)/2.0,y: (self.frame.size.height - rFrame.size.height)/2.0);
            }
             
            return rFrame;
        }
    } //P.E.
    
    /// Overriden propert to get content mode changes.
    override var contentMode:UIViewContentMode {
        get {
            return super.contentMode;
        }
        
        set {
            super.contentMode = newValue;
        }
    } //P.E.
    
    /**
     Overriden property for image.
     It overrides the native behavior of UIImageView and sets image in the custom image view.
    */
    override var image: UIImage? {
        get {
            return self.imageView!.image;
        }
        set {
            if (self.respectRTL && GIST_GLOBAL.isRTL) {
                self.imageView!.image = newValue?.mirrored();
            } else {
                self.imageView!.image = newValue;
            }
             
            self.imageView!.frame = self.imageViewFrame;
        }
    } //F.E.
    
    //MARK: - Overridden Methods
    
    /// Overridden method to setup/ initialize components.
    override open func awakeFromNib() {
        super.awakeFromNib();
         
        if let cImg:UIImage = super.image {
            //Cleaning Up
            super.image = UIImage();
             
            self.image = UIImage(cgImage:cImg.cgImage!, scale: cImg.scale, orientation:cImg.imageOrientation);
        }
    } //F.E.
    
    /// Overridden methed to update layout.
    override func layoutSubviews() {
        super.layoutSubviews();
         
        self.imageView!.frame = self.imageViewFrame;
    } //F.E

} //CLS END
