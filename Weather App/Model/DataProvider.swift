//
//  DataProvider.swift
//  Weather App
//
//  Created by Archangel on 23/07/2019.
//  Copyright © 2019 Archangel. All rights reserved.
//

import Foundation
import MapKit

class DataProvider {
    
    private var cityForecast: CityModel?
    init() {
        cityForecast = CityModel()
    }
    
    private func saveCityForecast(cityData: CityModel?) {
        cityForecast = cityData
    }
    
    func getCityData() -> CityModel? {
        return cityForecast
    }
    
}
