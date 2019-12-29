//
//  AppDelegate.swift
//  CryptoCalculator
//
//  Created by Pavel B on 01/01/20.
//  Copyright © 2019 Pavel B. All rights reserved.
//

import UIKit
import Flutter
//import FlutterPluginRegistrant

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    lazy var flutterEngine = FlutterEngine(name: "flutter_engine")
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
        flutterEngine.run();
        GeneratedPluginRegistrant.register(with: self.flutterEngine);
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration
    {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

}

