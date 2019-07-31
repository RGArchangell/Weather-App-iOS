//
//  MapFieldViewController.swift
//  Weather App
//
//  Created by Archangel on 20/07/2019.
//  Copyright © 2019 Archangel. All rights reserved.
//

import UIKit
import MapKit

class MapFieldViewController: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet private weak var mapViewMap: MKMapView!
    @IBOutlet private weak var mapViewSearchBar: UISearchBar!
    @IBOutlet private var mapTapGestureRecognizer: UITapGestureRecognizer!
    @IBOutlet private weak var cityMenuView: UIView!
    @IBOutlet private weak var nameOfTheCityInMenu: UILabel!
    @IBOutlet private weak var coordinatesOfTheCityInMenu: UILabel!
    @IBOutlet private weak var mapFieldNavigationBar: UINavigationBar!
    
    // MARK: - Variables
    
    private let activityIndicator = UIActivityIndicatorView()
    
    private var viewModel: MapFieldViewModel
    
    // MARK: - Private func
    
    private func centerMapOnLocation(location: CLLocation, regionRadius: CLLocationDistance) {
        let coordinateRegion = MKCoordinateRegion (center: location.coordinate,
                                                  latitudinalMeters: regionRadius,
                                                  longitudinalMeters: regionRadius)
        mapViewMap.setRegion(coordinateRegion, animated: true)
    }
    
    private func setStartViewPreferences() {
        cityMenuView.layer.cornerRadius = 8
        cityMenuView.clipsToBounds = true
        cityMenuView.layer.masksToBounds = false
        cityMenuView.isHidden = true
        
        setSearchBarShadow()
        activityIndicator.stopAnimating()
        mapFieldNavigationBar.shadowImage = UIImage()
    }
    
    private func checkResponse(result: Result<Int, Error>) {
        switch result {
        case .failure:
            showAlert(title: "Error",
                      message: "Can't load city. Please, try again",
                      actionText: "Ok. I got it")
            
        case .success:
            showCityMenu()
        }
    }
    
    private func showCityMenu() {
        let name = viewModel.getNameOfTheCity()
        let coords = viewModel.getCoordinatesOfCity()
        
        if name != nil {
            if cityMenuView.isHidden {
                cityMenuView.showWithAnimation()
            }
            nameOfTheCityInMenu.text = name
            coordinatesOfTheCityInMenu.text = coords
            setCityMenuShadow()
        } else {
            if !cityMenuView.isHidden {
                cityMenuView.hideWithAnimation()
            }
        }
    }
    
    private func showActivityIndicator() {
        setActivityIndicator()
        activityIndicator.startAnimating()
    }
    
    private func hideActivityIndicator() {
        activityIndicator.stopAnimating()
    }
    
    private func setMapAtStartingLocation() {
        let startLocation = viewModel.getStartLocation()
        let startRadius = viewModel.getRegionRadius()
        centerMapOnLocation(location: startLocation, regionRadius: startRadius)
    }
    
    // MARK: - Initialization
    
    init(viewModel: MapFieldViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "MapFieldViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    // MARK: - Override func
    
    override func viewDidLoad() {
        setMapAtStartingLocation()
        
        mapViewSearchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setStartViewPreferences()
        viewModel.updateViewSettings()
    }
    
    // MARK: - IBActions
    
    @IBAction func closeMenuButtonTapped(_ sender: UIButton) {
        cityMenuView.hideWithAnimation()
    }
    
    @IBAction func userTappedOnTheMap(_ sender: UITapGestureRecognizer) {
        guard sender.state == .ended else { return }
        
        let locationInView = sender.location(in: mapViewMap)
        let tappedCoordinate = mapViewMap.convert(locationInView, toCoordinateFrom: mapViewMap)
        
        self.view.endEditing(true)
        
        viewModel.setNewPickedLocation(coordinate: tappedCoordinate, completion: checkResponse)
        let locationPin = MapPin(coordinate: tappedCoordinate)
        mapViewMap.removeAnnotations(mapViewMap.annotations)
        mapViewMap.addAnnotation(locationPin)
    }
    
    @IBAction func goToCityForecast(_ sender: UIButton) {
        showActivityIndicator()
        viewModel.goToCityForecast()
    }
    
}

// MARK: - Extension for search bar

extension MapFieldViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        
        DispatchQueue.main.async {
            guard searchBar.text != "" else { return }
                
            self.view.isUserInteractionEnabled = false
            self.showActivityIndicator()
                
            let searchRequest = MKLocalSearch.Request()
            searchRequest.naturalLanguageQuery = searchBar.text
                
            let activeSearch = MKLocalSearch(request: searchRequest)
                
            activeSearch.start { (response, error) in
                self.hideActivityIndicator()
                self.view.isUserInteractionEnabled = true
                    
                if response == nil {
                    self.showMapAlert()
                } else {
                    let annotations = self.mapViewMap.annotations
                    self.mapViewMap.removeAnnotations(annotations)
                    
                    let coordinates = response?.boundingRegion.center
                    
                    let mapPin = MapPin(coordinate: coordinates!)
                    self.mapViewMap.addAnnotation(mapPin)
                    
                    let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                    let region = MKCoordinateRegion(center: coordinates!, span: span)
                    self.mapViewMap.setRegion(region, animated: true)
                    
                    self.viewModel.setNewPickedLocation(coordinate: coordinates!, completion: self.checkResponse)
                }
            }
        }
    }
    
    private func showMapAlert() {
        showAlert(title: "Error",
                  message: "Can't find the place. Please, try another",
                  actionText: "Ok. I got it")
    }
    
}

// MARK: - Shadows and Indicator settings

extension MapFieldViewController {
    
    private func setCityMenuShadow() {
        cityMenuView.layer.shadowColor = UIColor.black.cgColor
        cityMenuView.layer.shadowOffset = .zero
        cityMenuView.layer.shadowOpacity = 0.5
        cityMenuView.layer.shadowRadius = 6.0
        cityMenuView.layer.shadowPath = UIBezierPath(rect: cityMenuView.bounds).cgPath
        cityMenuView.layer.shouldRasterize = true
        cityMenuView.layer.rasterizationScale = UIScreen.main.scale
    }
    
    private func setSearchBarShadow() {
        mapViewSearchBar.layer.shadowColor = UIColor.black.cgColor
        mapViewSearchBar.layer.shadowOffset = .zero
        mapViewSearchBar.layer.shadowOpacity = 0.6
        mapViewSearchBar.layer.shadowRadius = 5.0
        
        let rectangle = CGRect(x: 0,
                               y: mapViewSearchBar.frame.height,
                               width: self.view.frame.width,
                               height: 1)
        
        mapViewSearchBar.layer.shadowPath = UIBezierPath(rect: rectangle).cgPath
    }
    
    private func setActivityIndicator() {
        activityIndicator.style = UIActivityIndicatorView.Style.whiteLarge
        activityIndicator.center = self.view.center
        activityIndicator.color = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        activityIndicator.hidesWhenStopped = true
        self.view.addSubview(activityIndicator)
    }
    
}
