//
//  MainCoordinator.swift
//  Weather App
//
//  Created by Archangel on 01/08/2019.
//  Copyright © 2019 Archangel. All rights reserved.
//

import Foundation
import UIKit

class MainCoordinator: Coordinator {
    var window: UIWindow?
    private var rootViewController: UINavigationController
    
    required init(window: UIWindow) {
        self.window = window
        let rootNavigationController = UINavigationController()
        
        window.rootViewController = rootNavigationController
        window.makeKeyAndVisible()
        
        self.rootViewController = rootNavigationController
    }

    override func start() {
        let childCoordinator = MapFieldViewCoordinator(rootViewController: rootViewController)
        self.addChildCoordinator(childCoordinator)
        childCoordinator.start()
    }
}
