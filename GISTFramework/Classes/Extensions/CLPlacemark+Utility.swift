//
//  CLPlacemark+Utility.swift
//  FoodParcel
//
//  Created by Shoaib Abdul on 18/10/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit
import CoreLocation

// MARK: - CLPlacemark Utility Extension
public extension CLPlacemark {
    
    /// Returns formated Address from 'FormattedAddressLines' array
    var formatedAddress:String? {
        get {
            
            var addressParts:[String] = [];
            
            if (self.thoroughfare != nil) {
                addressParts.append(self.thoroughfare!);
            }
            
            if (self.locality != nil) {
                addressParts.append(self.locality!);
            }
            
            if (self.subLocality != nil) {
                addressParts.append(self.subLocality!);
            }
            
            if (self.administrativeArea != nil) {
                addressParts.append(self.administrativeArea!);
            }
            
            if (self.postalCode != nil) {
                addressParts.append(self.postalCode!);
            }
            
            if (self.country != nil) {
                addressParts.append(self.country!);
            }
            
            return addressParts.joined(separator: ", ")
        }
    } //P.E.
} //E.E.
