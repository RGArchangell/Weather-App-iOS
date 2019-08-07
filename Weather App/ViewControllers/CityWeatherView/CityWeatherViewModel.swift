//
//  CityWeatherForecastViewModel.swift
//  Weather App
//
//  Created by Archangel on 20/07/2019.
//  Copyright © 2019 Archangel. All rights reserved.
//

import Foundation
import UIKit

protocol CityWeatherViewModelDelegate: class {
    func dataWasUpdated(result: Result<Int, Error>)
}

class CityWeatherViewModel {
    
    // MARK: - Variables
    
    private let dataProvider: DataProvider?
    private let cityWeatherService: CityWeatherService
    
    var name: String?
    var temperature: String?
    var weatherStatus: String?
    var humidity: String?
    var pressure: String?
    var windSpeed: String?
    var iconID: String?
    var backgroundImage: UIImage?
    
    weak var delegate: CityWeatherViewModelDelegate?
    
    // MARK: - Initialize
    
    init(cityName: String) {
        self.dataProvider = DataProvider()
        self.cityWeatherService = CityWeatherService()
        
        self.name = cityName
        self.temperature = nil
        self.weatherStatus = nil
        self.humidity = nil
        self.pressure = nil
        self.windSpeed = nil
        self.iconID = nil
        self.backgroundImage = nil
    }
    
    // MARK: - Private func
    
    private func perfomData(result: RequestResult<CityModel>) {
        switch result {
        case .sucess(let city):
            guard
                let weatherStatus = city.weather.first?.condition,
                let backgroundImage = city.backgroundImage,
                let icon = city.weather.first?.weatherIcon
                else { return }
            
            self.name = city.name
            self.temperature = String(Int(city.temperature))
            self.weatherStatus = weatherStatus
            self.humidity = "\(city.humidity)%"
            self.pressure = String(format: "%.2f", city.pressure) + "mm Hg"
            self.windSpeed = city.windDirection + " \(city.windSpeed) m/s"
            self.iconID = icon
            self.backgroundImage = backgroundImage
            
            delegate?.dataWasUpdated(result: .success(1))
            
        case .failure(let error):
            delegate?.dataWasUpdated(result: .failure(error))
        }
    }
    
    // MARK: - Func
    
    func loadData() {
        guard let name = name else { return }
        cityWeatherService.obtainCityData(cityName: name,
                                          completion: perfomData)
    }
    
    func getIconURL() -> URL? {
        
        guard let iconID = iconID else { return nil }
        let urlString = "http://openweathermap.org/img/wn/" + iconID + "@2x.png"
        guard let url = URL(string: urlString) else { return nil }
        
        return url
    }
    
}
