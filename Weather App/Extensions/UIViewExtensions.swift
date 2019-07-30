//
//  UIViewExtensions.swift
//  Weather App
//
//  Created by Archangel on 22/07/2019.
//  Copyright © 2019 Archangel. All rights reserved.
//

import UIKit

extension UIView {
    
    func showWithAnimation() {
        
        UIView.animate(withDuration: 0.6, delay: 0, options: [.curveEaseIn],
                       animations: {
                        self.center.y -= self.bounds.height * 2
                        self.layoutIfNeeded()
        }, completion: nil)
        self.isHidden = false
    }
    
    func hideWithAnimation() {
        
        UIView.animate(withDuration: 0.6, delay: 0, options: [.curveLinear],
                       animations: {
                        self.center.y += self.bounds.height * 2
                        self.layoutIfNeeded()
                        
        },  completion: {(_ completed: Bool) -> Void in
            self.isHidden = true
        })
    }
    
}
