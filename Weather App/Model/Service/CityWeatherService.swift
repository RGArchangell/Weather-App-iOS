//
//  CityWeatherService.swift
//  Weather App
//
//  Created by Archangel on 23/07/2019.
//  Copyright © 2019 Archangel. All rights reserved.
//

import Foundation
import Alamofire

enum RequestResult<T> {
    case sucess(T)
    case failure(Error)
}

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
                        
                        do {
                            let decoder = JSONDecoder()
                            let decodedData = try decoder.decode(T.self, from: data)
                            completion(.sucess(decodedData))
                            
                        } catch let error {
                            completion(.failure(error))
                        }
                        
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
        }
    
    }
    
}
