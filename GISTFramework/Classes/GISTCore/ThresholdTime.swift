//
//  ThresholdTime.swift
//  GISTProj
//
//  Created by Shoaib Abdul on 10/08/2017.
//  Copyright © 2017 Social Cubix Inc. All rights reserved.
//

import UIKit

public class ThresholdTime: NSObject {
    
    public enum Unit {
        case sec, min, hour
        
        public func toSeconds(_ time:Int) -> TimeInterval {
            switch self {
            case .sec:
                return TimeInterval(time);

            case .min:
                return TimeInterval(time * 60);
                
            case .hour:
                return TimeInterval(time * 60 * 60);
            }
        }
    }
    
    private static var shared:ThresholdTime = ThresholdTime();
    
    private var _lastUpdatedTime:[String:Date] = [:];
    
    public class func hasPassed(_ time:Int, forIdentifier identifier:String, unit:ThresholdTime.Unit = ThresholdTime.Unit.sec) -> Bool {
        return self.shared.hasPassed(time, forIdentifier: identifier, unit:unit);
    } //F.E.
    
    private func hasPassed(_ time:Int, forIdentifier identifier:String, unit:ThresholdTime.Unit) -> Bool {
        let currDate:Date = Date();
        
        let rtnValue:Bool
        
        if let lastResponseDate:Date = _lastUpdatedTime[identifier] {
            rtnValue = (currDate.timeIntervalSince(lastResponseDate) >=  unit.toSeconds(time));
            
        } else {
            rtnValue = true;
        }
        
        if (rtnValue == true) {
            //if has passed the time intervale
            self.updateTime(forIdentifier: identifier);
        }
        
        return rtnValue;
    } //F.E.
    
    
    public class func updateTime(forIdentifier identifier:String) {
        return self.shared.updateTime(forIdentifier: identifier);
    } //F.E.
    
    private func updateTime(forIdentifier identifier:String) {
        _lastUpdatedTime[identifier] = Date();
    } // F.E.
    
    public class func reset() {
        self.shared.reset();
    } //F.E.
    
    public func reset() {
        _lastUpdatedTime = [:];
    } //F.E.
    
} //CLS END
