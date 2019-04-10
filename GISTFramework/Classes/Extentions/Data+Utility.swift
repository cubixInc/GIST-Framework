//
//  Data+Utility.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 23/06/2017.
//  Copyright © 2017 Social Cubix. All rights reserved.
//

import UIKit

public extension Data {
    public var mimeType:String {
        get {
            var c = [UInt32](repeating: 0, count: 1)
            (self as NSData).getBytes(&c, length: 1)
            switch (c[0]) {
            case 0xFF:
                return "image/jpeg";
            case 0x89:
                return "image/png";
            case 0x47:
                return "image/gif";
            case 0x49, 0x4D:
                return "image/tiff";
            case 0x25:
                return "application/pdf";
            case 0xD0:
                return "application/vnd";
            case 0x46:
                return "text/plain";
            default:
                print("mimeType for \(c[0]) in available");
                return "application/octet-stream";
            }
        }
    } //F.E.
    
    public var fileExtension:String {
        get {
            var c = [UInt32](repeating: 0, count: 1)
            (self as NSData).getBytes(&c, length: 1)
            switch (c[0]) {
            case 0xFF:
                return "jpeg";
            case 0x89:
                return "png";
            case 0x47:
                return "gif";
            case 0x49, 0x4D:
                return "tiff";
            case 0x25:
                return "pdf";
            case 0xD0:
                return "vnd";
            case 0x46:
                return "txt";
            default:
                print("mimeType for \(c[0]) in not available");
                return "octet-stream";
            }
        }
    } //F.E.
} //E.E.
