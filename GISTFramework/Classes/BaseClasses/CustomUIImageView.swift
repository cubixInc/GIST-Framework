//
//  CustomUIImageView.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 23/08/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit

public class CustomUIImageView: BaseUIImageView {
    
    private var _imageView:UIImageView?;
    public var imageView:UIImageView? {
        get {
            if (_imageView == nil) {
                _imageView = UIImageView();
                _imageView!.backgroundColor = UIColor.clearColor();//GLOBAL.CLEAR_COLOR;
                self.addSubview(_imageView!);
                //--
                //??self.clipsToBounds = true;
                //--
                self.sendSubviewToBack(_imageView!);
            }
            //--
            return _imageView!;
        }
        
        set {
            _imageView = newValue;
        }
    } //P.E.
    
    private var imageViewFrame:CGRect {
        get {
            
            var rFrame:CGRect = CGRect();
            //--
            if (self.imageView!.image != nil) {
                let imgSize:CGSize = self.imageView!.image!.size;
                //--
                let imgRatio:CGFloat = (imgSize.height / imgSize.width);
                //--
                if ((self.contentMode != UIViewContentMode.ScaleAspectFit) && (self.contentMode != UIViewContentMode.ScaleAspectFill)  && (self.contentMode != UIViewContentMode.ScaleToFill)) {
                    rFrame.size.width =  UIView.convertToRatio(imgSize.width);
                    rFrame.size.height =  imgRatio * rFrame.width;
                }
                //--
                switch (self.contentMode) {
                    
                case .Top:
                    rFrame.origin.x = (self.frame.size.width - rFrame.size.width)/2.0;
                    rFrame.origin.y = 0;
                    break;
                    
                case .TopLeft:
                    rFrame.origin.x = 0;
                    rFrame.origin.y = 0;
                    break;
                    
                case .TopRight:
                    rFrame.origin.x = (self.frame.size.width - rFrame.size.width);
                    rFrame.origin.y = 0;
                    break;
                    
                case .Bottom:
                    rFrame.origin.x = (self.frame.size.width - rFrame.size.width)/2.0;
                    rFrame.origin.y = (self.frame.size.height - rFrame.size.height);
                    break;
                    
                case .BottomLeft:
                    rFrame.origin.x = 0;
                    rFrame.origin.y = (self.frame.size.height - rFrame.size.height);
                    break;
                    
                case .BottomRight:
                    rFrame.origin.x = (self.frame.size.width - rFrame.size.width);
                    rFrame.origin.y = (self.frame.size.height - rFrame.size.height);
                    break;
                    
                case .Left:
                    rFrame.origin.x = 0;
                    rFrame.origin.y = (self.frame.size.height - rFrame.size.height)/2.0;
                    break;
                    
                case .Right:
                    rFrame.origin.x = (self.frame.size.width - rFrame.size.width);
                    rFrame.origin.y = (self.frame.size.height - rFrame.size.height)/2.0;
                    break;
                    
                case .ScaleToFill:
                    rFrame.origin = CGPoint.zero;
                    rFrame.size = self.frame.size;
                    break;
                    
                case .ScaleAspectFit:
                    if (imgSize.width > imgSize.height) {
                        rFrame.size.width = self.frame.size.width;
                        rFrame.size.height =  imgRatio * rFrame.width;
                    } else {
                        rFrame.size.height = self.frame.size.height;
                        rFrame.size.width =  rFrame.height / imgRatio;
                    }
                    //--
                    rFrame.origin = CGPoint(x: (self.frame.size.width - rFrame.size.width)/2.0,y: (self.frame.size.height - rFrame.size.height)/2.0);
                    break;
                    
                case .ScaleAspectFill:
                    if (imgSize.width < imgSize.height) {
                        rFrame.size.width = self.frame.size.width;
                        rFrame.size.height =  imgRatio * rFrame.size.width;
                    } else {
                        rFrame.size.height = self.frame.size.height;
                        rFrame.size.width =  rFrame.size.height / imgRatio;
                    }
                    //--
                    rFrame.origin = CGPoint(x: (self.frame.size.width - rFrame.size.width)/2.0,y: (self.frame.size.height - rFrame.size.height)/2.0);
                    break;
                    
                    
                default:
                    rFrame.origin = CGPoint(x: (self.frame.size.width - rFrame.size.width)/2.0,y: (self.frame.size.height - rFrame.size.height)/2.0);
                    break;
                }
            } else {
                rFrame.size =  self.frame.size;// CGSize(width: 50, height: 50); //self.imageView!.frame.size;//
                //--
                rFrame.origin = CGPoint(x: (self.frame.size.width - rFrame.size.width)/2.0,y: (self.frame.size.height - rFrame.size.height)/2.0);
            }
            //--
            return rFrame;
        }
    } //P.E.
    
    public override var contentMode:UIViewContentMode {
        get {
            return super.contentMode;
        }
        
        set {
            super.contentMode = newValue;
        }
    } //P.E.
    
    public override var image: UIImage? {
        get {
            return self.imageView!.image;
        }
        set {
            self.imageView!.image = newValue
            //--
            self.imageView!.frame = self.imageViewFrame;
        }
    } //F.E.
    
    override public func layoutSubviews() {
        super.layoutSubviews();
        //--
        self.imageView!.frame = self.imageViewFrame;
    } //F.E


}
