//
//  MapFieldView.swift
//  Weather App
//
//  Created by Archangel on 04/08/2019.
//  Copyright © 2019 Archangel. All rights reserved.
//

import UIKit
import MapKit

class MapFieldView: UIView {
    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var map: MKMapView!
    @IBOutlet private var mapTapGestureRecognizer: UITapGestureRecognizer!
    
    weak var delegate: MapFieldViewDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    private func initSubviews() {
        let nib = UINib(nibName: "MapFieldView", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
    }
    
    private func addPin(coordinate: CLLocationCoordinate2D) {
        let locationPin = MapPin(coordinate: coordinate)
        map.removeAnnotations(map.annotations)
        map.addAnnotation(locationPin)
    }
    
    func setMapAtStartingLocation(viewModel: MapFieldViewModel) {
        let startLocation = viewModel.startLocation
        let startRadius = viewModel.regionRad
        centerMapOnLocation(location: startLocation, regionRadius: startRadius)
    }
    
    func centerMapOnLocation(location: CLLocation, regionRadius: CLLocationDistance) {
        let coordinateRegion = MKCoordinateRegion (center: location.coordinate,
                                                   latitudinalMeters: regionRadius,
                                                   longitudinalMeters: regionRadius)
        map.setRegion(coordinateRegion, animated: true)
    }
    
    func updateMap(coordinates: CLLocationCoordinate2D) {
        let annotations = self.map.annotations
        self.map.removeAnnotations(annotations)
        let mapPin = MapPin(coordinate: coordinates)
        self.map.addAnnotation(mapPin)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: coordinates, span: span)
        self.map.setRegion(region, animated: true)
    }
    
    @IBAction private func userTappedOnTheMap(_ sender: UITapGestureRecognizer) {
        guard sender.state == .ended else { return }
        
        let locationInView = sender.location(in: map)
        let tappedCoordinate = map.convert(locationInView, toCoordinateFrom: map)
        
        delegate?.userTappedOnMap(at: tappedCoordinate)
        addPin(coordinate: tappedCoordinate)
    }
    
}

protocol MapFieldViewDelegate: class {
    func userTappedOnMap(at coordinate: CLLocationCoordinate2D)
}
