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
    
    @IBOutlet weak var mapViewMap: MKMapView!
    @IBOutlet weak var mapViewSearchBar: UISearchBar!
    @IBOutlet var mapTapGestureRecognizer: UITapGestureRecognizer!
    @IBOutlet weak var cityMenuView: UIView!
    @IBOutlet weak var nameOfTheCityInMenu: UILabel!
    @IBOutlet weak var coordinatesOfTheCityInMenu: UILabel!
    
    // MARK: - Variables
    
    private let activityIndicator = UIActivityIndicatorView()
    
    var viewModel: MapFieldViewModel!
    
    // MARK: - Private func
    
    private func centerMapOnLocation(location: CLLocation, regionRadius: CLLocationDistance) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapViewMap.setRegion(coordinateRegion, animated: true)
    }
    
    private func setStartViewPreferences() {
        cityMenuView.layer.cornerRadius = 8
        cityMenuView.clipsToBounds = true
        cityMenuView.isHidden = true
        
        activityIndicator.style = UIActivityIndicatorView.Style.whiteLarge
        activityIndicator.center = self.view.center
        activityIndicator.color = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        activityIndicator.hidesWhenStopped = true
    }
    
    private func checkResponse(failure: Bool) {
        if failure {
            let alertController = UIAlertController(title: "Error", message: "Can't load city. Please, try again", preferredStyle: .alert)
            let retryAction = UIAlertAction(title: "Ok. I got it", style: .default) { (action) -> Void in
                alertController.dismiss(animated: true, completion: nil)
            }
            
            alertController.addAction(retryAction)
            self.present(alertController, animated: true, completion: nil)
        }
        else
        {showCityMenu()}
    }
    
    private func showCityMenu() {
        let name = viewModel.getNameOfTheCity()
        let coords = viewModel.getCoordinatesOfCity()
        
        if name != nil {
            if cityMenuView.isHidden
            {cityMenuView.showWithAnimation()}
            nameOfTheCityInMenu.text = name
            coordinatesOfTheCityInMenu.text = coords
        }
        else {
            if !cityMenuView.isHidden
            {cityMenuView.hideWithAnimation()
            }
        }
    }
    
    private func showActivityIndicator() {
        activityIndicator.startAnimating()
        self.view.addSubview(activityIndicator)
    }
    
    private func hideActivityIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
    }
    
    private func setMapAtStartingLocation() {
        let startLocation = viewModel.getStartLocation()
        let startRadius = viewModel.getRegionRadius()
        centerMapOnLocation(location: startLocation, regionRadius: startRadius)
    }
    
    // MARK: - Override func
    
    override func viewDidLoad() {
        setMapAtStartingLocation()
        setStartViewPreferences()
        
        mapViewSearchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        activityIndicator.stopAnimating()
    }
    
    // MARK: - IBActions
    
    @IBAction func closeMenuButtonTapped(_ sender: UIButton) {
        cityMenuView.hideWithAnimation()
    }
    
    @IBAction func userTappedOnTheMap(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            let locationInView = sender.location(in: mapViewMap)
            let tappedCoordinate = mapViewMap.convert(locationInView , toCoordinateFrom: mapViewMap)
            
            self.view.endEditing(true)
            
            viewModel.setNewPickedLocation(coordinate: tappedCoordinate, completion: checkResponse)
            let locationPin = MapPin(coordinate: tappedCoordinate)
            mapViewMap.removeAnnotations(mapViewMap.annotations)
            mapViewMap.addAnnotation(locationPin)
        }
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
            if searchBar.text != "" {
                UIApplication.shared.beginIgnoringInteractionEvents()
                self.showActivityIndicator()
                
                let searchRequest = MKLocalSearch.Request()
                searchRequest.naturalLanguageQuery = searchBar.text
                
                let activeSearch = MKLocalSearch(request: searchRequest)
                
                activeSearch.start { (response, error) in
                    self.hideActivityIndicator()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    
                    if response == nil {
                        self.showMapAlert()
                    }
                    else {
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
    }
    
    private func showMapAlert() {
        let alertController = UIAlertController(title: "Error", message: "Can't find the place. Please, try another", preferredStyle: .alert)
        let retryAction = UIAlertAction(title: "Ok. I got it", style: .default) { (action) -> Void in
            alertController.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(retryAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}
