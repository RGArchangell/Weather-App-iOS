//
//  CLLocationExtensions.swift
//  Weather App
//
//  Created by Archangel on 22/07/2019.
//  Copyright © 2019 Archangel. All rights reserved.
//

import MapKit

extension CLLocation {
    
    func geocode(completion: @escaping (_ placemark: [CLPlacemark]?, _ error: Error?) -> Void)  {
        CLGeocoder().reverseGeocodeLocation(self, completionHandler: completion)
    }
    
}
