//
//  WeatherWeek.swift
//  weather
//
//  Created by Lauriane Haydari on 27/04/2020.
//  Copyright © 2020 Lauriane Haydari. All rights reserved.
//

import Foundation

// MARK: - Weather
struct WeatherWeek: Decodable {
    let list: [ListElement]
    let city: CityElement
}

// MARK: - City
struct CityElement: Decodable {
    let id: Int
    let name: String
    let coord: Coord
    let country: String
}

// MARK: - Coord
struct Coord: Codable {
    let lat, lon: Double
}

// MARK: - List
struct ListElement: Decodable {
    let main: MainClass
    let weather: [WeatherElmt]
    let dtTxt: String

    enum CodingKeys: String, CodingKey {
        case main, weather
        case dtTxt = "dt_txt"
    }
}

// MARK: - MainClass
struct MainClass: Decodable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, humidity: Int

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case humidity
    }
}

// MARK: - WeatherElement
struct WeatherElmt: Decodable {
    let weatherDescription: String
    let icon: String

    enum CodingKeys: String, CodingKey {
        case weatherDescription = "description"
        case icon
    }
}
