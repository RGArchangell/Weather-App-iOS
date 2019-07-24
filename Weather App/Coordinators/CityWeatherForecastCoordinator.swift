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
    private let cityWeatherService: CityWeatherService
    
    init(rootViewController: UINavigationController,
         nameOfCity: String) {
        self.rootViewController = rootViewController
        self.nameOfCity = nameOfCity
        self.dataProvider = DataProvider()
        self.cityWeatherService = CityWeatherService()
    }
    
    override func start() {
        cityWeatherService.obtainCityData(cityName: nameOfCity, completion: loadScreen)
    }
    
    private func loadScreen(cityData: CityModel?) {
        let cityWeatherForecastViewController = CityWeatherForecastViewController()
        cityWeatherForecastViewController.viewModel = CityWeatherForecastViewModel(city: cityData, modelCoordinator: self)
        rootViewController.pushViewController(cityWeatherForecastViewController, animated: true)
    }
}
