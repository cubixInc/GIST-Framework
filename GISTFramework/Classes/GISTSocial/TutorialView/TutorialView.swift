//
//  TutorialView.swift
//  SocialGIST
//
//  Created by Shoaib Abdul on 09/08/2016.
//  Copyright © 2017 Social Cubix Inc. All rights reserved.
//

import UIKit

public protocol TutorialViewLayout {
    func updateLayout(_ data:Any);
} //P.E.

public protocol TutorialViewDelegate {
    func tutorialViewPageDidChange(tutorialView:TutorialView, newPage:Int);
} //P.E.

open class TutorialView: BaseUIView, UIScrollViewDelegate {
    
    private var _delegate:TutorialViewDelegate?
    @IBOutlet public var delegate:AnyObject? {
        didSet {
            _delegate = delegate as? TutorialViewDelegate;
        }
    }
    
    @IBOutlet public var pageControl:UIPageControl? {
        didSet {
            pageControl?.numberOfPages = _layoutViews.count;
            
            self.updatePageControl();
        }
    }
    
    @IBInspectable public var dataPlistFileName:String! {
        didSet {
            self.updateTutorial();
        }
    }
    
    @IBInspectable public var layoutViewName:String! {
        didSet {
            self.updateTutorial();
        }
    }
    
    private var _currPage:Int = 0;
    public var currentPage:Int {
        get {
            return _currPage;
        }
        
        set {
            if (newValue != _currPage) {
                _currPage = newValue;
                
                self.pageControl?.currentPage = _currPage;
                
                //Scrolling to new Page
                self.scrollView.setContentOffset(CGPoint(x: (self.scrollView.contentSize.width /  CGFloat(self.numberOfPages)) * CGFloat(_currPage), y: 0), animated: true);
            }
        }
    }
    
    public var numberOfPages:Int {
        get {
            return _layoutViews.count;
        }
    }
    
    private var _scrollView:UIScrollView?;
    private var scrollView:UIScrollView {
        get {
            if (_scrollView == nil) {
                _scrollView = UIScrollView();
                _scrollView!.isPagingEnabled = true;
                _scrollView!.showsHorizontalScrollIndicator = false;
                _scrollView!.showsVerticalScrollIndicator = false;
                _scrollView!.delegate = self;
                self.addSubview(_scrollView!);
            }
            
            return _scrollView!;
        }
    }
    
    private var _layoutViews:[TutorialViewLayout] = [TutorialViewLayout]();
    
    override open func layoutSubviews() {
        super.layoutSubviews();
        
        self.updateFrames();
    } //F.E.
    
    //Scroll View Delegate Method
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.updatePageControl();
    } //F.E.
    
    private func updateTutorial() {
        guard ((dataPlistFileName != nil) && (layoutViewName != nil)) else {
            return;
        }
        
        //Removing old views
        self.resetLayout();
        
        if let arr:NSArray = SyncEngine.objectForKey(dataPlistFileName) {
        
            for i:Int in 0 ..< arr.count {
                if let tView:TutorialViewLayout = UIView.loadWithNib(layoutViewName, viewIndex: 0, owner: self) as? TutorialViewLayout {
                    tView.updateLayout(arr[i] as AnyObject);
                    scrollView.addSubview(tView as! UIView);
                     _layoutViews.append(tView);
                } else {
                    assert(true, "Invalid layout: \(String(describing: layoutViewName)) must implement SCTutorialViewLayout protocol");
                }
            }
        } else {
            assert(true, "Invalid plist file.");
        }
        
        pageControl?.numberOfPages = _layoutViews.count;
    } //F.E.
    
    private func resetLayout() {
        for layoutView:TutorialViewLayout in _layoutViews {
            (layoutView as? UIView)?.removeFromSuperview();
        }
        
        _layoutViews.removeAll();
    } //F.E.
    
    private func updateFrames() {
        self.scrollView.frame = self.frame;
        
        self.scrollView.contentSize = CGSize(width: self.frame.width * CGFloat(_layoutViews.count),height: self.frame.height);
        
        for i:Int in 0 ..< _layoutViews.count {
            let tView:TutorialViewLayout = _layoutViews[i];
            (tView as! UIView).frame = CGRect(x: self.frame.width * CGFloat(i), y: 0, width: self.frame.width, height: self.frame.height);
        }
    } //F.E.
    
    private func updatePageControl () {
        let newPage = Int(floor((self.scrollView.contentOffset.x - self.bounds.size.width * 0.5) / self.bounds.size.width)) + 1
        
        if (newPage != _currPage) {
            _currPage = newPage;
            
            self.pageControl?.currentPage = _currPage;
            
            _delegate?.tutorialViewPageDidChange(tutorialView: self, newPage: _currPage);
        }
    } //F.E.
    
} //CLS END
