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
    
    private var cityForecast: CityModel?
    private let dataProvider: DataProvider?
    
    var name: String?
    var temperature: String?
    var weatherStatus: String?
    var humidity: String?
    var pressure: String?
    var windSpeed: String?
    var backgroundImage: UIImage?
    
    var delegate: CityWeatherForecastViewModelDelegate?
    
    // MARK: - Initialize
    
    init (city: CityModel?) {
        self.dataProvider = DataProvider()
        self.cityForecast = city
        
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
    
    func updateViewSettings() {
        delegate?.cityForecastViewWillAppear()
    }
    
}
