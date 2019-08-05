//
//  CityModelExtensions.swift
//  Weather App
//
//  Created by Archangel on 21/07/2019.
//  Copyright © 2019 Archangel. All rights reserved.
//

import UIKit

extension CityModel {
    
    func getBackgroundImage(for weather: String) -> UIImage {
        
        switch weather {
            
        case "Drizzle", "Rain":
            return #imageLiteral(resourceName: "rain")
        case "Snow", "Dust", "Sand", "Ash":
            return #imageLiteral(resourceName: "snow")
        case "Clear":
            return #imageLiteral(resourceName: "clearSky")
        case "Clouds":
            return #imageLiteral(resourceName: "brokenClouds")
        case "Mist", "Smoke", "Haze", "Fog":
            return #imageLiteral(resourceName: "mist")
        case "Squall", "Tornado":
            return #imageLiteral(resourceName: "thunderstorm")
        default:
            return #imageLiteral(resourceName: "clearSky")
            
        }
    }
    
}
