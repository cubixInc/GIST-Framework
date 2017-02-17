//
//  GISTApplication.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 07/09/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit

/// GISTApplication protocol to receive events
@objc public protocol GISTApplicationDelegate {
    @objc optional func applicationWillTerminate(_ application: UIApplication);
    @objc optional func applicationDidBecomeActive(_ application: UIApplication);
    @objc optional func applicationWillResignActive(_ application: UIApplication);
    @objc optional func applicationDidEnterBackground(_ application: UIApplication);
    @objc optional func applicationDidFinishLaunching(_ application: UIApplication);
    @objc optional func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void);
} //F.E.


/// GISTApplication is a singleton class to handle UIApplicationDelegate events to send callbacks in a registerd delegate classes
open class GISTApplication: NSObject, UIApplicationDelegate {
    
    //MARK: - Properties
    
    /// Singleton sharedInstance for GISTApplication
    open static var sharedInstance:GISTApplication = GISTApplication();
    
    /// Registers delegate - it may hold more than one delegate.
    open var delegate:GISTApplicationDelegate? {
        set {
            guard (newValue != nil) else {
                return;
            }
            
            self.registerDelegate(newValue!);
        }
        
        get {
            assertionFailure("getter not available")
            return nil; // Unavailable
        }
    } //P.E.
    
    /// Holding a collection fo weak delegate instances
    private var _delegates:NSHashTable<Weak<GISTApplicationDelegate>> = NSHashTable();
    
    //MARK: - Constructors
    
    /// Private constuctor so that it can not be initialized from outside of the class
    private override init() {
        super.init();
    } //F.E.
    
    //MARK: - Methods
    
    /**
     Registers delegate targets.
     It may register multiple targets.
     */
    open func registerDelegate(_ target:GISTApplicationDelegate) {
        if self.weakDelegateForTarget(target) == nil {
            //Adding if not added
            _delegates.add(Weak<GISTApplicationDelegate>(value: target))
        }
    } //F.E.
    
    /**
     Unregisters a delegate target.
     It should be called when, the target does not want to reveice application events.
    */
    open func unregisterDelegate(_ target:GISTApplicationDelegate) {
        if let wTarget:Weak<GISTApplicationDelegate> = self.weakDelegateForTarget(target) {
            _delegates.remove(wTarget);
        }
    } //F.E.
    
    /// Retrieving weak instance of a given target
    ///
    /// - Parameter target: GISTApplicationDelegate
    /// - Returns: an optional weak target of a target (e.g. Weak<GISTApplicationDelegate>?).
    private func weakDelegateForTarget(_ target:GISTApplicationDelegate) -> Weak<GISTApplicationDelegate>?{
        let enumerator:NSEnumerator = _delegates.objectEnumerator();
        
        while let wTarget:Weak<GISTApplicationDelegate> = enumerator.nextObject() as? Weak<GISTApplicationDelegate> {
            if (wTarget.value == nil) {
                //Removing if lost target already
                _delegates.remove(wTarget);
            } else if ((target as AnyObject).isEqual(wTarget.value)) {
                return wTarget;
            }
        }
         
        return nil;
    } //F.E.
    
    //MARK: - UIApplicationDelegate methods
    
    /// Protocol method for applicationWillTerminate
    ///
    /// - Parameter application: UIApplication
    open func applicationWillTerminate(_ application: UIApplication) {
        //Calling Delegate Methods
        let enumerator:NSEnumerator = self._delegates.objectEnumerator();
        
        while let wTarget:Weak<GISTApplicationDelegate> = enumerator.nextObject() as? Weak<GISTApplicationDelegate> {
            wTarget.value?.applicationWillTerminate?(application);
        }
    } //F.E.
    
    /// Protocol method for applicationDidBecomeActive
    ///
    /// - Parameter application: UIApplication
    open func applicationDidBecomeActive(_ application: UIApplication) {
        //Calling Delegate Methods
        let enumerator:NSEnumerator = self._delegates.objectEnumerator();
        
        while let wTarget:Weak<GISTApplicationDelegate> = enumerator.nextObject() as? Weak<GISTApplicationDelegate> {
            wTarget.value?.applicationDidBecomeActive?(application);
        }
    } //F.E.
    
    /// Protocol method for applicationWillResignActive
    ///
    /// - Parameter application: UIApplication
    open func applicationWillResignActive(_ application: UIApplication) {
        //Calling Delegate Methods
        let enumerator:NSEnumerator = self._delegates.objectEnumerator();
        
        while let wTarget:Weak<GISTApplicationDelegate> = enumerator.nextObject() as? Weak<GISTApplicationDelegate> {
            wTarget.value?.applicationWillResignActive?(application);
        }
    } //F.E.
    
    /// Protocol method for applicationDidEnterBackground
    ///
    /// - Parameter application: UIApplication
    open func applicationDidEnterBackground(_ application: UIApplication) {
        //Calling Delegate Methods
        let enumerator:NSEnumerator = self._delegates.objectEnumerator();
        
        while let wTarget:Weak<GISTApplicationDelegate> = enumerator.nextObject() as? Weak<GISTApplicationDelegate> {
            wTarget.value?.applicationDidEnterBackground?(application);
        }
    } //F.E.
    
    /// Protocol method for applicationDidFinishLaunching
    ///
    /// - Parameter application: UIApplication
    open func applicationDidFinishLaunching(_ application: UIApplication) {
        //Calling Delegate Methods
        let enumerator:NSEnumerator = self._delegates.objectEnumerator();
        
        while let wTarget:Weak<GISTApplicationDelegate> = enumerator.nextObject() as? Weak<GISTApplicationDelegate> {
            wTarget.value?.applicationDidFinishLaunching?(application);
        }
    } //F.E.
    
    /// Protocol method for didReceiveRemoteNotification
    ///
    /// - Parameters:
    ///   - application: UIApplication
    ///   - userInfo: User Info
    ///   - completionHandler: Completion block
    open func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        //Calling Delegate Methods
        let enumerator:NSEnumerator = self._delegates.objectEnumerator();
        
        while let wTarget:Weak<GISTApplicationDelegate> = enumerator.nextObject() as? Weak<GISTApplicationDelegate> {
            wTarget.value?.application?(application, didReceiveRemoteNotification: userInfo, fetchCompletionHandler: completionHandler);
        }
    } //F.E.
    
    
} //CLS END
