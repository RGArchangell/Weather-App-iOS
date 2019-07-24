//
//  FloatExtensions.swift
//  Weather App
//
//  Created by Archangel on 22/07/2019.
//  Copyright © 2019 Archangel. All rights reserved.
//

extension Float {
    
    func convertToCoordinates() -> String {
        var value = self
        let degrees = Int(value)
        
        value = value.truncatingRemainder(dividingBy: 1)
        value = value * 100
        
        let firstPart = Int(value)
        
        value = value.truncatingRemainder(dividingBy: 1)
        value = value * 1000
        value = Float(Int(value))
        value = value / 10
        
        let secondPart = value
        return String("\(degrees)°\(firstPart)'\(secondPart)\"")
    }
    
    func convertToDirection() -> String {
        let value = self
        
        if value > 45.0 && value < 135.0 {
            return "E"
        }
        
        if value >= 135.0 && value <= 225.0 {
            return "S"
        }
        
        if value > 225.0 && value < 315.0 {
            return "W"
        }
        
        return "N"
    }
    
}
