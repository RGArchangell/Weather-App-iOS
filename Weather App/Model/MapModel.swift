//
//  MapModel.swift
//  Weather App
//
//  Created by Archangel on 23/07/2019.
//  Copyright © 2019 Archangel. All rights reserved.
//

import Foundation
import MapKit

class MapModel {
    
    private var pickedLocation: CLPlacemark?
    private var currentLocation: CLLocation
    private var pickedCity: String?
    private var regionRadius: CLLocationDistance = 10000

    private let geocoder = CLGeocoder()
    private let startLocation = CLLocation(latitude: 37.805778, longitude: -122.287344)
    
    func setNewCity(placemark: CLPlacemark) {
        pickedCity = placemark.locality ?? nil
    }
    
    func setCurentLocation(location: CLLocation) {
        currentLocation = location
    }
    
    func setRegionRadius(radius: CLLocationDistance) {
        regionRadius = radius
    }
    
    init() {
        pickedLocation = nil
        pickedCity = nil
        currentLocation = startLocation
    }
    
    func getCoordinatesOfCity() -> String {
        var longPart: String
        var latPart: String
        
        var latitude: Float
        var longitude: Float
        
        if Double(currentLocation.coordinate.latitude) < 0.0 {
            latPart = "S "
            latitude = Float(currentLocation.coordinate.latitude) * -1.0
        }
        else {
            latPart = "N "
            latitude = Float(currentLocation.coordinate.latitude)
        }
        
        if Double(currentLocation.coordinate.longitude) < 0.0 {
            longPart = "W"
            longitude = Float(currentLocation.coordinate.longitude) * -1.0
        }
        else {
            longPart = "E"
            longitude = Float(currentLocation.coordinate.longitude)
        }
        
        let resultStringCoord = latitude.convertToCoordinates() + latPart + longitude.convertToCoordinates() + longPart
        
        return resultStringCoord
    }
    
    func getNameOfCity() -> String? {
        return pickedCity
    }
    
    func getStartLocation() -> CLLocation {
        return startLocation
    }
    
    func getRegionRadius() -> CLLocationDistance {
        return regionRadius
    }
    
}
