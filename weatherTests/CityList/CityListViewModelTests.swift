//
//  CityListViewModelTests.swift
//  weatherTests
//
//  Created by Lauriane Haydari on 05/03/2020.
//  Copyright © 2020 Lauriane Haydari. All rights reserved.
//

import XCTest
@ testable import SkyNow

// MARK: - Mock

class MockCityListViewModelDelegate: CityListViewModelDelegate {

    var alert: AlertType?

    var weatherListItem: WeatherListItem?

    func didSelectCity(weatherListItem: WeatherListItem) {
        self.weatherListItem = weatherListItem
    }

    func displayAlert(for type: AlertType) {
        self.alert = type
    }
}

// MARK: - Tests

class CityListViewModelTests: XCTestCase {

    let weatherList = WeatherList(list:
        [List(id: 2988507,
              sys: Sys(country: "fr"),
              main: Main(temp: 15,
              tempMin: 12,
              tempMax: 19),
              name: "paris")])

    let weatherListItem =
        WeatherListItem(id: "2988507",
                        country: "Fr",
                        nameCity: "paris",
                        temperature: "15 °C")

    let cityItem =
        CityItem(id: "2988507",
                nameCity: "paris",
                country: "fr")

    let repository = MockRepository()

    let delegate = MockCityListViewModelDelegate()

    func test_Given_ViewModel_When_viewWillAppear_WithNetwork_Then_ReactiveVariableAreDisplayed() {

        let viewModel = CityListViewModel(repository: repository, delegate: delegate)

        let expectation = self.expectation(description: "Diplayed unitText")

        viewModel.unitText = { text in
            XCTAssertEqual(text, " °F")
            expectation.fulfill()
        }

        viewModel.navBarTitle = { text in
            XCTAssertEqual(text, "City list")
        }

        viewModel.viewDidLoad()
        viewModel.viewWillAppear()

        waitForExpectations(timeout: 1.0, handler: nil)
    }

    func test_Given_ViewModel_When_viewWillAppear_WithNetwork_Then_visibleItemsAreDiplayed() {

        repository.weatherList = weatherList
        repository.weatherListItems = [self.weatherListItem]
        repository.cityItems = [self.cityItem]

        let viewModel = CityListViewModel(repository: repository, delegate: delegate)

//        let expectation = self.expectation(description: "Diplayed visibleItems")

        viewModel.visibleItems = { items in
//            XCTAssertEqual(items, self.repository.weatherListItems)
//            expectation.fulfill()
        }

        viewModel.viewDidLoad()
        viewModel.viewWillAppear()

//        waitForExpectations(timeout: 1.0, handler: nil)
    }

    func test_Given_ViewModel_When_ViewWillAppear_WithNetwork_isLoadingIsDiplayed() {

        repository.weatherList = weatherList
        repository.weatherListItems = [self.weatherListItem]
        repository.cityItems = [self.cityItem]

        let viewModel = CityListViewModel(repository: repository, delegate: delegate)

//        let expectation = self.expectation(description: "Displayed activityIndicator network")

        var counter = 0

        viewModel.isLoading = { state in
            if counter == 1 {
//                XCTAssertFalse(state)
//                expectation.fulfill()
            }
            counter += 1
        }
        viewModel.viewDidLoad()
        viewModel.viewWillAppear()

//        waitForExpectations(timeout: 1.0, handler: nil)
    }

    func test_Given_ViewModel_When_ViewWillAppear_WithoutNetwork_isLoadingIsDiplayed() {

        repository.isSuccess = false
        repository.weatherList = nil
        repository.weatherListItems = [self.weatherListItem]
        repository.cityItems = [self.cityItem]

        let viewModel = CityListViewModel(repository: repository, delegate: delegate)

        viewModel.isLoading = { state in
            XCTAssertEqual(state, true)
        }
        viewModel.viewDidLoad()
        viewModel.viewWillAppear()
    }

    func test_Given_ViewModel_When_didSelectCity_WithNetwork_Then_expectedResult() {

        repository.weatherList = weatherList
        repository.cityItems = [self.cityItem]

        let viewModel = CityListViewModel(repository: repository, delegate: delegate)

        viewModel.viewDidLoad()
        viewModel.viewWillAppear()
        viewModel.didSelectWeatherCityInList(at: 0)

    }

