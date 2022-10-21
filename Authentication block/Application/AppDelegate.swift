//
//  AppDelegate.swift
//  Authentication block
//
//  Created by Алексей Коваленко on 11.10.2022.
//

import UIKit
import FirebaseCore
import FBSDKCoreKit
import FBSDKLoginKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        print("Facebook.configure")
        let _ = ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        print("FirebaseApp.configure")
        FirebaseApp.configure()
        print("Appearance.configure")
        Appearance.configure()
        return true
    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return ApplicationDelegate.shared.application(app, open: url, options: options)
    }

    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
}

