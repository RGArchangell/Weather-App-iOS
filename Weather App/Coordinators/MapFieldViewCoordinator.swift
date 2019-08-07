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
    
    init(rootViewController: UINavigationController) {
        self.rootViewController = rootViewController
    }
    
    override func start() {
        let mapFieldViewModel = MapFieldViewModel()
        mapFieldViewModel.delegate = self
        let mapFieldViewController = MapFieldViewController(viewModel: mapFieldViewModel)
        mapFieldViewController.delegate = self
        
        rootViewController.setViewControllers([mapFieldViewController], animated: false)
    }
    
    func goToCityScreen(name: String) {
        let cityWeatherForecastCoordinator = CityWeatherForecastCoordinator(
            rootViewController: rootViewController,
            nameOfCity: name)
        
        addChildCoordinator(cityWeatherForecastCoordinator)
        cityWeatherForecastCoordinator.start()
    }
    
    private func setNavigationBarPreferences() {
        rootViewController.navigationBar.topItem?.title = "Map"
        rootViewController.setNavigationBarHidden(true, animated: false)
    }
    
    private func removeCoordinatorChildren(childCoordinator: Coordinator) {
        self.removeChildCoordinator(childCoordinator)
    }
    
}

extension MapFieldViewCoordinator: MapFieldViewModelDelegate {
    
    func didRequestShowWeatherForCity(city: String) {
        goToCityScreen(name: city)
    }
    
}

extension MapFieldViewCoordinator: MapFieldViewControllerDelegate {
    
    func viewWillAppear() {
         setNavigationBarPreferences()
    }
    
}

extension MapFieldViewCoordinator: CityWeatherForecastCoordinatorDelegate {
    
    func сoordinatorDidFinish(_ сoordinator: Coordinator) {
        removeChildCoordinator(сoordinator)
    }
    
}
