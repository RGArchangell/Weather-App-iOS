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
    
    @IBOutlet private weak var informationView: UIView!
    @IBOutlet private weak var cityName: UILabel!
    @IBOutlet private weak var temperature: UILabel!
    @IBOutlet private weak var weatherStatus: UILabel!
    @IBOutlet private weak var humidity: UILabel!
    @IBOutlet private weak var windSpeed: UILabel!
    @IBOutlet private weak var pressure: UILabel!
    @IBOutlet private weak var weatherIcon: UIImageView!
    @IBOutlet private weak var backgroundImage: UIImageView!
    
    // MARK: - Variables
    
    private var viewModel: CityWeatherForecastViewModel
    
    // MARK: - Private func
    
    private func loadInformation() {
        guard viewModel.getCity() != nil else { showError(); return }
        displayWeatherInfo()
    }

    private func displayWeatherInfo() {
        cityName.text = viewModel.name
        temperature.text = viewModel.temperature
        weatherStatus.text = viewModel.weatherStatus
        humidity.text = viewModel.humidity
        pressure.text = viewModel.pressure
        windSpeed.text = viewModel.windSpeed
        backgroundImage.image = viewModel.backgroundImage
        
        let url = viewModel.getIconURL()
        weatherIcon.kf.setImage(with: url)
    }
    
    private func showError() {
        informationView.isHidden = true
        showAlert(title: "Error",
                  message: "Can't load city. Please, try again",
                  actionText: "Ok. I got it")
    }
    
    // MARK: - Initialization
    
    init(viewModel: CityWeatherForecastViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "CityWeatherForecastViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    // MARK: - Override func
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadInformation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.updateViewSettings()
    }
    
}
