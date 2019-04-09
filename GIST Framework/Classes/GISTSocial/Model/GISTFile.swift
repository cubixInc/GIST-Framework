//
//  GISTFile.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 23/06/2017.
//  Copyright © 2017 Social Cubix. All rights reserved.
//

import UIKit

public class GISTFile: NSObject {

    //MARK: - Properties
    
    public var data:Data!;
    public var ext:String = "";
    public var mimeType:String = "";
    
    //MARK: - Constructors
    
    public init(with data:Data, ext:String) {
        super.init();
        
        self.data = data;
        self.ext = ext;
        self.mimeType = self.mimeType(for:ext);
    } //C.E.
    
    public init(with data:Data, ext:String, mimeType:String) {
        super.init();
        
        self.data = data;
        self.ext = ext;
        self.mimeType = mimeType;
    } //C.E.
    
    //MARK: - Methods
    
    private func mimeType(for ext:String) -> String {
        switch ext {
            
        case "html":
            return "text/html";
        case "htm":
            return "text/html";
        case "shtml":
            return "text/html";
        case "css":
            return "text/css";
        case "xml":
            return "text/xml";
        case "gif":
            return "image/gif";
        case "jpeg":
            return "image/jpeg";
        case "jpg":
            return "image/jpeg";
        case "js":
            return "application/javascript";
        case "atom":
            return "application/atom+xml";
        case "rss":
            return "application/rss+xml";
        case "mml":
            return "text/mathml";
        case "txt":
            return "text/plain";
        case "jad":
            return "text/vnd.sun.j2me.app-descriptor";
        case "wml":
            return "text/vnd.wap.wml";
        case "htc":
            return "text/x-component";
        case "png":
            return "image/png";
        case "tif":
            return "image/tiff";
        case "tiff":
            return "image/tiff";
        case "wbmp":
            return "image/vnd.wap.wbmp";
        case "ico":
            return "image/x-icon";
        case "jng":
            return "image/x-jng";
        case "bmp":
            return "image/x-ms-bmp";
        case "svg":
            return "image/svg+xml";
        case "svgz":
            return "image/svg+xml";
        case "webp":
            return "image/webp";
        case "woff":
            return "application/font-woff";
        case "jar":
            return "application/java-archive";
        case "war":
            return "application/java-archive";
        case "ear":
            return "application/java-archive";
        case "json":
            return "application/json";
        case "hqx":
            return "application/mac-binhex40";
        case "doc":
            return "application/msword";
        case "pdf":
            return "application/pdf";
        case "ps":
            return "application/postscript";
        case "eps":
            return "application/postscript";
        case "ai":
            return "application/postscript";
        case "rtf":
            return "application/rtf";
        case "m3u8":
            return "application/vnd.apple.mpegurl";
        case "xls":
            return "application/vnd.ms-excel";
        case "eot":
            return "application/vnd.ms-fontobject";
        case "ppt":
            return "application/vnd.ms-powerpoint";
        case "wmlc":
            return "application/vnd.wap.wmlc";
        case "kml":
            return "application/vnd.google-earth.kml+xml";
        case "kmz":
            return "application/vnd.google-earth.kmz";
        case "7z":
            return "application/x-7z-compressed";
        case "cco":
            return "application/x-cocoa";
        case "jardiff":
            return "application/x-java-archive-diff";
        case "jnlp":
            return "application/x-java-jnlp-file";
        case "run":
            return "application/x-makeself";
        case "pl":
            return "application/x-perl";
        case "pm":
            return "application/x-perl";
        case "prc":
            return "application/x-pilot";
        case "pdb":
            return "application/x-pilot";
        case "rar":
            return "application/x-rar-compressed";
        case "rpm":
            return "application/x-redhat-package-manager";
        case "sea":
            return "application/x-sea";
        case "swf":
            return "application/x-shockwave-flash";
        case "sit":
            return "application/x-stuffit";
        case "tcl":
            return "application/x-tcl";
        case "tk":
            return "application/x-tcl";
        case "der":
            return "application/x-x509-ca-cert";
        case "pem":
            return "application/x-x509-ca-cert";
        case "crt":
            return "application/x-x509-ca-cert";
        case "xpi":
            return "application/x-xpinstall";
        case "xhtml":
            return "application/xhtml+xml";
        case "xspf":
            return "application/xspf+xml";
        case "zip":
            return "application/zip";
        case "bin":
            return "application/octet-stream";
        case "exe":
            return "application/octet-stream";
        case "dll":
            return "application/octet-stream";
        case "deb":
            return "application/octet-stream";
        case "dmg":
            return "application/octet-stream";
        case "iso":
            return "application/octet-stream";
        case "img":
            return "application/octet-stream";
        case "msi":
            return "application/octet-stream";
        case "msp":
            return "application/octet-stream";
        case "msm":
            return "application/octet-stream";
        case "docx":
            return "application/vnd.openxmlformats-officedocument.wordprocessingml.document";
        case "xlsx":
            return "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
        case "pptx":
            return "application/vnd.openxmlformats-officedocument.presentationml.presentation";
        case "mid":
            return "audio/midi";
        case "midi":
            return "audio/midi";
        case "kar":
            return "audio/midi";
        case "mp3":
            return "audio/mpeg";
        case "ogg":
            return "audio/ogg";
        case "m4a":
            return "audio/x-m4a";
        case "ra":
            return "audio/x-realaudio";
        case "3gpp":
            return "video/3gpp";
        case "3gp":
            return "video/3gpp";
        case "ts":
            return "video/mp2t";
        case "mp4":
            return "video/mp4";
        case "mpeg":
            return "video/mpeg";
        case "mpg":
            return "video/mpeg";
        case "mov":
            return "video/quicktime";
        case "webm":
            return "video/webm";
        case "flv":
            return "video/x-flv";
        case "m4v":
            return "video/x-m4v";
        case "mng":
            return "video/x-mng";
        case "asx":
            return "video/x-ms-asf";
        case "asf":
            return "video/x-ms-asf";
        case "wmv":
            return "video/x-ms-wmv";
        case "avi":
            return "video/x-msvideo";

        default:
            return "application/octet-stream";
        }
    } //F.E.
    
} //CLS END
