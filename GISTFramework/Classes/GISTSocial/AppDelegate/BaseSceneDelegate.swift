//
//  BaseSceneDelegate.swift
//  GISTFramework
//
//  Created by Shoaib Mac Book Pro on 11/12/20.
//  Copyright © 2020 Shoaib Mac Book Pro. All rights reserved.
//

import UIKit

open class BaseSceneDelegate: UIResponder, UIWindowSceneDelegate {

    public var window: UIWindow?

    open func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    open func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    open func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        
        if GIST_CONFIG.resetBadgeCount {
            //Badge count to zero
            UIApplication.shared.applicationIconBadgeNumber = 0;
        }
        
        if (HTTPServiceManager.sharedInstance.microService) {
            GISTMicroAuth<ModelUser>.refreshAccessToken { (success) in
                GISTApplication.sharedInstance.applicationDidBecomeActive(UIApplication.shared);
                SyncEngine.syncData();
            }
        } else {
            GISTApplication.sharedInstance.applicationDidBecomeActive(UIApplication.shared);
            SyncEngine.syncData();
        }
    }

    open func sceneWillResignActive(_ scene: UIScene) {
        GISTApplication.sharedInstance.applicationWillResignActive(UIApplication.shared);
    }

    open func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
        GISTApplication.sharedInstance.applicationWillEnterForeground(UIApplication.shared);
    }

    open func sceneDidEnterBackground(_ scene: UIScene) {
        DATA_MANAGER.saveContext();
        
        GISTApplication.sharedInstance.applicationDidEnterBackground(UIApplication.shared);
        //Resting App if the language is changed or has update in syncEngine data file
        
        if SyncEngine.hasSyncDataUpdated {
            exit(0);
        }
    }

}

