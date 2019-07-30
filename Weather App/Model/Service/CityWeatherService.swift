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
    
    func obtainCityData(cityName: String, completion: @escaping (Any?) -> Void) {
        
        let url = URL(string: Constants.baseURL)!
        let parameters =  ["q" : cityName,
                          "APPID" : AppId]
        
        loadData(url: url, parameters: parameters, completion: completion)
    }
    
    func loadData(url: URL, parameters: Dictionary<String, Any>, completion: @escaping (Any?) -> Void) {
        
        DispatchQueue.global(qos: .userInitiated).async {
            Alamofire.request(
                url,
                method: .get,
                parameters: parameters,
                encoding: URLEncoding.default,
                headers: nil).responseData{ response in
                    
                    switch response.result {
                    case .success(let data):
                         completion(data)
                        
                    case .failure(let error):
                        completion(error)
                    }
            }
        }
    
    }
    
}
