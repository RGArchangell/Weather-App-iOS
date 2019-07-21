//
//  CityModel.swift
//  Weather App
//
//  Created by Archangel on 21/07/2019.
//  Copyright © 2019 Archangel. All rights reserved.
//

import Foundation
import UIKit

struct CityModel: Codable {
    var name: String
    var temperature: Float
    var weatherCondition: String
    var humidity: Float
    var pressure: Float
    var windSpeed: Float
    var weatherIconID: String
    var backgroundImage: UIImage?
    
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
    
    enum WeatherCodingKeys: String, CodingKey {
        case condition = "main"
        case icon = "icon"
    }
    
    enum WindCodingKeys: String, CodingKey {
        case speed = "speed"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.name = try container.decode(String.self, forKey: .name)
        
        let mainContainer = try container.nestedContainer(keyedBy: MainCodingKeys.self, forKey: .main)
        self.temperature = try mainContainer.decode(Float.self, forKey: .temperature)
        self.humidity = try mainContainer.decode(Float.self, forKey: .humidity)
        self.pressure = try mainContainer.decode(Float.self, forKey: .pressure)
        
        let weatherContainer = try container.nestedContainer(keyedBy: WeatherCodingKeys.self, forKey: .weather)
        self.weatherCondition = try weatherContainer.decode(String.self, forKey: .condition)
        self.weatherIconID = try weatherContainer.decode(String.self, forKey: .icon)
        
        let windContainer = try container.nestedContainer(keyedBy: WindCodingKeys.self, forKey: .wind)
        self.windSpeed = try windContainer.decode(Float.self, forKey: .speed)
        
        self.backgroundImage = nil
    }
    
    func encode(to encoder: Encoder) throws {
        
    }
}

extension CityModel {
    func getBackgroundImageForWeather(for weather: String) -> UIImage
    {
        switch weather
        {
        case "Drizzle":
            return #imageLiteral(resourceName: "rain")
        case "Rain":
            return #imageLiteral(resourceName: "rain")
        case "Snow":
            return #imageLiteral(resourceName: "snow")
        case "Clear":
            return #imageLiteral(resourceName: "clearSky")
        case "Clouds":
            return #imageLiteral(resourceName: "brokenClouds")
        case "Mist":
            return #imageLiteral(resourceName: "mist")
        case "Smoke":
            return #imageLiteral(resourceName: "mist")
        case "Haze":
            return #imageLiteral(resourceName: "mist")
        case "Dust":
            return #imageLiteral(resourceName: "snow")
        case "Fog":
            return #imageLiteral(resourceName: "mist")
        case "Sand":
            return #imageLiteral(resourceName: "snow")
        case "Ash":
            return #imageLiteral(resourceName: "snow")
        case "Squall":
            return #imageLiteral(resourceName: "thunderstorm")
        case "Tornado":
            return #imageLiteral(resourceName: "thunderstorm")
        default:
            return #imageLiteral(resourceName: "clearSky")
        }
    }
}
