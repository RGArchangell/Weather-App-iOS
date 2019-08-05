//
//  CityWeatherForecastCoordinator.swift
//  Weather App
//
//  Created by Archangel on 21/07/2019.
//  Copyright © 2019 Archangel. All rights reserved.
//

import UIKit

class CityWeatherForecastCoordinator: Coordinator {
    
    private let rootViewController: UINavigationController
    private let nameOfCity: String
    private let dataProvider: DataProvider
    
    weak var delegate: CityWeatherForecastCoordinatorDelegate?
    
    init(rootViewController: UINavigationController,
         nameOfCity: String) {
        self.rootViewController = rootViewController
        self.nameOfCity = nameOfCity
        self.dataProvider = DataProvider()
    }
    
    override func start() {
        loadScreen()
    }
    
    private func loadScreen() {
        let viewModel = CityWeatherViewModel(cityName: nameOfCity)
        let cityWeatherViewController = CityWeatherViewController(viewModel: viewModel)
        cityWeatherViewController.delegate = self
        
        rootViewController.pushViewController(cityWeatherViewController, animated: true)
    }
    
    private func setNavigationBarPreferences() {
        rootViewController.setNavigationBarHidden(false, animated: false)
        rootViewController.navigationBar.barStyle = .default
        rootViewController.navigationBar.isTranslucent = false
        rootViewController.navigationBar.shadowImage = UIImage()
    }
    
    private func viewDidDisappear() {
        delegate?.removeCoordinator(childCoordinator: self)
    }
    
}

extension CityWeatherForecastCoordinator: CityWeatherForecastViewDelegate {
    
    func cityForecastViewWillAppear() {
        setNavigationBarPreferences()
    }
    
    func cityForecastViewDidDisappear() {
        viewDidDisappear()
    }
    
}

protocol CityWeatherForecastCoordinatorDelegate: class {
    
    func removeCoordinator(childCoordinator: Coordinator)
    
}
