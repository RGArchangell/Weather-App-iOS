//
//  CityWeatherForecastViewModel.swift
//  Weather App
//
//  Created by Archangel on 20/07/2019.
//  Copyright © 2019 Archangel. All rights reserved.
//

import Foundation

class CityWeatherForecastViewModel {
    
    // MARK: - Variables
    
    weak var modelCoordinator: CityWeatherForecastCoordinator?
    private var cityForecast: CityModel?
    
    private let dataProvider: DataProvider?
    
    // MARK: - Initialize
    
    init (city: CityModel?, modelCoordinator: CityWeatherForecastCoordinator) {
        self.dataProvider = DataProvider()
        self.cityForecast = city
        self.modelCoordinator = modelCoordinator
    }
    
    // MARK: - func
    
    func getCity() -> CityModel? {
        return cityForecast
    }
    
    func getIconURL() -> URL {
        let urlString = "http://openweathermap.org/img/wn/" + cityForecast!.weather.first!.weatherIcon + "@2x.png"
        let url = URL(string: urlString)!
        
        return url
    }
}
