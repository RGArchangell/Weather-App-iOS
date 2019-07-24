//
//  AppDelegate.swift
//  Weather App
//
//  Created by Archangel on 18/07/2019.
//  Copyright © 2019 Archangel. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    lazy var rootViewController: UINavigationController = {
        return UINavigationController(rootViewController: UIViewController())
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let mapFieldCoordinator = MapFieldViewCoordinator(rootViewController: rootViewController)
        mapFieldCoordinator.start()
        
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
        
        return true
    }

}

