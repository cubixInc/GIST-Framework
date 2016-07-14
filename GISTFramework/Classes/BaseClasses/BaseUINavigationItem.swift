//
//  BaseUINavigationItem.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 14/07/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit

public class BaseUINavigationItem: UINavigationItem {
    
    private var _titleKey:String?;
    override public var title: String? {
        get {
            return super.title;
        }
        
        set {
            if let key:String = newValue where key.hasPrefix("#") == true {
                _titleKey = key;  // holding key for using later
                
                super.title = SyncedText.text(forKey: key);
            } else {
                super.title = newValue;
            }
        }
    } //P.E.
    
    public override init(title: String) {
        super.init(title: title);
    } //F.E.
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    } //F.E.
    
} //CLS END