    func test_Given_ViewModel_When_didSelectCity_WithoutNetwork_Then_expectedResult() {

        repository.isSuccess = false
        repository.saveWeatherListItem(weatherListItem: weatherListItem)
        repository.weatherList = nil
        repository.cityItems = [self.cityItem]

        let viewModel = CityListViewModel(repository: repository, delegate: delegate)

        viewModel.viewDidLoad()
        viewModel.viewWillAppear()
        viewModel.didSelectWeatherCityInList(at: 0)

        XCTAssertEqual(delegate.weatherListItem, nil)
    }

    func test_Given_ViewModel_When_didPressDelete_WithNetwork_Then_expectedResult() {

        repository.weatherList = weatherList
        repository.weatherListItems = [self.weatherListItem]
        repository.cityItems = [self.cityItem]

        let viewModel = CityListViewModel(repository: repository, delegate: delegate)

        var counter = 0

        viewModel.visibleItems = { items in
            if counter == 1 {
                XCTAssertEqual(items, [])
            }
            counter += 1
        }

        viewModel.viewDidLoad()
        viewModel.viewWillAppear()
        viewModel.didPressDeleteCity(at: 0)
    }

    func test_Given_ViewModel_When_didPressDelete_WithoutNetwork_Then_expectedResult() {

        repository.weatherList = weatherList
        repository.cityItems = [self.cityItem]
        repository.isSuccess = false

        let viewModel = CityListViewModel(repository: repository, delegate: delegate)

        var counter = 0

        viewModel.visibleItems = { items in
            if counter == 1 {
                XCTAssertEqual(items, [])
            }
            counter += 1
        }

        viewModel.viewDidLoad()
        viewModel.viewWillAppear()
        viewModel.didPressDeleteCity(at: 0)
    }

    func test_Given_ViewModel_When__WithNetwork_Then_expectedResult() {

        repository.weatherList = weatherList
        repository.cityItems = [self.cityItem]

        let viewModel = CityListViewModel(repository: repository, delegate: delegate)

        viewModel.visibleItems = { items in
            XCTAssertEqual(items, [self.weatherListItem])
        }

        var counter = 0
        viewModel.isLoading = { state in
            if counter == 1 {
                XCTAssertEqual(state, false)
            }
            counter += 1
        }

        viewModel.viewWillAppear()
    }

    func test_Given_ViewModel_When__WithSameCity_Then_Alert() {

        repository.weatherListItems = [self.weatherListItem]
        repository.sameCity = true
        repository.cityItems = [self.cityItem]

        let viewModel = CityListViewModel(repository: repository, delegate: delegate)
        viewModel.viewDidLoad()
        viewModel.viewWillAppear()
//        XCTAssertEqual(delegate.alert, .nonUniqueCity)
    }

    func test_Given_ViewModel_When_didPressUnitButtonC_Then_UnitIsDisplayed() {

        let viewModel = CityListViewModel(repository: repository, delegate: delegate)

        viewModel.unitText = { state in
            XCTAssertEqual(state, " °F")
        }

        viewModel.viewWillAppear()
        viewModel.didPressUnitButton(unit: true)
    }

    func test_Given_ViewModel_When_didPressUnitButtonF_Then_UnitIsDisplayed() {

        let viewModel = CityListViewModel(repository: repository, delegate: delegate)

        viewModel.unitText = { state in
            XCTAssertEqual(state, " °C")
        }

        viewModel.viewWillAppear()
        viewModel.didPressUnitButton(unit: false)
    }

    func test_Given_ViewModel_When_didPressWeatherChanelButton_Then_urlStringIsDisplayed() {
        let viewModel = CityListViewModel(repository: repository, delegate: delegate)

        viewModel.urlString = { text in
            XCTAssertEqual(text, "https://weather.com/")
        }
        viewModel.viewDidLoad()
    }

    func test_Given_ViewModel_When_NoCitySaved_Then_Alert() {
        let viewModel = CityListViewModel(repository: repository, delegate: delegate)

        viewModel.viewDidLoad()
        viewModel.viewWillAppear()
    }
}
