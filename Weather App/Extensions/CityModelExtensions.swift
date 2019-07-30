//
//  CityModelExtensions.swift
//  Weather App
//
//  Created by Archangel on 21/07/2019.
//  Copyright © 2019 Archangel. All rights reserved.
//

import UIKit

extension CityModel {
    
    func getBackgroundImageForWeather(for weather: String) -> UIImage {
        
        switch weather {
            
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
