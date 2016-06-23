//
//  SyncEngine.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 14/06/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit

public class SyncEngine: NSObject {
    
    class var sharedInstance: SyncEngine {
        struct Static {
            static var instance: SyncEngine?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = SyncEngine(customData: true);
        }
        
        return Static.instance!
    } //P.E.
    
    private var _urlToSync:NSURL!
    private var _authentication:[String:String]?;
    
    private var _languageCode:String = "";
    
    private var _isCustomData = false;
    
    private lazy var syncedFile: String = {
        return "\(self.dynamicType)";
    }()
    
    private lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.cubix.GIST" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
        //let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString;
    }();
    
    private lazy var syncedFileUrl: NSURL = {
        return self.applicationDocumentsDirectory.URLByAppendingPathComponent("\(self.syncedFile + self._languageCode).plist");
    }();
    
    //Flag if dict date is updated
    private var _hasUpdate:Bool = false;
    
    private var _dictData:NSMutableDictionary?
    internal var dictData:NSDictionary? {
        get {
            return _dictData;
        }
    } //P.E.
    
    //Server date
    public static var lastSyncedServerDate:String? {
        get {
            return SyncEngine.sharedInstance.lastSyncedServerDate;
        }
    } //P.E.
    
    private var lastSyncedServerDate:String? {
        get {
            return NSUserDefaults.standardUserDefaults().objectForKey("LAST_SYNCED_SERVER_DATE" + _languageCode) as? String;
        }
        
        set {
            NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: "LAST_SYNCED_SERVER_DATE" + _languageCode);
            NSUserDefaults.standardUserDefaults().synchronize();
        }
    } //P.E.
    
    private var lastSyncedResponseDate:NSDate? {
        get {
            return NSUserDefaults.standardUserDefaults().objectForKey("LAST_SYNCED_RESPONSE_DATE" + _languageCode) as? NSDate;
        }
        
        set {
            NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: "LAST_SYNCED_RESPONSE_DATE" + _languageCode);
            NSUserDefaults.standardUserDefaults().synchronize();
        }
    } //P.E.
    
    public class func initialize(urlToSync:String, authentication:[String:String]? = nil) {
        SyncEngine.sharedInstance.initialize(urlToSync, authentication: authentication);
    } //F.E.
    
    private func initialize(urlToSync:String, authentication:[String:String]? = nil) {
        
        #if !DEBUG && !RELEASE
            UIAlertView(title: "Sync Engine Error", message: "Add '-DDEBUG' and -DRELEASE in their respective sections of Project Build Settings ('Swift Compiler – Custom Flags' -> 'Other Swift Flags')", delegate: nil, cancelButtonTitle: "OK").show();
        #endif
        
        //--
        _urlToSync = NSURL(string: urlToSync);
        _authentication = authentication;
    } //F.E.
    
    override init() {
        super.init();
        //--
        self.setupSyncedFile();
    } //P.E.
    
    private func setupSyncedFile() {
        var hasToSync:Bool = true;
        
        if let syncedFileUrlRes:String = NSBundle.mainBundle().pathForResource(self.syncedFile, ofType: "plist") {
            
            //Localization
            if (syncedFileUrlRes.rangeOfString("lproj") != nil && syncedFileUrlRes.rangeOfString("Base.lproj") == nil) {
                _languageCode = "-" + NSBundle.mainBundle().preferredLocalizations[0]
            }
            
            //--
            //If File does not exist
            if (NSFileManager.defaultManager().fileExistsAtPath(self.syncedFileUrl.path!) == false) {
                do {
                    try NSFileManager.defaultManager().copyItemAtURL(NSURL(fileURLWithPath: syncedFileUrlRes), toURL: syncedFileUrl);
                    //--
                    hasToSync = false; // NO Sync required, if new file created
                } catch  {
                    let nserror = error as NSError
                    NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                    abort()
                }
            }
            
        } else {
            NSLog("Unresolved error : \(self.syncedFile).plist file not found in the resource folder: For ref., You may download 'Synced PLists' folder from git repo (https://github.com/cubixlabs/GIST-Framework).");
            abort();
        }
        
        
        //Fetching Data
        _dictData = NSMutableDictionary(contentsOfURL: self.syncedFileUrl);//NSDictionary(contentsOfURL: self.syncedFileUrl);
        
        if (hasToSync) {
            #if DEBUG
                //Sync
                self.syncFromResource(hasToOverride: true); // Has to override if DEBUG
            #else
                //Sync
                self.syncFromResource();
            #endif
        }
    } //F.E.
    
    /*
    private func validateBuildVersion() {
        let curBuildVersion:String = AppInfo.versionNBuildNumber;
        
        var hasToUpdateVersion:Bool = false;
        
        if let fileVersion:String = _dictData?["VERSION_NUMBER"] as? String {
            if (curBuildVersion != fileVersion) {
                
                //Sync
                self.syncFromResource();
                
                //Update Version
                hasToUpdateVersion = true;
            }
        } else {
            //Set or Update Version
            hasToUpdateVersion = true;
        }
        
        if (hasToUpdateVersion) {
            _dictData?["VERSION_NUMBER"] = curBuildVersion;
            self.synchronize(true); // Forceing to be synchronized
        }
    } //F.E.
    */
    
    public class func objectForKey<T>(aKey: String?) -> T? {
        return SyncEngine.sharedInstance.objectForKey(aKey);
    } //F.E.
    
    internal func objectForKey<T>(aKey: String?) -> T? {
        guard (aKey != nil) else {
            return nil;
        }
        
        if (_isCustomData) {
            return self.customObjectForKey(aKey!);
        }
        
        return _dictData?.objectForKey(aKey!) as? T;
    } //F.E.
    
    private func syncFromResource(hasToOverride override:Bool = false) {
        let syncedFileUrlRes:String = NSBundle.mainBundle().pathForResource(self.syncedFile, ofType: "plist")!
        
        //Sync file from Resource folder
        let resDictData:NSDictionary = NSDictionary(contentsOfFile: syncedFileUrlRes)!;
        
        //Getting all keys from resource dictionary
        let resAllKeys:[String] = resDictData.allKeys as! [String];
        
        //Iterating for resource dict keys
        for key:String in resAllKeys {
            //If key does not exist, put one with value
            if (_dictData![key] == nil || override) {
                _dictData![key] = resDictData[key];
                
                //Flagging on for hasUpdate so that it can be synchronized
                _hasUpdate = true;
            }
        }
        
        //If the syncFile has different no of keys, then adujust them
        if (resDictData.count != _dictData!.count) {
            let allKeys:[String] = _dictData!.allKeys as! [String];
            
            //Iterating for current dict keys
            for key:String in allKeys {
                //If key does not exist, put one with value
                if (resDictData[key] == nil) {
                    
                    //Removing extra key
                    _dictData!.removeObjectForKey(key);
                    
                    //Flagging on for hasUpdate so that it can be synchronized
                    _hasUpdate = true;
                }
            }
        }
        
        //Syncronize
        self.synchronize();
    } //F.E.
    
    internal func syncForData(dict:NSDictionary) -> Bool {
        if (dict.count == 0) {
            return false;
        }
        
        let allKeys:[String] = dict.allKeys as! [String];
        
        for key:String in allKeys {
            //??if _dictData!.objectForKey(key) != nil {
                let nValue:AnyObject = dict.objectForKey(key)!;
                //--
                _dictData![key] = nValue;
            //??}
        }
        
        self.synchronize(true);
        
        return true;
    } //F.E.
    
    private func synchronize(forced:Bool = false) {
        if (_hasUpdate || forced) {
            
            //Flagging off
            _hasUpdate = false;
            
            //Updating files
            _dictData?.writeToURL(self.syncedFileUrl, atomically: true);
        }
    } //F.E.
    
    private var hasSyncThresholdTimePassed:Bool {
        get {
            let currDate:NSDate = NSDate();
            //--
            if let lastResponseDate:NSDate = self.lastSyncedResponseDate {
                //60 * 60 * 2 - two hours
                return (currDate.timeIntervalSinceDate(lastResponseDate) >=  Double(7200));
                
            } else {
                return true;
            }
        }
    } //F.E.
    
    public class func syncData() {
        SyncEngine.sharedInstance.syncData();
    } //F.E.
    
    private func syncData() {
        guard _urlToSync != nil else {
            
            print("Not initialized or invalid url path is provided; Call/Check SyncEngine.initialize(:) in application(didFinishLaunchingWithOptions:)");
            
            abort();
        }
        
        if self.hasSyncThresholdTimePassed {
            self.syncDataRequest();
        }
    } //F.E.
    
    private func syncDataRequest() {
        let langSuff:String = NSBundle.mainBundle().preferredLocalizations[0];
        let params:NSMutableString = NSMutableString(string: "language=\(langSuff)");
        
        if let lastUpdatedAt:String = self.lastSyncedServerDate {
            params.appendString("&updated_at=\(lastUpdatedAt)");
        }
        
        let request = NSMutableURLRequest(URL: _urlToSync);//NSURLRequest(URL: url!)
        
        request.HTTPMethod = "POST";
        
        //Content Type
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type");
        
        if let authentication:[String:String] = _authentication {
            for keyValue:(String, String) in authentication {
                request.addValue(keyValue.1, forHTTPHeaderField: keyValue.0);
            }
        }
        
        //HTTP Body
        request.HTTPBody = params.dataUsingEncoding(NSUTF8StringEncoding);
        
        //Request Time Out
        request.timeoutInterval = 30;
        
        let config = NSURLSessionConfiguration.defaultSessionConfiguration();
        let session = NSURLSession(configuration: config)
        
        let task = session.dataTaskWithRequest(request, completionHandler: {(data:NSData?, response:NSURLResponse?, error:NSError?) in
            if (error == nil) {
                
                do {
                    if let dictData:NSDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(rawValue: 0)) as? NSDictionary {
                        
                        let error:Int = dictData["error"] as? Int ?? 0;
                        let message:String? = dictData["message"] as? String;
                        
                        //If Has data and no error ... !
                        if let resData:NSDictionary = dictData["data"] as? NSDictionary where error == 0{
                            self.syncForServerData(resData);
                        } else {
                            print("message : \(message)");
                        }
                    }
                }
                catch {
                    print("INVALID JSON");
                }
            } else {
                print("Error : \(error?.localizedDescription)"); //
                error?.description
            }
        });
        
        task.resume();
    } //F.E.
    
    private func syncForServerData(dict:NSDictionary) {
       //Updating server updated date
        self.lastSyncedServerDate = dict["updated_at"] as? String;
        
        //Updating server response date - local
        self.lastSyncedResponseDate = NSDate();
        
        
        if let syncData:NSDictionary =  dict["sync_data"] as? NSDictionary {
            
            //Syncing Texts
            if let syncedText:NSDictionary = syncData["text"] as? NSDictionary {
                SyncedText.syncForData(syncedText);
            }
            
            //Syncing Colors
            if let colors:NSDictionary = syncData["color"] as? NSDictionary {
                SyncedColors.syncForData(colors);
            }
            
            //Syncing Texts
            if let constants:NSDictionary = syncData["constant"] as? NSDictionary {
                SyncedConstants.syncForData(constants);
            }
            
            //Syncing Texts
            if let fontStyles:NSDictionary = syncData["font_style"] as? NSDictionary {
                SyncedFontStyles.syncForData(fontStyles);
            }
            
            if let customData:NSDictionary = syncData["custom"] as? NSDictionary {
                self.syncForCustomData(customData);
            }
        }
        
    } //F.E.
    
    //MARK: - Custom Data
    init(customData:Bool) {
        super.init();
        //--
        _isCustomData = customData;
        
        if (_isCustomData) {
            self.setupCustomSyncedFile();
        }
    } //P.E.
 
    private func setupCustomSyncedFile() {
        _dictData = NSMutableDictionary();
    } //F.E.
    
    private func customObjectForKey<T>(aKey: String) -> T? {
        let rtnData:T? = _dictData?.objectForKey(aKey) as? T;
        
        if (rtnData == nil) {
            
            if let syncedFileUrlRes = NSBundle.mainBundle().pathForResource(aKey, ofType: "plist") {
                
                var languageCode:String = "";
                
                //Localization
                if (syncedFileUrlRes.rangeOfString("lproj") != nil && syncedFileUrlRes.rangeOfString("Base.lproj") == nil) {
                    languageCode = "-" + NSBundle.mainBundle().preferredLocalizations[0]
                }
                
                let url:NSURL = self.applicationDocumentsDirectory.URLByAppendingPathComponent("\(aKey+languageCode).plist");
                //--
                var isFileExist:Bool = NSFileManager.defaultManager().fileExistsAtPath(url.path!);
                
                #if DEBUG
                    if (isFileExist) {
                        do {
                            try NSFileManager.defaultManager().removeItemAtURL(url);
                        } catch  {
                            let nserror = error as NSError
                            NSLog("Unresolved error \(nserror), \(nserror.userInfo)");
                            abort();
                        }
                        //--
                        isFileExist = false;
                    }
                #endif
                
                //If File does not exist
                if (isFileExist == false) {
                    do {
                        try NSFileManager.defaultManager().copyItemAtURL(NSURL(fileURLWithPath: syncedFileUrlRes), toURL: url);
                    } catch  {
                        let nserror = error as NSError
                        NSLog("Unresolved error \(nserror), \(nserror.userInfo)");
                        abort()
                    }
                }
                
                //Fetching Data
                if let arr = NSMutableArray(contentsOfURL: url) {
                    _dictData?.setObject(arr, forKey: aKey);
                    //--
                    return arr as? T;
                } else if let dict = NSMutableDictionary(contentsOfURL: url) {
                    _dictData?.setObject(dict, forKey: aKey);
                    //--
                    return dict as? T;
                }
                
            } else {
                NSLog("Unresolved error : \(self.syncedFile).plist file not found in the resource folder");
                abort();
            }
        }
        
        return rtnData;
    } //F.E.
    
    private func syncForCustomData(dict:NSDictionary) -> Bool {
        if (dict.count == 0) {
            return false;
        }
        
        let allKeys:[String] = dict.allKeys as! [String];
        
        for key:String in allKeys {
            let nValue:AnyObject = dict.objectForKey(key)!;
            
            if _dictData?.objectForKey(key) != nil {
                _dictData![key] = nValue;
            }
            
            //Localization
            var languageCode:String = "";
            if let syncedFileUrlRes = NSBundle.mainBundle().pathForResource(key, ofType: "plist") where (syncedFileUrlRes.rangeOfString("lproj") != nil && syncedFileUrlRes.rangeOfString("Base.lproj") == nil) {
                //Localization
                languageCode = "-" + NSBundle.mainBundle().preferredLocalizations[0];
            }
            //-
            let url:NSURL = self.applicationDocumentsDirectory.URLByAppendingPathComponent("\(key+languageCode).plist");
            nValue.writeToURL(url, atomically: true);
        }
        
        return true;
    } //F.E.
    
} //CLS END
