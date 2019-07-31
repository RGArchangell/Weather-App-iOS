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
        cityWeatherService.obtainCityData(cityName: nameOfCity, completion: performData)
    }
    
    private func performData(data: Any?) {
        let city = decodeCityFromData(loadedData: data)
        loadScreen(cityData: city)
    }
    
    private func loadScreen(cityData: CityModel?) {
        let viewModel = CityWeatherForecastViewModel(city: cityData)
        viewModel.delegate = self
        let cityWeatherForecastViewController = CityWeatherForecastViewController(viewModel: viewModel)
        
        rootViewController.pushViewController(cityWeatherForecastViewController, animated: true)
    }
    
    private func setNavigationBarPreferences() {
        rootViewController.setNavigationBarHidden(false, animated: false)
        rootViewController.navigationBar.barStyle = .default
        rootViewController.navigationBar.isTranslucent = false
        rootViewController.navigationBar.shadowImage = UIImage()
    }
    
}

extension CityWeatherForecastCoordinator: CityWeatherForecastViewModelDelegate {
    
    func cityForecastViewWillAppear() {
        setNavigationBarPreferences()
    }
    
}
