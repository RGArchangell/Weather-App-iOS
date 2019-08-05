//
//  CityWeatherViewController.swift
//  Weather App
//
//  Created by Archangel on 20/07/2019.
//  Copyright © 2019 Archangel. All rights reserved.
//

import UIKit
import Kingfisher

class CityWeatherViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var informationView: UIView!
    @IBOutlet private weak var cityName: UILabel!
    @IBOutlet private weak var temperature: UILabel!
    @IBOutlet private weak var backgroundImage: UIImageView!
    @IBOutlet private weak var weatherIcon: UIImageView!
    @IBOutlet private weak var weatherStatus: UILabel!
    @IBOutlet private weak var humidity: UILabel!
    @IBOutlet private weak var pressure: UILabel!
    @IBOutlet private weak var windSpeed: UILabel!
    
    // MARK: - Variables
    
    private let activityIndicator = UIActivityIndicatorView()
    
    private var viewModel: CityWeatherViewModel
    
    weak var delegate: CityWeatherForecastViewDelegate?
    
    // MARK: - Func
    
    private func displayWeatherInfo() {
        self.hideActivityIndicator(indicator: activityIndicator)
        
        cityName.text = viewModel.name
        temperature.text = viewModel.temperature
        weatherStatus.text = viewModel.weatherStatus
        humidity.text = viewModel.humidity
        pressure.text = viewModel.pressure
        windSpeed.text = viewModel.windSpeed
        backgroundImage.image = viewModel.backgroundImage
        
        let url = viewModel.getIconURL()
        weatherIcon.kf.setImage(with: url)
        informationView.isHidden = false
    }
    
    private func showError() {
        informationView.isHidden = true
        showAlert(title: "Error",
                  message: "Can't load city. Please, try again",
                  actionText: "Ok. I got it")
    }
    
    // MARK: - Initialization
    
    init(viewModel: CityWeatherViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "CityWeatherViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    // MARK: - Override func
    
    override func viewDidLoad() {
        viewModel.loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.delegate = self
        informationView.isHidden = true
        
        delegate?.cityForecastViewWillAppear()
        self.showActivityIndicator(indicator: activityIndicator)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.hideActivityIndicator(indicator: activityIndicator)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        delegate?.cityForecastViewDidDisappear()
    }
    
}

extension CityWeatherViewController: CityWeatherViewModelDelegate {
    func dataWasUpdated(result: Swift.Result<Int, Error>) {
        switch result {
        case .success:
            displayWeatherInfo()
        case .failure:
            showError()
        }
    }
    
}

protocol CityWeatherForecastViewDelegate: class {
    
    func cityForecastViewWillAppear()
    func cityForecastViewDidDisappear()
    
}
