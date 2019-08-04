//
//  CityWeatherViewControllerExtensions.swift
//  Weather App
//
//  Created by Archangel on 04/08/2019.
//  Copyright © 2019 Archangel. All rights reserved.
//

import Foundation

extension CityWeatherViewController: CityWeatherViewModelDelegate {
    func dataWasUpdated(result: Result<Int, Error>) {
        checkData(result: result)
    }
    
}
