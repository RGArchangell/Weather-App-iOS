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
    var cityName: String
    var temperature: Int
    var weatherCondition: String
    var humidity: Int
    var pressure: Float
    var weatherIcon: UIImage?
    var addedImage: UIImage?
    
    init? (nameOfCity: String)
    {
        self.cityName = nameOfCity
        self.temperature = 0
        self.weatherCondition = ""
        self.humidity = 0
        self.pressure = 0.0
        self.weatherIcon = nil
        self.addedImage = nil
    }
}
