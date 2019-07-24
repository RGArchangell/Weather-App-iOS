//
//  CityWeatherService.swift
//  Weather App
//
//  Created by Archangel on 23/07/2019.
//  Copyright © 2019 Archangel. All rights reserved.
//

import Foundation
import Alamofire

class CityWeatherService {
    
    private enum Constants
    {
        static let baseURL = "http://api.openweathermap.org/data/2.5/weather"
        static let error = NSError(domain: "CityWeatherService", code: 0, userInfo: nil)
    }
    
    func obtainCityData(cityName: String, completion: @escaping (CityModel?) -> Void)
    {
        let url = URL(string: Constants.baseURL)!
        let parameters = ["q" : cityName,
                          "APPID" : AppId]
        
        DispatchQueue.main.async {
            Alamofire.request(
                url,
                method: .get,
                parameters: parameters,
                encoding: URLEncoding.default,
                headers: nil).responseData{ response in
                    
                    guard let data = response.data else { completion(nil); return }

                    do {
                        let decoder = JSONDecoder()
                        let cityData = try decoder.decode(CityModel.self, from: data)
                        completion(cityData)
                        
                    } catch let error {
                        print(error)
                        completion(nil)
                        return
                    }
            }
        }
    }
}
