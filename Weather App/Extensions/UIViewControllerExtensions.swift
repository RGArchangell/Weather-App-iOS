//
//  UIViewControllerExtensions.swift
//  Weather App
//
//  Created by Archangel on 31/07/2019.
//  Copyright © 2019 Archangel. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showAlert(title: String, message: String, actionText: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let retryAction = UIAlertAction(title: actionText, style: .default) { _ -> Void in
            alertController.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(retryAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func setActivityIndicator(indicator activityIndicator: UIActivityIndicatorView) {
        activityIndicator.style = UIActivityIndicatorView.Style.whiteLarge
        activityIndicator.center = self.view.center
        activityIndicator.color = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        activityIndicator.hidesWhenStopped = true
        self.view.addSubview(activityIndicator)
    }
    
    func showActivityIndicator(indicator activityIndicator: UIActivityIndicatorView) {
        setActivityIndicator(indicator: activityIndicator)
        activityIndicator.startAnimating()
    }
    
    func hideActivityIndicator(indicator activityIndicator: UIActivityIndicatorView) {
        activityIndicator.stopAnimating()
    }
    
}
