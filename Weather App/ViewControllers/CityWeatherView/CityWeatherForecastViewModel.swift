//
//  CityWeatherForecastViewModel.swift
//  Weather App
//
//  Created by Archangel on 20/07/2019.
//  Copyright © 2019 Archangel. All rights reserved.
//

import Foundation
import UIKit

class CityWeatherForecastViewModel {
    
    // MARK: - Variables
    
    weak var modelCoordinator: CityWeatherForecastCoordinator?
    private var cityForecast: CityModel?
    
    var name: String?
    var temperature: String?
    var weatherStatus: String?
    var humidity: String?
    var pressure: String?
    var windSpeed: String?
    var backgroundImage: UIImage?
    
    private let dataProvider: DataProvider?
    
    // MARK: - Initialize
    
    init (city: CityModel?, modelCoordinator: CityWeatherForecastCoordinator) {
        self.dataProvider = DataProvider()
        self.cityForecast = city
        self.modelCoordinator = modelCoordinator
        
        guard let city = city else { return }
        
        self.name = city.name
        self.temperature = String(Int(city.temperature))
        self.weatherStatus = city.weather.first!.condition
        self.humidity = "\(city.humidity)%"
        self.pressure = String(format: "%.2f", city.pressure) + "mm Hg"
        self.windSpeed = city.windDirection + " \(city.windSpeed) m/s"
        self.backgroundImage = city.backgroundImage!
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
