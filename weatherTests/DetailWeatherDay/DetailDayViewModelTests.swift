//
//  DetailWeatherDayViewModelTests.swift
//  weatherTests
//
//  Created by Lauriane Haydari on 13/02/2020.
//  Copyright © 2020 Lauriane Haydari. All rights reserved.
//

import XCTest
@ testable import weather

// MARK: - Mock

final class MockDetailDayViewModelDelegate: DetailDayViewModelDelegate {

    var alert: AlertType?

    var selectedWeatherWeekItem: WeatherWeekItem?

    func displayWeatherAlert(for type: AlertType) {
        self.alert = type
    }
}

// MARK: - Tests

class DetailDayViewModelTests: XCTestCase {

    let stack = CoreDataStack(modelName: "weather", type: .test)
    let client = MockHTTPClient()

    let delegate = MockDetailDayViewModelDelegate()

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

    let repository = MockRepository()

    func test_Given_DetailViewModel_When_ViewdidLoad_Then_visibleItemsIsDisplayed() {
        repository.saveWeatherWeekItem(weatherWeekItem: weatherWeekItem)
        repository.weatherWeekItems = [weatherWeekItem]
        delegate.selectedWeatherWeekItem = weatherWeekItem
        let viewModel = DetailDayViewModel(repository: repository,
                                           delegate: delegate,
                                           selectedWeatherItem: weatherWeekItem)
        viewModel.viewDidLoad()

        viewModel.visibleItems = { items in

            items.enumerated().forEach { (_, item) in
                XCTAssertEqual(item.time, self.delegate.selectedWeatherWeekItem?.time.dayFormat)
            }
        }
    }
}
