//
//  RepositoryTests.swift
//  weatherTests
//
//  Created by Lauriane Haydari on 03/05/2020.
//  Copyright © 2020 Lauriane Haydari. All rights reserved.
//

import XCTest
@testable import weather

// MARK: - Tests

class RepositoryTests: XCTestCase {

    let client = MockHTTPClient()
    let stack = CoreDataStack(modelName: "weather", type: .test)

    let weatherWeekItem = WeatherWeekItem(cityId: "2988507",
                                          nameCity: "Paris",
                                          time: "2020-02-13 12:00:00",
                                          iconID: "01d", temperature: "15 °C",
                                          temperatureMax: "12 °C",
                                          temperatureMin: "12 °C",
                                          pressure: "1002 hPa",
                                          humidity: "50 %",
                                          feelsLike: "18 °C",
                                          description: "sunny")
    let cityItem = CityItem(id: "2988507",
                            nameCity: "paris",
                            country: "fr")

    let weatherListItem = WeatherListItem(id: "2988507",
                                          country: "Fr",
                                          nameCity: "Paris",
                                          temperature: "15 °C")

    func test_Given_Repository_When_getWeatherId_Then_DataIsCorrectlyReturned() {
        let context = Context(client: client, stack: stack)
        let repository = WeatherRepository(context: context)

        repository.getWeatherId(nameCity: cityItem.nameCity, country: cityItem.country, callback: { (weather) in
            switch weather {
            case .success(value: let weatherId):
                XCTAssertEqual("\(weatherId.city.id)", self.weatherListItem.id)
            case .error(error: let error):
                print(error)
            }
        }, onError: { _ in
            print("error")
        })
    }

    func test_Given_Repository_When_getWeatherList_Then_DataIsCorrectlyReturned() {
        let context = Context(client: client, stack: stack)
        let repository = WeatherRepository(context: context)

        repository.getWeatherList(cityId: weatherListItem.id, callback: { (weather) in
            switch weather {
            case .success(value: let weatherList):
                guard let list = weatherList.list.first else { return }
                let weatherListIteM = WeatherListItem(list: list, isCelsius: true)
                XCTAssertEqual(weatherListIteM.nameCity, self.weatherListItem.nameCity)
                XCTAssertEqual(weatherListIteM.country, self.weatherListItem.country)
                XCTAssertEqual(weatherListIteM.id, self.weatherListItem.id)
            case .error(error: let error):
                print(error)
            }
        }, onError: { _ in
            print("error")
        })
    }

    func test_Given_Repository_When_getWeatherWeek_Then_DataIsCorrectlyReturned() {
        let context = Context(client: client, stack: stack)
        let repository = WeatherRepository(context: context)

        repository.getWeatherWeek(idCity: weatherListItem.id, callback: { (weather) in
            switch weather {
            case .success(value: let weatherWeeK):
                let city = weatherWeeK.city
                guard let list = weatherWeeK.list.first else { return }
                let weatherWeekIteM = WeatherWeekItem(list: list, city: city, isCelsius: true)
                XCTAssertEqual(weatherWeekIteM.cityId, self.weatherWeekItem.cityId)
                XCTAssertEqual(weatherWeekIteM.nameCity, self.weatherWeekItem.nameCity)
            case .error(error: let error):
                print(error)
            }
        }, onError: { _ in
            print("error")
        })
    }

    func test_Given_Repository_When_deleteCityItemInDataBase_Then_DataIsCorrectlyReturned() {
        let context = Context(client: client, stack: stack)
        let repository = WeatherRepository(context: context)

        let expectation = self.expectation(description: "deleteCityItemInDataBase")

        repository.getCityItems { (items) in
            XCTAssertEqual(items, [])
            expectation.fulfill()
        }

        repository.saveCityItem(cityItem: cityItem)
        repository.deleteCityItemInDataBase(idCity: cityItem.id)

        repository.getCityItems { (items) in
            XCTAssertEqual(items, [])
        }

        waitForExpectations(timeout: 1.0, handler: nil)
    }

