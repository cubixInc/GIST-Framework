//
//  CLPlacemark+Utility.swift
//  FoodParcel
//
//  Created by Shoaib Abdul on 18/10/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit
import CoreLocation

public extension CLPlacemark {
    public var formatedAddress:String? {
        get {
            if let addrList = self.addressDictionary?["FormattedAddressLines"] as? [String] {
                return addrList.joined(separator: ", ")
            } else {
                return nil;
            }
        }
    } //P.E.
} //E.E.
