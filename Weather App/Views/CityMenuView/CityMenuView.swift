//
//  CityMenuView.swift
//  Weather App
//
//  Created by Archangel on 02/08/2019.
//  Copyright © 2019 Archangel. All rights reserved.
//

import UIKit

protocol CityMenuViewDelegate: class {
    func didRequestInformationOfCity()
}

class CityMenuView: UIView {

    @IBOutlet private weak var name: UILabel!
    @IBOutlet private weak var coordinates: UILabel!
    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet private weak var showWeatherButton: UIButton!
    @IBOutlet private var contentView: UIView!
    
    weak var delegate: CityMenuViewDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    private func initSubviews() {
        let nib = UINib(nibName: "CityMenuView", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
        
        setFramePreferences()
    }
    
    private func setFramePreferences() {
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true
        contentView.layer.masksToBounds = false
    }
    
    func show(with viewModel: MapFieldViewModel) {
        guard let cityName = viewModel.nameOfCity else { return }
        name.text = cityName
        coordinates.text = viewModel.getCoordinatesOfCity()
        self.showWithAnimation()
    }
    
    func updateInfo(with viewModel: MapFieldViewModel) {
        guard let cityName = viewModel.nameOfCity
            else {
                hide()
                return
        }
        
        name.text = cityName
        coordinates.text = viewModel.getCoordinatesOfCity()
    }
    
    func hide() {
        self.hideWithAnimation()
    }
    
    @IBAction private func closeButtonTapped(_ sender: UIButton) {
        hide()
    }
    
    @IBAction private func showCityButtonTapped(_ sender: UIButton) {
        delegate?.didRequestInformationOfCity()
    }
    
}
