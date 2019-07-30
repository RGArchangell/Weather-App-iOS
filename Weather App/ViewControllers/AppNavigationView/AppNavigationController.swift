//
//  AppNavigationController.swift
//  Weather App
//
//  Created by Archangel on 30/07/2019.
//  Copyright © 2019 Archangel. All rights reserved.
//

import UIKit

class AppNavigationController: UINavigationController {

    func setBarTitle(title: String) {
        self.navigationBar.topItem?.title = title
    }
    
}
