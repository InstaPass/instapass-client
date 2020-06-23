//
//  AppDelegate.swift
//  InstaPass
//
//  Created by 法好 on 2020/4/24.
//  Copyright © 2020 yuetsin. All rights reserved.
//

import UIKit
import WatchConnectivity

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, WCSessionDelegate {
    
    static var defaultPage: Page?
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        NSLog("iOS: session init")
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        NSLog("iOS: session inactive")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        NSLog("iOS: session deactivate")
    }
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
        
        sendJwtToken(token: UserPrefInitializer.jwtToken)
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func sendJwtToken(token: String) {
        let session = WCSession.default
        session.sendMessage(["jwtToken" : token], replyHandler: { _ in
            NSLog("jwt token sent to Apple Watch")
        }, errorHandler: { _ in
            NSLog("failed to send jwt token to Apple Watch")
        })
    }
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        NSLog(shortcutItem.type)
        switch shortcutItem.type {
        case "qrcode":
            AppDelegate.defaultPage = .qrcode
            break
        case "history":
            AppDelegate.defaultPage = .history
            break
        case "person":
            AppDelegate.defaultPage = .person
            break
        default:
            break
        }
        
        completionHandler(true)
    }
}
