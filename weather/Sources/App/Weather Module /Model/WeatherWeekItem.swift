//
//  WeatherItems.swift
//  weather
//
//  Created by Lauriane Haydari on 12/02/2020.
//  Copyright © 2020 Lauriane Haydari. All rights reserved.
//

import Foundation

struct WeatherWeekItem: Equatable {
    let cityId: String
    let nameCity: String
    let time: String
    let iconID: String
    let temperature: String
    let temperatureMax: String
    let temperatureMin: String
    let pressure: String
    let humidity: String
    let feelsLike: String
    let description: String
}
