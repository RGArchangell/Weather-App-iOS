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
    
    // MARK: - Computed properties
    
    var nameOfCity: String? {
        get { return pickedCity }
        set(newCity) { pickedCity = newCity }
    }
    
    var regionRad: CLLocationDistance {
        get { return regionRadius }
        set(newRadius) { regionRadius = newRadius }
    }
    
    var location: CLLocation {
        get { return currentLocation }
        set(newLocation) { currentLocation = newLocation }
    }
    
    // MARK: - Constants
    
    private let geocoder = CLGeocoder()
    let startLocation = CLLocation(latitude: 37.805778, longitude: -122.287344)
    
    weak var delegate: MapFieldViewModelDelegate?
    
    // MARK: - initialize
    
    init() {
        self.dataProvider = DataProvider()
        pickedLocation = nil
        pickedCity = nil
        currentLocation = startLocation
    }
    
    // MARK: - func
    
    func setNewCity(placemark: CLPlacemark) {
        let newCity = placemark.locality ?? nil
        nameOfCity = newCity
    }
    
    func getCoordinatesOfCity() -> String {
        let latitude = Float(currentLocation.coordinate.latitude)
        let longitude = Float(currentLocation.coordinate.longitude)
        
        let latitudeCoordinates = abs(latitude).convertToCoordinates()
        let longitudeCoordinates = abs(longitude).convertToCoordinates()
        
        switch (latitude < 0, longitude < 0) {
        case (true, true):
            return "\(latitudeCoordinates) S \(longitudeCoordinates) W"
        case (true, false):
            return "\(latitudeCoordinates) S \(longitudeCoordinates) E"
        case (false, true):
            return "\(latitudeCoordinates) N \(longitudeCoordinates) W"
        case (false, false):
            return "\(latitudeCoordinates) N \(longitudeCoordinates) E"
        }
    }
    
    func setNewPickedLocation(coordinate: CLLocationCoordinate2D, completion: @escaping (Result<Int, Error>) -> Void) {
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        self.location = location
        
        Geocoder.geocode(location: location) { placemark, error in
            if (error as? CLError) != nil {
                guard let fail = error else { return }
                completion(.failure(fail))
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
    
}

protocol MapFieldViewModelDelegate: class {
    
    func didRequestShowWeatherForCity(city: String)
    
}

extension MapFieldViewModel: CityMenuViewDelegate {
    
    func didRequestInformationOfCity() {
        goToCityForecast()
    }
    
}
