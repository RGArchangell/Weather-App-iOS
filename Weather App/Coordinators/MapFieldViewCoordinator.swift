//
//  MapFieldViewCoordinator.swift
//  Weather App
//
//  Created by Archangel on 21/07/2019.
//  Copyright © 2019 Archangel. All rights reserved.
//

import Foundation
import UIKit

class MapFieldViewCoordinator: Coordinator {
    
    let rootViewController: UINavigationController
    lazy var dataProvider = DataProvider()
    
    lazy var mapFieldViewModel: MapFieldViewModel! = {
        let viewModel = MapFieldViewModel(modelCoordinator: self)
        return viewModel
    }()
    
    init(rootViewController: UINavigationController) {
        self.rootViewController = rootViewController
    }
    
    override func start() {
        let mapFieldViewController = MapFieldViewController()
        mapFieldViewController.viewModel = mapFieldViewModel
        rootViewController.setViewControllers([mapFieldViewController], animated: false)
    }
    
    func goToCityScreen(name: String) {
        let cityWeatherForecastCoordinator = CityWeatherForecastCoordinator(rootViewController: rootViewController, nameOfCity: name)
        
        addChildCoordinator(cityWeatherForecastCoordinator)
        cityWeatherForecastCoordinator.start()
    }
}
