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


open class GISTAppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    public var window: UIWindow?
    
    //MARK: - Application Delegate
    open func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //Initialize Reachability
        ReachabilityHelper.sharedInstance.setupReachability(self.window!);
       
        //Setting up keyboard avoiding
        self.setupKeyboardManager();
        
        //Register For Push Notification
        if (GISTUserPreferences.user != nil) {
            self.registerForPushNotifications();
        }
        
        return true;
    } //F.E.
    
    open func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        
        if notificationSettings.types != UIUserNotificationType() {
            application.registerForRemoteNotifications()
        }
    } //F.E.
    
    open func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Convert token to string
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        
        // Print it to console
        print("APNs device token: \(deviceTokenString)")

        GIST_GLOBAL.deviceToken = deviceTokenString;
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
        GISTApplication.sharedInstance.applicationWillTerminate(application);
    } //F.E.
    
    open func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        let handled:Bool = false;
        
        /*
        if (url.scheme?.hasPrefix("fb"))! {
            handled = FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation);
        } else if (url.scheme?.hasPrefix("com.googleusercontent.apps"))! {
            handled = GIDSignIn.sharedInstance().handle(url, sourceApplication: sourceApplication, annotation: annotation);
        }
         */

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
    
} //CLS END
