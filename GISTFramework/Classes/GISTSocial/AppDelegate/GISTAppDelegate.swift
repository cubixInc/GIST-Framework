//
//  GISTAppDelegate.swift
//  SocialGIST
//
//  Created by Shoaib Abdul on 13/03/2017.
//  Copyright © 2017 Social Cubix Inc. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import UserNotifications

private let SAVE_TOKEN_REQUEST = "save_token";

open class GISTAppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    public var window: UIWindow?
    
    private lazy var transparentHUDView:UIView = {
        let viw = UIView(frame: self.window!.bounds);
        
        self.window!.addSubview(viw);
        
        return viw;
    } ();
    
    //MARK: - Application Delegate
    open func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //Initialize Reachability
        ReachabilityHelper.sharedInstance.setupReachability(self.window!);
       
        //Setting up keyboard avoiding
        self.setupKeyboardManager();
        
        //Register For Push Notification
        if (GIST_GLOBAL.hasAskedForApnsPermission) {
            self.registerForPushNotifications();
        }
        
        return true;
    } //F.E.
    
    open func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Convert token to string
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        
        // Print it to console
        print("APNs device token: \(deviceTokenString)")

        GIST_GLOBAL.deviceToken = deviceTokenString;
        self.savePushToken();
    } //F.E.
    
    open func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register:", error)
    } //F.E.

    open func applicationWillResignActive(_ application: UIApplication) {
        GISTApplication.sharedInstance.applicationWillResignActive(application);
    } //F.E.

    open func applicationDidEnterBackground(_ application: UIApplication) {
        GISTApplication.sharedInstance.applicationDidEnterBackground(application);
    } //F.E.

    open func applicationWillEnterForeground(_ application: UIApplication) {
        
    } //F.E.

    open func applicationDidBecomeActive(_ application: UIApplication) {
        //Badge count to zero
        application.applicationIconBadgeNumber = 0;
        
        GISTApplication.sharedInstance.applicationDidBecomeActive(application);
    } //F.E.

    open func applicationWillTerminate(_ application: UIApplication) {
        DATA_MANAGER.saveContext();
        
        GISTApplication.sharedInstance.applicationWillTerminate(application);
    } //F.E.
    
    open func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        var handled:Bool = false;
        
        /*
        if (url.scheme?.hasPrefix("fb"))! {
            handled = FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation);
        } else if (url.scheme?.hasPrefix("com.googleusercontent.apps"))! {
            handled = GIDSignIn.sharedInstance().handle(url, sourceApplication: sourceApplication, annotation: annotation);
        }
        */
        
        if let scheme:String = url.scheme, scheme.hasPrefix("socialgist") {
            handled = self.handle(application, open: url, sourceApplication: sourceApplication, annotation: annotation);
        }
        

        return handled;
    } //F.E.
    
    open func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        GISTApplication.sharedInstance.application(application, didReceiveRemoteNotification: userInfo, fetchCompletionHandler: completionHandler);
    } //F.E.
    
    //MARK: - Keyboard Avoiding
    open func setupKeyboardManager() {
        //Register Keyboard avoiding
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().keyboardDistanceFromTextField = 0;
    } //F.E.
    
    //MARK: - Notification Settings
    open func registerForPushNotifications() {
        //Flagging on
        GIST_GLOBAL.hasAskedForApnsPermission = true;
        
        //Registe for Notifications
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.delegate = self;
            let types:UNAuthorizationOptions = [UNAuthorizationOptions.badge, UNAuthorizationOptions.alert, UNAuthorizationOptions.sound];
            
            center.requestAuthorization(options: types) { (granted, error) in
                // Enable or disable features based on authorization.
                print("granted : \(granted)");
                GIST_GLOBAL.apnsPermissionGranted = granted;
            }
        } else {
            // Push Notification
            let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
        
        UIApplication.shared.registerForRemoteNotifications();
    } //F.E.
    
    @available(iOS 10.0, *)
    open func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
    } //F.E.
    
    @available(iOS 10.0, *)
    open func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
    } //F.E.
    
    //MARK: - Save Token
    private func savePushToken() {
        guard let usrData:[String:Any] = GIST_GLOBAL.userData, let token:String = GIST_GLOBAL.deviceToken, let userId:Int = usrData[USER_ID] as? Int else {
            return;
        }
        
        let params:[String:Any] = [
            "device_token":token,
            "device_type":"ios",
            USER_ID:userId
        ]
        
        let requestName = "\(HTTPServiceManager.sharedInstance.authenticationModule)/\(SAVE_TOKEN_REQUEST)";
        let httpRequest:HTTPRequest = HTTPServiceManager.request(requestName: requestName, parameters: params, delegate: nil);
        
        httpRequest.onSuccess { (rawData:Any?) in
            print("Device Token Saved ...");
        };
        
    } //F.E.
    
    //MARK: - Deep Linking
    public func handle(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        let host:String = url.host ?? "";
        let params:[String:String] = url.params;
        
        /*
        let alr:UIAlertView = UIAlertView(title: host, message: params.toJSONString() ?? "", delegate: nil, cancelButtonTitle: "Cancel", otherButtonTitles: "Ok");
        alr.show();
         */
        
        switch host {
        case "forgot_password":
            //socialgist://forgot_password?verification_token={verification_token}
            
            var usrData:[String:Any] = GIST_GLOBAL.userData ?? [:];
            usrData["verification_token"] = params["verification_token"];
            
            GIST_GLOBAL.userData = usrData;
            
            return true;
            
        case "signup_success":
            //socialgist://signup_success?email={email}&user_id={user_id}
            return true;
            
        case "change_email":
            //socialgist://change_email?verification_token={verification_token}&new_email={new_email}
            
            var usrData:[String:Any] = GIST_GLOBAL.userData ?? [:];
            usrData["verification_token"] = params["verification_token"];
            usrData["email"] = params["new_email"];
            
            GIST_GLOBAL.userData = usrData;

            return true;
            
        default:
            break;
        }
        
        
        return false;
    } //F.E.
    
    //MARK: - HUD
    public func showHUD() {
        self.window!.bringSubview(toFront: self.transparentHUDView);
        
        self.transparentHUDView.isHidden = false;
    } //F.E.
    
    public func hideHUD() {
        self.transparentHUDView.isHidden = true;
    } //F.E.
    
} //CLS END
