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
    
    private enum Constants {
        static let baseURL = "http://api.openweathermap.org/data/2.5/weather"
        static let error = NSError(domain: "CityWeatherService", code: 0, userInfo: nil)
    }
    
    func obtainCityData(cityName: String, completion: @escaping (RequestResult<CityModel>) -> Void) {
        
        guard let url = URL(string: Constants.baseURL) else { return }
        let parameters =  ["q": cityName,
                           "APPID": appId]
        
        loadData(url: url,
                 parameters: parameters,
                 completion: completion)
    }

    /*cityWeatherService.obtainCityData(cityName: nameOfCity) { [weak self] result in
     switch result {
     case .sucess(let city):
     self?.loadScreen(cityData: city)
     case .failure(let error):
     print("error while loading city data: \(error)")
     }
     }*/
    
    func loadData<T>(url: URL, parameters: [String: Any], completion: @escaping (RequestResult<T>) -> Void) where T: Decodable {
        
        DispatchQueue.global(qos: .userInitiated).async {
            Alamofire.request(
                url,
                method: .get,
                parameters: parameters,
                encoding: URLEncoding.default,
                headers: nil).responseData { response in
                    
                    switch response.result {
                    case .success(let data):
                        guard let cityData = decodeCityFromData(data: data) else { return }
                        guard let result = cityData as? T else { return }
                        completion(.sucess(result))
                        
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
        }
    
    }
    
}

enum RequestResult<T> {
    case sucess(T)
    case failure(Error)
}
