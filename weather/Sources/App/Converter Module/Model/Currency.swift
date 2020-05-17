//
//  Currency.swift
//  weather
//
//  Created by Lauriane Haydari on 16/05/2020.
//  Copyright © 2020 Lauriane Haydari. All rights reserved.
//

import Foundation

struct Currency: Codable {
    let base = "EUR"
    let date: String
    let rates: [String: Double]
}
