//
//  MapFieldViewModel.swift
//  Weather App
//
//  Created by Archangel on 20/07/2019.
//  Copyright © 2019 Archangel. All rights reserved.
//

import Foundation
import MapKit

class MapFieldViewModel {
    
    // MARK: - Variables

    private let dataProvider: DataProvider
    private var pickedLocation: CLPlacemark?
    private var currentLocation: CLLocation
    private var pickedCity: String?
    private var regionRadius: CLLocationDistance = 10000
    
    private let geocoder = CLGeocoder()
    private let startLocation = CLLocation(latitude: 37.805778, longitude: -122.287344)
    
    var delegate: MapFieldViewModelDelegate?
    
    // MARK: - initialize
    
    init() {
        self.dataProvider = DataProvider()
        pickedLocation = nil
        pickedCity = nil
        currentLocation = startLocation
    }
    
    // MARK: - func
    
    func getNameOfTheCity() -> String? {
        return pickedCity
    }
    
    func setNewCity(placemark: CLPlacemark) {
        pickedCity = placemark.locality ?? nil
    }
    
    func setCurentLocation(location: CLLocation) {
        currentLocation = location
    }
    
    func setRegionRadius(radius: CLLocationDistance) {
        regionRadius = radius
    }
    
    func getCoordinatesOfCity() -> String {
        var longPart: String
        var latPart: String
        
        var latitude: Float
        var longitude: Float
        
        if Double(currentLocation.coordinate.latitude) < 0.0 {
            latPart = "S "
            latitude = Float(currentLocation.coordinate.latitude) * -1.0
        } else {
            latPart = "N "
            latitude = Float(currentLocation.coordinate.latitude)
        }
        
        if Double(currentLocation.coordinate.longitude) < 0.0 {
            longPart = "W"
            longitude = Float(currentLocation.coordinate.longitude) * -1.0
        } else {
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
    
    func setNewPickedLocation(coordinate: CLLocationCoordinate2D, completion: @escaping (Result<Int, Error>) -> Void) {
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        setCurentLocation(location: location)
        
        geocode(location: location) { placemark, error in
            if (error as? CLError) != nil {
                completion(.failure(error!))
                return
            } else if let placemark = placemark?.first {
                    self.setNewCity(placemark: placemark)
                    completion(.success(1))
                    return
            }
        }
    }
    
    func goToCityForecast() {
        guard let cityName = pickedCity else { return }
        delegate?.didRequestShowWeatherForCity(city: cityName)
    }
    
    func updateViewSettings() {
        delegate?.mapFieldViewWillAppear()
    }
    
}
