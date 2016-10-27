//
//  GISTApplication.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 07/09/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit

@objc public protocol GISTApplicationDelegate {
    @objc optional func applicationWillTerminate(_ application: UIApplication);
    @objc optional func applicationDidBecomeActive(_ application: UIApplication);
    @objc optional func applicationWillResignActive(_ application: UIApplication);
    @objc optional func applicationDidEnterBackground(_ application: UIApplication);
    @objc optional func applicationDidFinishLaunching(_ application: UIApplication)
} //F.E.

open class GISTApplication: NSObject, UIApplicationDelegate {
    open static var sharedInstance:GISTApplication = GISTApplication();
    
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
    
    fileprivate var _delegates:NSHashTable<Weak<GISTApplicationDelegate>> = NSHashTable();
    
    fileprivate override init() {
        super.init();
    } //F.E.
    
    //MARK: - Delegate Handling
    open func registerDelegate(_ target:GISTApplicationDelegate) {
        if self.weakDelegateForTarget(target) == nil {
            //Adding if not added
            _delegates.add(Weak<GISTApplicationDelegate>(value: target))
        }
    } //F.E.
    
    func unregisterDelegate(_ target:GISTApplicationDelegate) {
        if let wTarget:Weak<GISTApplicationDelegate> = self.weakDelegateForTarget(target) {
            _delegates.remove(wTarget);
        }
    } //F.E.
    
    fileprivate func weakDelegateForTarget(_ target:GISTApplicationDelegate) -> Weak<GISTApplicationDelegate>?{
        let enumerator:NSEnumerator = _delegates.objectEnumerator();
        
        while let wTarget:Weak<GISTApplicationDelegate> = enumerator.nextObject() as? Weak<GISTApplicationDelegate> {
            if (wTarget.value == nil) {
                //Removing if lost target already
                _delegates.remove(wTarget);
            } else if ((target as AnyObject).isEqual(wTarget.value)) {
                return wTarget;
            }
        }
        //--
        return nil;
    } //F.E.
    
    //MARK: - Application Delegate Methods calling
    open func applicationWillTerminate(_ application: UIApplication) {
        //Calling Delegate Methods
        let enumerator:NSEnumerator = self._delegates.objectEnumerator();
        
        while let wTarget:Weak<GISTApplicationDelegate> = enumerator.nextObject() as? Weak<GISTApplicationDelegate> {
            wTarget.value?.applicationWillTerminate?(application);
        }
    } //F.E.
    
    open func applicationDidBecomeActive(_ application: UIApplication) {
        //Calling Delegate Methods
        let enumerator:NSEnumerator = self._delegates.objectEnumerator();
        
        while let wTarget:Weak<GISTApplicationDelegate> = enumerator.nextObject() as? Weak<GISTApplicationDelegate> {
            wTarget.value?.applicationDidBecomeActive?(application);
        }
    } //F.E.
    
    open func applicationWillResignActive(_ application: UIApplication) {
        //Calling Delegate Methods
        let enumerator:NSEnumerator = self._delegates.objectEnumerator();
        
        while let wTarget:Weak<GISTApplicationDelegate> = enumerator.nextObject() as? Weak<GISTApplicationDelegate> {
            wTarget.value?.applicationWillResignActive?(application);
        }
    } //F.E.
    
    open func applicationDidEnterBackground(_ application: UIApplication) {
        //Calling Delegate Methods
        let enumerator:NSEnumerator = self._delegates.objectEnumerator();
        
        while let wTarget:Weak<GISTApplicationDelegate> = enumerator.nextObject() as? Weak<GISTApplicationDelegate> {
            wTarget.value?.applicationDidEnterBackground?(application);
        }
    } //F.E.
    
    open func applicationDidFinishLaunching(_ application: UIApplication) {
        //Calling Delegate Methods
        let enumerator:NSEnumerator = self._delegates.objectEnumerator();
        
        while let wTarget:Weak<GISTApplicationDelegate> = enumerator.nextObject() as? Weak<GISTApplicationDelegate> {
            wTarget.value?.applicationDidFinishLaunching?(application);
        }
    } //F.E.
    
} //CLS END
