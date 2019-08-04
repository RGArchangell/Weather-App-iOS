//
//  CityModel.swift
//  Weather App
//
//  Created by Archangel on 21/07/2019.
//  Copyright © 2019 Archangel. All rights reserved.
//

import Foundation
import UIKit

struct CityModel {
    
    var name: String
    var temperature: Float
    var weather: [WeatherModel]
    var humidity: Float
    var pressure: Float
    var windSpeed: Float
    var windDegrees: Float
    var windDirection: String
    var backgroundImage: UIImage?
    
    init() {
        self.name = ""
        self.temperature = 0.0
        self.weather = []
        self.humidity = 0.0
        self.pressure = 0.0
        self.windSpeed = 0.0
        self.windDegrees = 0.0
        self.windDirection = ""
        self.backgroundImage = nil
    }

    private mutating func updateImage() {
        guard let condition = weather.first?.condition else { return }
        backgroundImage = getBackgroundImage(for: condition)
    }
    
    private mutating func setWindDirection() {
        windDirection = windDegrees.convertToDirection()
    }
    
    private mutating func convertTempToCelcius() {
        temperature -= 273.15
    }
    
    private mutating func convertPressureToMmHg() {
        pressure = pressure.convertToMmHg()
    }
}

extension CityModel: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case weather
        case main
        case wind
        case name
    }
    
    enum MainCodingKeys: String, CodingKey {
        case temperature = "temp"
        case humidity = "humidity"
        case pressure = "pressure"
    }
    
    enum WindCodingKeys: String, CodingKey {
        case speed = "speed"
        case direction = "deg"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.name = try container.decode(String.self, forKey: .name)
        
        let mainContainer = try container.nestedContainer(keyedBy: MainCodingKeys.self, forKey: .main)
        self.temperature = try mainContainer.decode(Float.self, forKey: .temperature)
        self.humidity = try mainContainer.decode(Float.self, forKey: .humidity)
        self.pressure = try mainContainer.decode(Float.self, forKey: .pressure)
        
        self.weather = try container.decode([WeatherModel].self, forKey: .weather)
        
        let windContainer = try container.nestedContainer(keyedBy: WindCodingKeys.self, forKey: .wind)
        self.windSpeed = try windContainer.decode(Float.self, forKey: .speed)
        self.windDegrees = try windContainer.decode(Float.self, forKey: .direction)
        
        self.backgroundImage = nil
        self.windDirection = ""
        
        self.updateImage()
        self.setWindDirection()
        self.convertTempToCelcius()
        self.convertPressureToMmHg()
    }
    
}
