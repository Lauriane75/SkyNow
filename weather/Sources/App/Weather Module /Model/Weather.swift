//
//  Weather.swift
//
//  Created by Lauriane Haydari on 12/02/2020.
//  Copyright © 2020 Lauriane Haydari. All rights reserved.
//

import Foundation

// MARK: - Forecast

struct Weather: Decodable {
    let city: City
}

struct City: Decodable {
    let id: Int
}
