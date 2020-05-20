//
//  MockWeatherRepository.swift
//  weatherTests
//
//  Created by Lauriane Haydari on 05/03/2020.
//  Copyright © 2020 Lauriane Haydari. All rights reserved.
//

import Foundation
@ testable import SkyNow

class MockRepository: WeatherRepositoryType {

    // MARK: - Properties

    var cityObjects: [CityObject] = []
    var weatherListObjects: [WeatherListObject] = []
    var weatherWeekObjects: [WeatherWeekObject] = []

    var weather: Weather?
    var weatherList: WeatherList?
    var weatherWeek: Weather?

    var weatherListItems: [WeatherListItem]?
    var weatherWeekItems: [WeatherWeekItem]?
    var cityItems: [CityItem]?

    var isSuccess = true
    var error: Error?
    var sameCity = false

    // MARK: - Contains same city

    func containsCity(for city: CityVerif) -> Bool {
        if sameCity {
            return true
        } else {
            return false
        }
    }

    func loadCities(callback: @escaping ([CityData]) -> Void, onError: @escaping (String) -> Void) {
    }

    // MARK: - Get from network

    func getWeatherList(cityId: String, callback: @escaping (Result<WeatherList>) -> Void, onError: @escaping (String) -> Void) {
        if isSuccess {
            guard let weatherList = weatherList else { return }
            callback(.success(value: weatherList))
        } else {
            guard let error = error else { return }
            callback(.error(error: error))
        }
    }

    func getWeatherWeek(idCity: String, callback: @escaping (Result<Weather>) -> Void, onError: @escaping (String) -> Void) {
        if isSuccess {
            guard let weatherWeek = weatherWeek else { return }
            callback(.success(value: weatherWeek))
        } else {
            guard let error = error else { return }
            callback(.error(error: error))
        }
    }

    func getLocationWeather(latitude: String, longitude: String, callback: @escaping (Result<Weather>) -> Void, onError: @escaping (String) -> Void) {

       }

    func getWeatherId(nameCity: String, country: String, callback: @escaping (Result<Weather>) -> Void, onError: @escaping (String) -> Void) {
        if isSuccess {
            guard let weather = weather else { return }
            callback(.success(value: weather)

            )} else if isSuccess == false {
            guard let error = error else { return }
            callback(.error(error: error))
        }
    }

    // MARK: - Get from database

    func getCityItems(callback: @escaping ([CityItem]) -> Void) {
        guard cityItems != nil else { return }
        callback(cityItems!)
    }

    func getWeatherListItems(callback: @escaping ([WeatherListItem]) -> Void) {
        guard weatherListItems != nil else { return }
        guard let weatherListItems = weatherListItems else { return }
        callback(weatherListItems)
    }

    func getWeatherWeekItems(callback: @escaping ([WeatherWeekItem]) -> Void) {
        guard weatherWeekItems != nil else { return }
        guard let weatherWeekItems = weatherWeekItems else { return }
        callback(weatherWeekItems)
    }

    // MARK: - Save in coredata

    func saveCityItem(cityItem: CityItem) {
        self.cityItems = [cityItem]
    }

    func saveWeatherListItem(weatherListItem: WeatherListItem) {
        self.weatherListItems = [weatherListItem]
    }

    func saveWeatherWeekItem(weatherWeekItem: WeatherWeekItem) {
        self.weatherWeekItems = [weatherWeekItem]
    }

    // MARK: - Delete in coredata

    func deleteCityItemInDataBase(idCity: String) {
    }

    func deleteAllWeatherListInDataBase() {
    }

    func deleteWeatherWeekItemInDataBase(idCity: String) {
    }

    func deleteWeatherListItemInDataBase(idCity: String) {
    }
}
