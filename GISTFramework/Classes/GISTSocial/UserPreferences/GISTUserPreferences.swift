//
//  UserPreferences.swift
//  QuranApp
//
//  Created by Shoaib on 9/16/15.
//  Copyright (c) 2015 Cubix. All rights reserved.
//

import UIKit

public class GISTUserPreferences: NSObject {
    
    //PRIVATE init so that singleton class should not be reinitialized from anyother class
    private override init() {
        super.init();
    } //C.E.
    
    public func removeUser(){
        UserDefaults.standard.removeObject(forKey: "APP_USER")
    } //F.E.
    
} //CLS END

