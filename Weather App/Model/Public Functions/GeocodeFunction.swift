//
//  GeocodeFunction.swift
//  Weather App
//
//  Created by Archangel on 30/07/2019.
//  Copyright © 2019 Archangel. All rights reserved.
//

import Foundation
import MapKit

struct Geocoder {
    static func geocode(location: CLLocation, completion: @escaping (Result<CLPlacemark?, Error>) -> Void) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            if (error as? CLError) != nil {
                guard let fail = error else { return }
                completion(.failure(fail))
                return
            } else if let placemark = placemarks?.first {
                completion(.success(placemark))
                return
            }
        }
    }
}
