//
//  CityData.swift
//  weather
//
//  Created by Lauriane Haydari on 14/05/2020.
//  Copyright © 2020 Lauriane Haydari. All rights reserved.
//

import Foundation

struct CityData: Codable {
    var id: Int
    var name: String
    var state: String
    var country: String
}
