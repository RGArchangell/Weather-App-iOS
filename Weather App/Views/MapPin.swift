//
//  MapPin.swift
//  Weather App
//
//  Created by Archangel on 22/07/2019.
//  Copyright © 2019 Archangel. All rights reserved.
//

import Foundation
import MapKit

class MapPin: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D

    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
    
}
