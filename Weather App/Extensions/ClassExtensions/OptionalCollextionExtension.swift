//
//  OptionalCollextionExtension.swift
//  Weather App
//
//  Created by Archangel on 02/08/2019.
//  Copyright © 2019 Archangel. All rights reserved.
//

import Foundation

extension Optional where Wrapped: Collection {
    var isEmptyOrNil: Bool {
        return self?.isEmpty ?? true
    }
}
