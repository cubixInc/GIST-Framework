//
//  GISTApplication.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 07/09/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit

@objc public protocol GISTApplicationDelegate {
    optional func applicationWillTerminate(application: UIApplication);
    optional func applicationDidBecomeActive(application: UIApplication);
    optional func applicationWillResignActive(application: UIApplication);
    optional func applicationDidEnterBackground(application: UIApplication);
    optional func applicationDidFinishLaunching(application: UIApplication)
} //F.E.

public class GISTApplication: NSObject, UIApplicationDelegate {
    public static var sharedInstance:GISTApplication = GISTApplication();
    
    public var delegate:GISTApplicationDelegate? {
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
    
    private var _delegates:NSHashTable = NSHashTable();
    
    private override init() {
        super.init();
    } //F.E.
    
    //MARK: - Delegate Handling
    public func registerDelegate(target:GISTApplicationDelegate) {
        if self.weakDelegateForTarget(target) == nil {
            //Adding if not added
            _delegates.addObject(Weak<GISTApplicationDelegate>(value: target))
        }
    } //F.E.
    
    func unregisterDelegate(target:GISTApplicationDelegate) {
        if let wTarget:Weak<GISTApplicationDelegate> = self.weakDelegateForTarget(target) {
            _delegates.removeObject(wTarget);
        }
    } //F.E.
    
    private func weakDelegateForTarget(target:GISTApplicationDelegate) -> Weak<GISTApplicationDelegate>?{
        let enumerator:NSEnumerator = _delegates.objectEnumerator();
        
        while let wTarget:Weak<GISTApplicationDelegate> = enumerator.nextObject() as? Weak<GISTApplicationDelegate> {
            if (wTarget.value == nil) {
                //Removing if lost target already
                _delegates.removeObject(wTarget);
            } else if ((target as AnyObject).isEqual(wTarget.value)) {
                return wTarget;
            }
        }
        //--
        return nil;
    } //F.E.
    
    //MARK: - Application Delegate Methods calling
    public func applicationWillTerminate(application: UIApplication) {
        //Calling Delegate Methods
        let enumerator:NSEnumerator = self._delegates.objectEnumerator();
        
        while let wTarget:Weak<GISTApplicationDelegate> = enumerator.nextObject() as? Weak<GISTApplicationDelegate> {
            wTarget.value?.applicationWillTerminate?(application);
        }
    } //F.E.
    
    public func applicationDidBecomeActive(application: UIApplication) {
        //Calling Delegate Methods
        let enumerator:NSEnumerator = self._delegates.objectEnumerator();
        
        while let wTarget:Weak<GISTApplicationDelegate> = enumerator.nextObject() as? Weak<GISTApplicationDelegate> {
            wTarget.value?.applicationDidBecomeActive?(application);
        }
    } //F.E.
    
    public func applicationWillResignActive(application: UIApplication) {
        //Calling Delegate Methods
        let enumerator:NSEnumerator = self._delegates.objectEnumerator();
        
        while let wTarget:Weak<GISTApplicationDelegate> = enumerator.nextObject() as? Weak<GISTApplicationDelegate> {
            wTarget.value?.applicationWillResignActive?(application);
        }
    } //F.E.
    
    public func applicationDidEnterBackground(application: UIApplication) {
        //Calling Delegate Methods
        let enumerator:NSEnumerator = self._delegates.objectEnumerator();
        
        while let wTarget:Weak<GISTApplicationDelegate> = enumerator.nextObject() as? Weak<GISTApplicationDelegate> {
            wTarget.value?.applicationDidEnterBackground?(application);
        }
    } //F.E.
    
    public func applicationDidFinishLaunching(application: UIApplication) {
        //Calling Delegate Methods
        let enumerator:NSEnumerator = self._delegates.objectEnumerator();
        
        while let wTarget:Weak<GISTApplicationDelegate> = enumerator.nextObject() as? Weak<GISTApplicationDelegate> {
            wTarget.value?.applicationDidFinishLaunching?(application);
        }
    } //F.E.
    
} //CLS END
