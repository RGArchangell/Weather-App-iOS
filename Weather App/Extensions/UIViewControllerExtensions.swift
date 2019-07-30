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
        let retryAction = UIAlertAction(title: actionText, style: .default) { (_) -> Void in
            alertController.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(retryAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}
