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
    
    @IBOutlet private weak var mapView: MapFieldView!
    @IBOutlet private weak var mapViewSearchBar: UISearchBar!
    @IBOutlet private weak var mapFieldNavigationBar: UINavigationBar!
    
    // MARK: - Variables
    
    private let activityIndicator = UIActivityIndicatorView()
    
    private var viewModel: MapFieldViewModel
    private var menu: CityMenuView
    private var workItemForSearch: DispatchWorkItem?
    
    weak var delegate: MapFieldViewControllerDelegate?
    
    // MARK: - Private func
    
    private func setStartViewPreferences() {
        setSearchBarShadow()
        setMenuPreferences()
        mapFieldNavigationBar.shadowImage = UIImage()
        mapView.delegate = self
    }
    
    private func showCityMenu() {
        if menu.isHidden {
            setMenuFrame()
            menu.show(with: viewModel)
        } else {
            menu.updateInfo(with: viewModel)
        }
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
        mapView.setMapAtStartingLocation(viewModel: viewModel)
        mapViewSearchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setStartViewPreferences()
        delegate?.viewWillAppear()
    }

}

// MARK: - Extension for search bar

extension MapFieldViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        
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
                guard let coordinates = response?.boundingRegion.center else { return }
                
                self.viewModel.setNewPickedLocation(coordinate: coordinates) { result in
                    switch result {
                    case .failure:
                        self.showAlert(title: "Error",
                                       message: "Can't load city. Please, try again",
                                       actionText: "Ok. I got it")
                        
                    case .success:
                        self.showCityMenu()
                    }
                }
                
                self.mapView.updateMap(coordinates: coordinates)
            }
        }
    }
    
    private func showMapAlert() {
        showAlert(title: "Error",
                  message: "Can't find the place. Please, try another",
                  actionText: "Ok. I got it")
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.workItemForSearch?.cancel()
        
        guard let text = searchBar.text else { return }
        
        let workItem = DispatchWorkItem { [weak self] in
            self?.performSearch(text)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: workItem)
        self.workItemForSearch = workItem
        
    }
    
    func performSearch(_ text: String) {
        mapViewSearchBar.isLoading = true
        
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = mapViewSearchBar.text
        
        let activeSearch = MKLocalSearch(request: searchRequest)
        
        activeSearch.start { response, _ in
            self.mapViewSearchBar.isLoading = false
            
            guard let coordinates = response?.boundingRegion.center else { return }
            
            self.viewModel.setNewPickedLocation(coordinate: coordinates) { _ in
                return
            }
        }
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

extension MapFieldViewController: MapFieldViewDelegate {
    
    func userTappedOnMap(at coordinate: CLLocationCoordinate2D) {
        self.view.endEditing(true)
        viewModel.setNewPickedLocation(coordinate: coordinate) { result in
            switch result {
            case .failure:
                self.showAlert(title: "Error",
                               message: "Can't load city. Please, try again",
                               actionText: "Ok. I got it")
                
            case .success:
                self.showCityMenu()
            }
        }
    }
    
}

protocol MapFieldViewControllerDelegate: class {
    func viewWillAppear()
}
