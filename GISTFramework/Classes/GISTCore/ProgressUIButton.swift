//
//  ProgressUIButton.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 10/02/2017.
//  Copyright © 2017 Cubix Labs. All rights reserved.
//

import UIKit

/// ProgressUIButton is base class of BaseUIButton. It triggers event when progress completes with a limited time of duration on tap and hold
open class ProgressUIButton: BaseUIButton {

    //MARK: - Properties
    
    /// Max time in seconde to fill the bar
    @IBInspectable open var progressTime:Double = 2;
    
    /// Bar Height
    @IBInspectable open var barHeight:CGFloat = 10;
    
    /// Bar Color style with sync engine
    @IBInspectable open var barColor:String? {
        didSet {
            _progressBarView?.bgColorStyle = self.barColor;
        }
    }
    
    /// Bar background color style with sync engine
    @IBInspectable open var barBgColor:String? {
        didSet {
            _progressView?.bgColorStyle = self.barBgColor;
        }
    } //P.E.
    
    /// Flag for bar position
    @IBInspectable var barOnBottom:Bool = false {
        didSet {
            _progressView?.frame = self.progressViewFrame;
        }
    } //P.E.
    
    /// Flag for auto trigger event. when true, It will unfill the bar and trigger event on completely unfilled
    @IBInspectable var autoTrigger:Bool = false;
    
    private var _timer:Timer?;
    private var _timePassed:Double = 0 {
        didSet {
            UIView.animate(withDuration: 0.1) {
                self._progressBarView.frame = self.progressBarViewFrame;
            }
        }
    } //P.E.
    
    private var _progressView:BaseUIView!
    private var _progressBarView:BaseUIView!
    
    private var progressViewFrame:CGRect {
        get {
            let height:CGFloat = GISTUtility.convertToRatio(self.barHeight);
            
            return CGRect(x: 0, y: (self.barOnBottom ? (self.frame.size.height - height):0), width: self.frame.size.width, height: height);
        }
    } //F.E.
    
    private var progressBarViewFrame:CGRect {
        get {
            
            let width:CGFloat = (self.autoTrigger) ? self.frame.size.width * (1.0 - CGFloat(_timePassed / self.progressTime)):self.frame.size.width * CGFloat(_timePassed / self.progressTime);
            
            let x:CGFloat = (self.respectRTL && GIST_GLOBAL.isRTL) ? self.frame.size.width - width : 0;
            
            return CGRect(x: x, y: 0, width: width, height: GISTUtility.convertToRatio(self.barHeight));
        }
    } //F.E.
    
    //MARK: - Overridden Methods
    
    /// Overridden method to setup/ initialize components.
    override open func awakeFromNib() {
        super.awakeFromNib();
        
        self.setupLayout();
        
        if (self.autoTrigger == true) {
            self.scheduleUpdater();
        }
    } //F.E.
    
    /// Overridden methed to update layout.
    override open func layoutSubviews() {
        super.layoutSubviews();
        
        _progressView?.frame = self.progressViewFrame;
        _progressBarView?.frame = self.progressBarViewFrame;
    } //F.E.
    
    /// Overridden methed to handle touches
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event);
        
        guard (self.autoTrigger == false) else {
            return;
        }
        
        self.scheduleUpdater();
    } //F.E.
    
    /// Overridden methed to handle touches
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event);
        
        self.unscheduleUpdater();
    } //F.E.
    
    /// Overridden methed to handle touches
    override open func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event);
        
        self.unscheduleUpdater();
    } //F.E.
    
    /// Overridden methed to handle action
    override open func sendAction(_ action: Selector, to target: Any?, for event: UIEvent?) {
        
        guard (self.autoTrigger == false) else {
            
            super.sendAction(action, to: target, for: event);
            self.unscheduleUpdater();
            
            return;
        }
        
        if (_timePassed >= self.progressTime) {
            self.fadeOut { (Bool) in
                super.sendAction(action, to: target, for: event);
                self.fadeIn();
            }
        }
    } //F.E.
    
    //MARK: - Methods
    
    private func setupLayout() {
        //Progress View
        _progressView = BaseUIView(frame: self.progressViewFrame);
        _progressView.bgColorStyle = self.barBgColor ?? "theme";
        self.addSubview(_progressView);
        
        //Progress Bar View
        _progressBarView = BaseUIView(frame: self.progressBarViewFrame);
        _progressBarView.bgColorStyle = self.barColor ?? "accent";
        _progressView.addSubview(_progressBarView);
    } //F.E.
    
    private func triggerEvent() {
        self.sendActions(for: UIControlEvents.touchUpInside);
        
        self.unscheduleUpdater();
    } //F.E.
    
    private func scheduleUpdater() {
        //First unschedule updater
        self.unscheduleUpdater();
        
        _timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.update), userInfo: nil, repeats: true);
    } //F.E.
    
    private func unscheduleUpdater() {
        guard _timer != nil else {
            return;
        }
        
        _timer!.invalidate();
        _timer = nil;
        
        if (self.autoTrigger == false) {
            _timePassed = 0;
        }
        
    } //F.E.
    
    /// Update methed called instantaneously when the bar is filling
    func update() {
        guard _timePassed < self.progressTime else {
            self.triggerEvent();
            return;
        }
        
        _timePassed += (_timer?.timeInterval ?? 1);
        
    } //F.E.

} //CLE END
