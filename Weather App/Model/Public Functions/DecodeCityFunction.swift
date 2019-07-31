//
//  DecodeCityFunction.swift
//  Weather App
//
//  Created by Archangel on 30/07/2019.
//  Copyright © 2019 Archangel. All rights reserved.
//

import Foundation

func decodeCityFromData(loadedData: Any?) -> CityModel? {
    
    guard let data = loadedData as? Data else {return nil}
    
    do {
        let decoder = JSONDecoder()
        let cityData = try decoder.decode(CityModel.self, from: data)
        return cityData
        
    } catch _ {
        return nil
    }
}
