//
//  MapFieldViewModel.swift
//  Weather App
//
//  Created by Archangel on 20/07/2019.
//  Copyright © 2019 Archangel. All rights reserved.
//

import Foundation
import MapKit

protocol MapFieldViewModelDelegate: class {
    func didRequestShowWeatherForCity(city: String)
}

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
    
    // MARK: - Initialize
    
    init() {
        self.dataProvider = DataProvider()
        pickedLocation = nil
        pickedCity = nil
        currentLocation = startLocation
    }
    
    // MARK: - Func
    
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
    
    func setNewPickedLocation(coordinate: CLLocationCoordinate2D, completion: ((Result<Int, Error>) -> Void)?) {
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        self.location = location
        
        Geocoder.geocode(location: location) { result in
            switch result {
            case .success(let placemark):
                guard let placemark = placemark else { return }
                    
                self.setNewCity(placemark: placemark)
                completion?(.success(1))
                
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }
    
    func goToCityForecast() {
        guard let cityName = pickedCity else { return }
        delegate?.didRequestShowWeatherForCity(city: cityName)
    }
    
}

extension MapFieldViewModel: CityMenuViewDelegate {
    
    func didRequestInformationOfCity() {
        goToCityForecast()
    }
    
}
