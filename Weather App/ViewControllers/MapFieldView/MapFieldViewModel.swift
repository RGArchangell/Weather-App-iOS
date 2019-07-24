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

    private var modelCoordinator: MapFieldViewCoordinator
    private let dataProvider: DataProvider
    
    // MARK: - initialize
    
    init(modelCoordinator: MapFieldViewCoordinator) {
        self.dataProvider = DataProvider()
        self.modelCoordinator = modelCoordinator
    }
    
    // MARK: - func
    
    func getNameOfTheCity() -> String? {
        let name = dataProvider.getNameOfCity()
        return name
    }
    
    func getCoordinatesOfCity() -> String {
        let coords = dataProvider.getCoordsOfCity()
        return coords
    }
    
    func getStartLocation() -> CLLocation {
        let startLocation = dataProvider.getStartLocation()
        return startLocation
    }
    
    func getRegionRadius() -> CLLocationDistance {
        let radius = dataProvider.getStartRadius()
        return radius
    }
    
    func setNewPickedLocation(coordinate: CLLocationCoordinate2D, completion: @escaping (Bool) -> Void) {
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        dataProvider.setCurrentLocation(location: location)
        
        location.geocode { placemark, error in
            if (error as? CLError) != nil {
                completion(true)
                return
            } else if let placemark = placemark?.first {
                DispatchQueue.main.async {
                    self.dataProvider.setNewCity(placemark: placemark)
                    completion(false)
                    return
                }
            }
        }
    }
    
    func goToCityForecast() {
        let cityName = dataProvider.getNameOfCity()!
        modelCoordinator.goToCityScreen(name: cityName)
    }
    
}
