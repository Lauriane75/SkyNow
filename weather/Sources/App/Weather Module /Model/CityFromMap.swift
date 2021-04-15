//
//  CityFromMap.swift
//  weather
//
//  Created by Lauriane Haydari on 03/01/2021.
//  Copyright © 2021 Lauriane Haydari. All rights reserved.
//

import Foundation

// MARK: - CityFromMap
struct CityFromMap: Decodable {
    let id: Int
    let name: String
    let main: MainTemp
    let weather: [WeatherIcon]
}

// MARK: - Main
struct MainTemp: Decodable {
    let temp: Double
    enum CodingKeys: String, CodingKey {
        case temp
    }
}

// MARK: - Weather
struct WeatherIcon: Decodable {
    let weatherDescription: String
    let icon: String

    enum CodingKeys: String, CodingKey {
        case weatherDescription = "description"
        case icon
    }
}
