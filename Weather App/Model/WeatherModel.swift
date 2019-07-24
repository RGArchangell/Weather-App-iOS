//
//  WeatherModel.swift
//  Weather App
//
//  Created by Archangel on 24/07/2019.
//  Copyright © 2019 Archangel. All rights reserved.
//

import Foundation

struct WeatherModel {
    var condition: String?
    var weatherIcon: String
    
    init() {
        self.condition = nil
        self.weatherIcon = ""
    }
}

extension WeatherModel: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case condition = "main"
        case icon = "icon"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.condition = try container.decode(String.self, forKey: .condition)
        self.weatherIcon = try container.decode(String.self, forKey: .icon)
    }
}
