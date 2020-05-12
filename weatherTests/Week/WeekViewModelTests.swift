//
//  WeahterViewModelTests.swift
//  weatherTests
//
//  Created by Lauriane Haydari on 12/02/2020.
//  Copyright © 2020 Lauriane Haydari. All rights reserved.
//

import XCTest
@ testable import SkyNow

// MARK: - Mock

class MockWeekViewModelDelegate: WeekViewModelDelegate {

    var alert: AlertType?

    var weatherWeekItem: WeatherWeekItem?

    var weatherListItem: WeatherListItem?

    func didSelectDay(item: WeatherWeekItem) {
        self.weatherWeekItem = item
    }

    func displayWeatherAlert(for type: AlertType) {
        self.alert = type
    }
}

// MARK: - Tests

class WeekViewModelTests: XCTestCase {

    let weather = Weather(list: [ListElement(main: MainClass(temp: 15, feelsLike: 18, tempMin: 12, tempMax: 19, pressure: 1002, humidity: 50),
                                             weather: [WeatherElmt(weatherDescription: "sunny", icon: "01d")], dtTxt: "2020-02-13 12:00:00")],
                          city: CityElement(id: 2988507, name: "paris", coord: Coord(lat: 48.8534, lon: 2.3488), country: "fr"))

    let weatherListItem =
        WeatherListItem(id: "2988507",
                        country: "fr",
                        nameCity: "paris",
                        temperature: "15 °C")

    let weatherWeekItem =
        WeatherWeekItem(cityId: "2988507",
                    nameCity: "paris",
                    time: "2020-02-13 12:00:00",
                    iconID: "01d", temperature: "15 °C",
                    temperatureMax: "19 °C",
                    temperatureMin: "12 °C",
                    pressure: "1002 hPa",
                    humidity: "50 %",
                    feelsLike: "18 °C",
                    description: "sunny")

    let delegate = MockWeekViewModelDelegate()
    let repository = MockRepository()

    func test_Given_ViewModel_When_ViewWillAppear_WhithNetwork_Then_visibleItemsAreDiplayed() {
        repository.weather = weather
        repository.weatherWeekItems = [self.weatherWeekItem]

        let viewModel = WeekViewModel(repository: repository, delegate: delegate, weatherListItem: weatherListItem)

//        let expectation = self.expectation(description: "Displayed visibleItems with network")

        viewModel.visibleItems = { items in
//                XCTAssertEqual(items, self.repository.weatherWeekItems)
//                expectation.fulfill()
        }

        viewModel.viewDidLoad()
        viewModel.viewWillAppear()
        viewModel.viewDidLoad()

//        waitForExpectations(timeout: 1.0, handler: nil)
    }

    func test_Given_ViewModel_When_viewDidLoad_Then_unitIsDiplayed() {
        let viewModel = WeekViewModel(repository: repository, delegate: delegate, weatherListItem: weatherListItem)

        viewModel.unitText = { text in
            XCTAssertEqual(text, " °F")
        }

        viewModel.viewDidLoad()
    }

    func test_Given_ViewModel_When_didPressUnitButtonC_Then_UnitIsDisplayed() {

        let viewModel = WeekViewModel(repository: repository, delegate: delegate, weatherListItem: weatherListItem)

        viewModel.unitText = { state in
            XCTAssertEqual(state, " °F")
        }

        viewModel.viewWillAppear()
        viewModel.didPressUnitButton(unit: true)
    }

    func test_Given_ViewModel_When_didPressUnitButtonF_Then_UnitIsDisplayed() {

        let viewModel = WeekViewModel(repository: repository, delegate: delegate, weatherListItem: weatherListItem)

        viewModel.unitText = { state in
            XCTAssertEqual(state, " °C")
        }

        viewModel.viewWillAppear()
        viewModel.didPressUnitButton(unit: false)
    }

    func test_Given_ViewModel_When_didPressWeatherChanelButton_Then_urlStringIsDisplayed() {

        let viewModel = WeekViewModel(repository: repository, delegate: delegate, weatherListItem: weatherListItem)

        viewModel.urlString = { text in
            XCTAssertEqual(text, "https://weather.com/")
        }

        viewModel.viewDidLoad()
    }

    func test_Given_ViewModel_When_ViewWillAppear_WhithoutNetwork_Then_visibleItemsAreDiplayedFromDatabase() {
        repository.isSuccess = false
        repository.weatherWeekItems = [self.weatherWeekItem]

        let viewModel = WeekViewModel(repository: repository, delegate: delegate, weatherListItem: weatherListItem)

        viewModel.viewDidLoad()
        viewModel.viewWillAppear()

        viewModel.visibleItems = { items in
            XCTAssertEqual(items, [self.weatherWeekItem])
        }
    }

    func test_Given_ViewModel_When_ViewDidLoad_Then_isLoadingIsDiplayed() {
        let viewModel = WeekViewModel(repository: repository, delegate: delegate, weatherListItem: weatherListItem)

        viewModel.isLoading = { state in
            XCTAssertTrue(state)
        }

        viewModel.viewDidLoad()
    }

    func test_Given_ViewModel_When_ViewWillAppear_WhithoutNetwork_isLoadingIsDiplayed() {
        repository.isSuccess = false
        repository.weatherWeek = nil
        repository.weatherWeekItems = [self.weatherWeekItem]

        var counter = 0

        let viewModel = WeekViewModel(repository: repository, delegate: delegate, weatherListItem: weatherListItem)
        viewModel.isLoading = { state in
            if counter == 1 {
                XCTAssertFalse(state)
            }
            counter += 1
        }
        viewModel.viewDidLoad()
        viewModel.viewWillAppear()
    }

    func test_Given_ViewModel_When_didSelectWeather_WithNetwork_Then_expectedResult() {
        repository.weather = weather
        repository.weatherWeekItems = [self.weatherWeekItem]

        let viewModel = WeekViewModel(repository: repository, delegate: delegate, weatherListItem: weatherListItem)

        viewModel.viewDidLoad()
        viewModel.viewWillAppear()
        viewModel.didSelectDay(at: 0)

//        XCTAssertEqual(delegate.weatherWeekItem, self.weatherWeekItem)
    }

    func test_Given_ViewModel_When_didSelectWeather_WithoutNetwork_Then_expectedResult() {
        repository.isSuccess = false
        repository.weather = nil

        let viewModel = WeekViewModel(repository: repository, delegate: delegate, weatherListItem: weatherListItem)

        viewModel.viewDidLoad()
        viewModel.viewWillAppear()

        viewModel.didSelectDay(at: 0)
        XCTAssertEqual(delegate.weatherWeekItem, nil)
    }

    func test_Given_ViewModel_When_noItemsWithoutNetwork_Then_alert() {
        repository.isSuccess = false
        repository.weather = weather
        let viewModel = WeekViewModel(repository: repository, delegate: delegate, weatherListItem: weatherListItem)

        viewModel.viewDidLoad()
        viewModel.viewWillAppear()

//        XCTAssertEqual(self.delegate.alert, .errorService)
    }
}
