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
    private var mapData: MapModel
    
    init() {
        cityForecast = CityModel()
        mapData = MapModel()
    }
    
    private func saveCityForecast(cityData: CityModel?) {
        cityForecast = cityData
    }
    
    func setRegionRadius(radius: CLLocationDistance) {
        mapData.setRegionRadius(radius: radius)
    }
    
    func setNewCity(placemark: CLPlacemark) {
        mapData.setNewCity(placemark: placemark)
    }
    
    func setCurrentLocation(location: CLLocation) {
        mapData.setCurentLocation(location: location)
    }
    
    func getCoordsOfCity() -> String {
        let coords = mapData.getCoordinatesOfCity()
        return coords
    }
    
    func getNameOfCity() -> String? {
        let name = mapData.getNameOfCity()
        return name
    }
    
    func getStartLocation() -> CLLocation {
        let location = mapData.getStartLocation()
        return location
    }
    
    func getStartRadius() -> CLLocationDistance {
        let radius = mapData.getRegionRadius()
        return radius
    }
    
    func getCityData() -> CityModel? {
        return cityForecast
    }
    
    
}