    func test_Given_Repository_When_deleteWeatherListItemInDataBase_Then_DataIsCorrectlyReturned() {
        let context = Context(client: client, stack: stack)
        let repository = WeatherRepository(context: context)

        let expectation = self.expectation(description: "deleteCityItemInDataBase")

        repository.getCityItems { (items) in
            XCTAssertEqual(items, [])
            expectation.fulfill()
        }

        repository.saveWeatherListItem(weatherListItem: weatherListItem)
        repository.deleteWeatherListItemInDataBase(idCity: weatherListItem.id)

        repository.getWeatherListItems { (items) in
            XCTAssertEqual(items, [])
        }

        waitForExpectations(timeout: 1.0, handler: nil)
    }

    func test_Given_Repository_When_deleteWeatherWeekItemInDataBase_Then_DataIsCorrectlyReturned() {
        let context = Context(client: client, stack: stack)
        let repository = WeatherRepository(context: context)

        let expectation = self.expectation(description: "deleteCityItemInDataBase")

        repository.getCityItems { (items) in
            XCTAssertEqual(items, [])
            expectation.fulfill()
        }

        repository.saveWeatherWeekItem(weatherWeekItem: weatherWeekItem)
        repository.deleteWeatherWeekItemInDataBase(idCity: weatherWeekItem.cityId)

        repository.getWeatherWeekItems { (items) in
            XCTAssertEqual(items, [])
        }

        waitForExpectations(timeout: 1.0, handler: nil)
    }

    func test_Given_Repository_When_deleteAllWeatherListItemInDataBase_Then_DataIsCorrectlyReturned() {
        let context = Context(client: client, stack: stack)
        let repository = WeatherRepository(context: context)

        let expectation = self.expectation(description: "deleteCityItemInDataBase")

        repository.getCityItems { (items) in
            XCTAssertEqual(items, [])
            expectation.fulfill()
        }

        repository.saveWeatherListItem(weatherListItem: weatherListItem)
        repository.deleteAllWeatherListInDataBase()

        repository.getWeatherListItems { (items) in
            XCTAssertEqual(items, [])
        }

        waitForExpectations(timeout: 1.0, handler: nil)
    }

    func test_Given_Repository_When_SaveCityItem_Then_getCityItems_IsCorrectlyReturned() {
        let client = MockHTTPClient()
        let stack = CoreDataStack(modelName: "weather", type: .test)
        let context = Context(client: client, stack: stack)
        let repository = WeatherRepository(context: context)

        repository.saveCityItem(cityItem: cityItem)
        repository.getCityItems { (items) in
            XCTAssertEqual(items, [self.cityItem])
        }
    }

    func test_Given_Repository_When_saveCityItem_Then_containsCity() {
        let client = MockHTTPClient()
        let stack = CoreDataStack(modelName: "weather", type: .test)
        let context = Context(client: client, stack: stack)
        let repository = WeatherRepository(context: context)

        let cityVerif = CityVerif(nameCity: cityItem.nameCity, country: cityItem.country)

        repository.saveCityItem(cityItem: cityItem)

        XCTAssertTrue(repository.containsCity(for: cityVerif))
    }

    func test_Given_Repository_When_SaveWeatherListItem_Then_getWeatherListItems_IsCorrectlyReturned() {
        let client = MockHTTPClient()
        let stack = CoreDataStack(modelName: "weather", type: .test)
        let context = Context(client: client, stack: stack)
        let repository = WeatherRepository(context: context)

        repository.saveWeatherListItem(weatherListItem: weatherListItem)
        repository.getWeatherListItems { (items) in
            XCTAssertEqual(items, [self.weatherListItem])
        }
    }

    func test_Given_Repository_When_SaveWeatherWeekItem_Then_getWeatherWeekItems_IsCorrectlyReturned() {
        let client = MockHTTPClient()
        let stack = CoreDataStack(modelName: "weather", type: .test)
        let context = Context(client: client, stack: stack)
        let repository = WeatherRepository(context: context)

        repository.saveWeatherWeekItem(weatherWeekItem: weatherWeekItem)
        repository.getWeatherWeekItems { (items) in
            XCTAssertEqual(items, [self.weatherWeekItem])
        }
    }
}
