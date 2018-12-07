//
//  SyncEngine.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 14/06/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit

/**
 SyncEngine is framework to Sync Data from Server.
 It syncs application's Colors, Constants, Font Sizes/Styles and Texts/ Strings.
 */
open class SyncEngine: NSObject {
    
    //MARK: - Properties
    
    private static var _sharedInstance: SyncEngine = SyncEngine(customData: true);
    
    /// A singleton sharedInstance for SyncEngine
    class var sharedInstance: SyncEngine {
        get {
            return self._sharedInstance;
        }
    }
    
    private var _urlToSync:URL!
    private var _headers:[String:String] = [:];
    
    private var _languageCode:String = "";
    
    private var _isCustomData = false;
    
    private lazy var syncedFile: String = {
        return "\(type(of: self))";
    }()
    
    private lazy var applicationDocumentsDirectory: URL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }();
    
    private var _versionNumber:String?
    private var versionNumber:String {
        get {
            if (_versionNumber == nil) {
                _versionNumber = AppInfo.versionNBuildNumber;
            }
            
            return _versionNumber!;
        }
    }
    
    private var syncedFolderUrl: URL {
        get {
            return self.applicationDocumentsDirectory.appendingPathComponent("\(self.versionNumber)");
        }
    }
    
    private var syncedFileUrl: URL {
        get {
            return self.syncedFolderUrl.appendingPathComponent("\(self.syncedFile + self._languageCode).plist");
        }
    }
    
    //Flag if dict date is updated
    private var _hasUpdate:Bool = false;
    
    private var _dictData:NSMutableDictionary?
    internal var dictData:NSDictionary? {
        get {
            return _dictData;
        }
    } //P.E.
    
    /*
    
    open static var lastSyncedServerDate:String? {
        get {
            return SyncEngine.sharedInstance.lastSyncedServerDate;
        }
    } //P.E.
    */
    
    /// Holds Last Synced Server Data
    private var lastSyncedServerDate:String? {
        get {
            return UserDefaults.standard.object(forKey: "LAST_SYNCED_SERVER_DATE" + _languageCode) as? String;
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: "LAST_SYNCED_SERVER_DATE" + _languageCode);
            UserDefaults.standard.synchronize();
        }
    } //P.E.
    
    private var lastSyncedResponseDate:Date? {
        get {
            return UserDefaults.standard.object(forKey: "LAST_SYNCED_RESPONSE_DATE" + _languageCode) as? Date;
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: "LAST_SYNCED_RESPONSE_DATE" + _languageCode);
            UserDefaults.standard.synchronize();
        }
    } //P.E.
    
    public static var hasSyncDataUpdated:Bool {
        get {
            return SyncEngine.sharedInstance.hasSyncDataUpdated;
        }
    } //P.E.
    
    private var hasSyncDataUpdated:Bool = false;
    
    //MARK: - Constructors
    
    override init() {
        super.init();
         
        self.setupSyncedFile();
    } //P.E.
    
    //MARK: - Methods
    
    /// Static Initializer for Sync Engine.
    ///
    /// - Parameters:
    ///   - urlToSync: Http request url for Sync data
    ///   - authentication: Authentication Header if any
    public static func initialize(_ serverBaseURL:URL, requestName:String?, headers:[String:String]?) {
        SyncEngine.sharedInstance.initialize(serverBaseURL, requestName:requestName, headers: headers);
    } //F.E.
    
    /// Initializer for Sync Engine.
    ///
    /// - Parameters:
    ///   - urlToSync: Http request url for Sync data
    ///   - authentication: Authentication Header if any
    private func initialize(_ serverBaseURL:URL, requestName:String?, headers:[String:String]?) {
        _urlToSync = serverBaseURL.appendingPathComponent(requestName ?? "se/get_all");
        
        //Adding Language Key
        _headers["language"] = GIST_CONFIG.currentLanguageCode;
        
        //Security Headers
        if let dictHeaders:[String:String] = headers {
            for header in dictHeaders {
                _headers[header.key] = header.value;
            }
        }
        
    } //F.E.
    
    private func setupSyncedFile() {
        var hasToSync:Bool = true;
        
        if let syncedFileUrlRes:String = self.filePath(for: self.syncedFile) {
            
            //Localization
            if (syncedFileUrlRes.range(of: "lproj") != nil && syncedFileUrlRes.range(of: "Base.lproj") == nil) {
                _languageCode = "-" + GIST_CONFIG.currentLanguageCode
            } else {
                _languageCode = "";
            }
             
            //If Folder does not exist
            if (FileManager.default.fileExists(atPath: self.syncedFolderUrl.path) == false) {
                do {
                    try FileManager.default.createDirectory(at: self.syncedFolderUrl, withIntermediateDirectories: true, attributes: nil)
                } catch  {
                    let error = error as NSError
                    NSLog("Unresolved error \(error), \(error.userInfo)")
                    abort()
                }
            }
            
            //If File does not exist
            if (FileManager.default.fileExists(atPath: self.syncedFileUrl.path) == false) {
                do {
                    try FileManager.default.copyItem(at: URL(fileURLWithPath: syncedFileUrlRes), to: syncedFileUrl);
                    
                    hasToSync = false; // NO Sync required, if new file created
                } catch  {
                    let error = error as NSError
                    NSLog("Unresolved error \(error), \(error.userInfo)")
                    abort()
                }
            }
            
        } else {
            NSLog("Unresolved error : \(self.syncedFile).plist file not found in the resource folder: For ref., You may download 'Synced PLists' folder from git repo (https://github.com/cubixlabs/GIST-Framework).");
            abort();
        }
        
        
        //Fetching Data
        _dictData = NSMutableDictionary(contentsOf: self.syncedFileUrl);//NSDictionary(contentsOfURL: self.syncedFileUrl);
        
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
    
    /// Method to retrieve value for a given key of SyncEngine.
    ///
    /// - Parameter aKey: key from SyncEngine
    /// - Returns: A generic value for a given key.
    public class func objectForKey<T>(_ aKey: String?) -> T? {
        return self.sharedInstance.objectForKey(aKey);
    } //F.E.
    
    internal func objectForKey<T>(_ aKey: String?) -> T? {
        guard (aKey != nil) else {
            return nil;
        }
        
        if (_isCustomData) {
            return self.customObjectForKey(aKey!);
        } else {
            return _dictData?.object(forKey: aKey!) as? T;
        }
    } //F.E.
    
    /// This method is used to sync an object with SyncEngine.
    ///
    /// - Parameters:
    ///   - anObject: A SyncEngine object
    ///   - aKey: A key of SyncEngine
    public class func syncObject(_ anObject: AnyObject, forKey aKey: String) {
        return self.sharedInstance.syncObject(anObject, forKey:aKey);
    } //F.E.
    
    internal func syncObject(_ anObject: AnyObject, forKey aKey: String) {
        if (_isCustomData) {
            self.syncForCustomData([aKey:anObject]);
        } else {
            self.syncForData([aKey:anObject]);
        }
    } //F.E.
    
    private func syncFromResource(hasToOverride override:Bool = false) {
        let syncedFileUrlRes:String = self.filePath(for: self.syncedFile)!
        
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
                    _dictData!.removeObject(forKey: key);
                    
                    //Flagging on for hasUpdate so that it can be synchronized
                    _hasUpdate = true;
                }
            }
        }
        
        //Syncronize
        self.synchronize();
    } //F.E.
    
    /// Sync Data from a Key value pair.
    ///
    /// - Parameter dict: NSDictionary
    /// - Returns: Flag for success or failure.
    @discardableResult public class func syncForData(_ dict:NSDictionary) -> Bool {
        return self.sharedInstance.syncForData(dict);
    } //F.E.
    
    @discardableResult internal func syncForData(_ dict:NSDictionary) -> Bool {
        if (dict.count == 0) {
            return false;
        }
        
        let allKeys:[String] = dict.allKeys as! [String];
        
        for key:String in allKeys {
            //??if _dictData!.objectForKey(key) != nil {
                let nValue:Any = dict.object(forKey: key)!;
                 
                _dictData![key] = nValue;
            //??}
        }
        
        self.synchronize(true);
        
        return true;
    } //F.E.
    
    private func synchronize(_ forced:Bool = false) {
        if (_hasUpdate || forced) {
            
            //Flagging off
            _hasUpdate = false;
            
            //Updating files
            _dictData?.write(to: self.syncedFileUrl, atomically: true);
        }
    } //F.E.
    
    private var hasSyncThresholdTimePassed:Bool {
        get {
            let currDate:Date = Date();
             
            if let lastResponseDate:Date = self.lastSyncedResponseDate {
                //60 * 60 * 2 - two hours
                return (currDate.timeIntervalSince(lastResponseDate) >=  Double(7200));
                
            } else {
                return true;
            }
        }
    } //F.E.
    
    /**
     This static method should be called in applicationDidBecomeActive method of AppDelegate to sync data from Server.
     */
    public static func syncData() {
        SyncEngine.sharedInstance.syncData();
    } //F.E.
    
    private func syncData() {
        guard _urlToSync != nil else {
            
            print("Not initialized or invalid url path is provided; Call/Check SyncEngine.initialize(:) in application(didFinishLaunchingWithOptions:)");
            
            return;
        }
        
        if self.hasSyncThresholdTimePassed {
            self.syncDataRequest();
        }
    } //F.E.
    
    private func syncDataRequest() {
        let params:NSMutableString = NSMutableString(string: "language=\(GIST_CONFIG.currentLanguageCode)");
        
        if let lastUpdatedAt:String = self.lastSyncedServerDate {
            params.append("&updated_at=\(lastUpdatedAt)");
        }
        
        var request = URLRequest(url: _urlToSync);
        
        request.httpMethod = "POST";
        
        //Content Type
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type");
        
        for keyValue:(String, String) in _headers {
            request.addValue(keyValue.1, forHTTPHeaderField: keyValue.0);
        }
        
        //HTTP Body
        request.httpBody = params.data(using: String.Encoding.utf8.rawValue);
        
        //Request Time Out
        request.timeoutInterval = 30;
        
        URLSession.shared.dataTask(with: request) {data, response, error in
            if (error == nil) {
                do {
                    if let dictData:NSDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions(rawValue: 0)) as? NSDictionary {
                        
                        let error:Int = dictData["error"] as? Int ?? 0;
                        let message:String? = dictData["message"] as? String;
                        
                        //If Has data and no error ... !
                        if let resData:NSDictionary = dictData["data"] as? NSDictionary , error == 0, resData.count > 0 {
                            
                            self.hasSyncDataUpdated = true;
                            
                            self.syncForServerData(resData);
                        } else {
                            print("message : \(String(describing: message))");
                        }
                    }
                }
                catch {
                    print("INVALID JSON");
                }
            } else {
                print("Error : \(String(describing: error?.localizedDescription))");
            }
        }.resume();
    } //F.E.
    
    private func syncForServerData(_ dict:NSDictionary) {
       //Updating server updated date
        self.lastSyncedServerDate = dict["updated_at"] as? String;
        
        //Updating server response date - local
        self.lastSyncedResponseDate = Date();
        
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
         
        _isCustomData = customData;
        
        if (_isCustomData) {
            self.setupCustomSyncedFile();
        }
    } //P.E.
 
    private func setupCustomSyncedFile() {
        _dictData = NSMutableDictionary();
    } //F.E.
    
    private func filePath(for resource:String) -> String? {
        let currLanguageCode:String = GIST_CONFIG.currentLanguageCode == "en" ? "Base" : GIST_CONFIG.currentLanguageCode;
        let path:String? = Bundle.main.path(forResource: resource, ofType: "plist", inDirectory: nil, forLocalization: currLanguageCode) ?? Bundle.main.path(forResource: resource, ofType: "plist")
        return path;
    }
    
    /// Method to retrieve a custom object for a given key of SyncEngine.
    ///
    /// - Parameter aKey: key from SyncEngine
    /// - Returns: A generic object for a given key
    private func customObjectForKey<T>(_ aKey: String) -> T? {
        if let syncedFileUrlRes = self.filePath(for: aKey) {
            
            var languageCode:String = "";
            
            //Localization
            if (syncedFileUrlRes.range(of: "lproj") != nil && syncedFileUrlRes.range(of: "Base.lproj") == nil) {
                languageCode = "-" + GIST_CONFIG.currentLanguageCode;
            }
            
            //If Folder does not exist
            if (FileManager.default.fileExists(atPath: self.syncedFolderUrl.path) == false) {
                do {
                    try FileManager.default.createDirectory(at: self.syncedFolderUrl, withIntermediateDirectories: true, attributes: nil)
                } catch  {
                    let error = error as NSError
                    NSLog("Unresolved error \(error), \(error.userInfo)")
                    abort()
                }
            }
            
            let url:URL = self.syncedFolderUrl.appendingPathComponent("\(aKey+languageCode).plist");
             
            var isFileExist:Bool = FileManager.default.fileExists(atPath: url.path);
            
            #if DEBUG
                if (isFileExist) {
                    do {
                        try FileManager.default.removeItem(at: url);
                    } catch  {
                        let nserror = error as NSError
                        NSLog("Unresolved error \(nserror), \(nserror.userInfo)");
                        abort();
                    }
                     
                    isFileExist = false;
                }
            #endif
            
            //If File does not exist
            if (isFileExist == false) {
                do {
                    try FileManager.default.copyItem(at: URL(fileURLWithPath: syncedFileUrlRes), to: url);
                } catch  {
                    let nserror = error as NSError
                    NSLog("Unresolved error \(nserror), \(nserror.userInfo)");
                    abort()
                }
            }
            
            //Fetching Data
            if let arr = NSMutableArray(contentsOf: url) {
                return arr as? T;
            } else if let dict = NSMutableDictionary(contentsOf: url) {
                return dict as? T;
            }
            
        } else {
            NSLog("Unresolved error : \(aKey).plist file not found in the resource folder");
            abort();
        }
        
        return nil;
    } //F.E.
    
    @discardableResult private func syncForCustomData(_ dict:NSDictionary) -> Bool {
        if (dict.count == 0) {
            return false;
        }
        
        let allKeys:[String] = dict.allKeys as! [String];
        
        for key:String in allKeys {
            let nValue:AnyObject = dict.object(forKey: key) as AnyObject;
            
            if _dictData?.object(forKey: key) != nil {
                _dictData![key] = nValue;
            }
            
            //Localization
            var languageCode:String = "";
            if let syncedFileUrlRes = self.filePath(for: key), (syncedFileUrlRes.range(of: "lproj") != nil && syncedFileUrlRes.range(of: "Base.lproj") == nil) {
                //Localization
                languageCode = "-" + GIST_CONFIG.currentLanguageCode;
            }
            
            let url:URL = self.syncedFolderUrl.appendingPathComponent("\(key + languageCode).plist");
            _ = nValue.write(to: url, atomically: true);
        }
        
        return true;
    } //F.E.
    
    public static func reset() {
        self.sharedInstance.reset();
    } //F.E.
    
    func reset() {
        if (_isCustomData) {
            self.setupCustomSyncedFile();
            
            SyncedColors.sharedInstance.reset();
            SyncedConstants.sharedInstance.reset();
            SyncedFontStyles.sharedInstance.reset();
            SyncedText.sharedInstance.reset();
            
        } else {
            self.setupSyncedFile();
        }
    } //F.E.
    
} //CLS END
