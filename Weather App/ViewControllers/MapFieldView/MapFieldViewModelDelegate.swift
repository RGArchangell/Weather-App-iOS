//
//  MapFieldViewModelDelegate.swift
//  Weather App
//
//  Created by Archangel on 31/07/2019.
//  Copyright © 2019 Archangel. All rights reserved.
//

import Foundation

protocol MapFieldViewModelDelegate: class {
    
    func didRequestShowWeatherForCity(city: String)
    
    func mapFieldViewWillAppear()
    
}
