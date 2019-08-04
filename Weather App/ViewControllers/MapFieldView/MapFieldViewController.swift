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
    @IBOutlet private weak var mapFieldNavigationBar: UINavigationBar!
    
    // MARK: - Variables
    
    private let activityIndicator = UIActivityIndicatorView()
    private var viewModel: MapFieldViewModel
    private var menu: CityMenuView
    
    weak var delegate: MapFieldViewDelegate?
    
    // MARK: - Private func
    
    private func centerMapOnLocation(location: CLLocation, regionRadius: CLLocationDistance) {
        let coordinateRegion = MKCoordinateRegion (center: location.coordinate,
                                                   latitudinalMeters: regionRadius,
                                                   longitudinalMeters: regionRadius)
        mapViewMap.setRegion(coordinateRegion, animated: true)
    }
    
    private func setStartViewPreferences() {
        setSearchBarShadow()
        setMenuPreferences()
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
        if menu.isHidden {
            setMenuFrame()
            menu.show(with: viewModel)
        } else {
            menu.updateInfo(with: viewModel)
        }
    }
    
    private func setMapAtStartingLocation() {
        let startLocation = viewModel.startLocation
        let startRadius = viewModel.regionRad
        centerMapOnLocation(location: startLocation, regionRadius: startRadius)
    }
    
    private func updateMap(coordinates: CLLocationCoordinate2D) {
        let mapPin = MapPin(coordinate: coordinates)
        self.mapViewMap.addAnnotation(mapPin)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: coordinates, span: span)
        self.mapViewMap.setRegion(region, animated: true)
    }
    
    // MARK: - Initialization
    
    init(viewModel: MapFieldViewModel) {
        self.viewModel = viewModel
        self.menu = CityMenuView()
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
        delegate?.viewWillAppear()
    }
    
    // MARK: - IBActions
    
    @IBAction private func userTappedOnTheMap(_ sender: UITapGestureRecognizer) {
        guard sender.state == .ended else { return }
        
        let locationInView = sender.location(in: mapViewMap)
        let tappedCoordinate = mapViewMap.convert(locationInView, toCoordinateFrom: mapViewMap)
        
        self.view.endEditing(true)
        
        viewModel.setNewPickedLocation(coordinate: tappedCoordinate, completion: checkResponse)
        let locationPin = MapPin(coordinate: tappedCoordinate)
        mapViewMap.removeAnnotations(mapViewMap.annotations)
        mapViewMap.addAnnotation(locationPin)
    }
    
}

// MARK: - Extension for search bar

extension MapFieldViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        
        DispatchQueue.main.async {
            guard !searchBar.text.isEmptyOrNil else { return }
                
            self.view.isUserInteractionEnabled = false
            self.showActivityIndicator(indicator: self.activityIndicator)
                
            let searchRequest = MKLocalSearch.Request()
            searchRequest.naturalLanguageQuery = searchBar.text

            let activeSearch = MKLocalSearch(request: searchRequest)
                
            activeSearch.start { response, _ in
                self.hideActivityIndicator(indicator: self.activityIndicator)
                self.view.isUserInteractionEnabled = true
                
                if response == nil {
                    self.showMapAlert()
                } else {
                    let annotations = self.mapViewMap.annotations
                    self.mapViewMap.removeAnnotations(annotations)
                    
                    guard let coordinates = response?.boundingRegion.center else { return }
                    
                    self.viewModel.setNewPickedLocation(coordinate: coordinates, completion: self.checkResponse)
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
    
    private func setMenuFrame() {
        menu.frame = CGRect(x: 16,
                            y: view.bounds.height + 50,
                            width: view.bounds.width - 32,
                            height: 154)
    }
    
    private func setMenuShadow() {
        menu.layer.shadowColor = UIColor.black.cgColor
        menu.layer.shadowOffset = .zero
        menu.layer.shadowOpacity = 0.5
        menu.layer.shadowRadius = 6.0
        menu.layer.shadowPath = UIBezierPath(rect: menu.bounds).cgPath
        menu.layer.shouldRasterize = true
        menu.layer.rasterizationScale = UIScreen.main.scale
    }
    
    private func setMenuPreferences() {
        setMenuFrame()
        setMenuShadow()
        self.view.addSubview(menu)
        menu.delegate = viewModel
        menu.isHidden = true
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
    
}

protocol MapFieldViewDelegate: class {
    func viewWillAppear()
}
