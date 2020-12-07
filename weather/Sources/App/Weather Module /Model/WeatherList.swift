//
//  WeatherID.swift
//  weather
//
//  Created by Lauriane Haydari on 24/04/2020.
//  Copyright © 2020 Lauriane Haydari. All rights reserved.
//

import Foundation

// MARK: - Weather
struct WeatherList: Decodable {
    let list: [List]
}

// MARK: - List
struct List: Decodable {
    let id: Int
    let sys: Sys
    let main: Main
    let name: String
}

// MARK: - Main
struct Main: Decodable {
    let temp: Double
    let tempMin: Double
    let tempMax: Double

    enum CodingKeys: String, CodingKey {
        case temp
        case tempMin = "temp_min"
        case tempMax = "temp_max"
    }
}

// MARK: - Sys
struct Sys: Decodable {
    let country: String
}
