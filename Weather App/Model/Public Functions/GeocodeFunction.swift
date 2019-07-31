//
//  GeocodeFunction.swift
//  Weather App
//
//  Created by Archangel on 30/07/2019.
//  Copyright © 2019 Archangel. All rights reserved.
//

import Foundation
import MapKit

public func geocode(location: CLLocation, completion: @escaping (_ placemark: [CLPlacemark]?, _ error: Error?) -> Void)  {
    CLGeocoder().reverseGeocodeLocation(location, completionHandler: completion)
}
