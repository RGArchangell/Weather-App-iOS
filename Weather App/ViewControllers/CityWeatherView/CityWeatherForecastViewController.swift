//
//  CityWeatherForecastViewController.swift
//  Weather App
//
//  Created by Archangel on 20/07/2019.
//  Copyright © 2019 Archangel. All rights reserved.
//

import UIKit
import Kingfisher

class CityWeatherForecastViewController: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var informationView: UIView!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var weatherStatus: UILabel!
    @IBOutlet weak var humidity: UILabel!
    @IBOutlet weak var windSpeed: UILabel!
    @IBOutlet weak var pressure: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    // MARK: - Variables
    
    var viewModel: CityWeatherForecastViewModel!
    
    // MARK: - Private func
    
    private func loadInformation() {
        guard let city = viewModel.getCity() else {showError(); return}
        displayWeatherInfo(city: city)
    }

    private func displayWeatherInfo(city: CityModel) {
        cityName.text = city.name
        temperature.text = String(Int(city.temperature))
        weatherStatus.text = city.weather.first!.condition
        humidity.text = "\(city.humidity)%"
        pressure.text = "\(city.pressure) mm Hg"
        windSpeed.text = city.windDirection + " \(city.windSpeed) m/s"
        backgroundImage.image = city.backgroundImage!
        
        let url = viewModel.getIconURL()
        weatherIcon.kf.setImage(with: url)
    }
    
    private func showError() {
        informationView.isHidden = true
        
        let alertController = UIAlertController(title: "Error", message: "Can't load city. Please, try again", preferredStyle: .alert)
        let retryAction = UIAlertAction(title: "Ok. I got it", style: .default) { (action) -> Void in
            alertController.dismiss(animated: true, completion: nil)
            self.navigationController?.popViewController(animated: true)
        }
        
        alertController.addAction(retryAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Override func
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadInformation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.backItem?.title = "Map"
    }
    
}
