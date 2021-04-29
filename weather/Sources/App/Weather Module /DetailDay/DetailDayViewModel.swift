//
//  DetailWeatherDayViewModel.swift
//  weather
//
//  Created by Lauriane Haydari on 12/02/2020.
//  Copyright © 2020 Lauriane Haydari. All rights reserved.
//

import Foundation

protocol DetailDayViewModelDelegate: AnyObject {
    func displayWeatherAlert(for type: AlertType)
}

final class DetailDayViewModel {

    // MARK: - Properties

    private let repository: WeatherRepositoryType

    private weak var delegate: DetailDayViewModelDelegate?

    private var selectedWeatherItem: WeatherWeekItem

    // MARK: - Initializer

    init(repository: WeatherRepositoryType, delegate: DetailDayViewModelDelegate?, selectedWeatherItem: WeatherWeekItem) {
        self.repository = repository
        self.delegate = delegate
        self.selectedWeatherItem = selectedWeatherItem
    }

    // MARK: - Outputs

    var visibleItems: (([WeatherWeekItem]) -> Void)?

    // MARK: - Inputs

    func viewDidLoad() {
        updateWeatherOfTheDay()
    }

    func setUpVideo() -> URL? {
        let bundlePath = Bundle.main.path(forResource: "sky-cloud-sunny", ofType: "mp4")
        guard bundlePath != nil else { return nil }
        return URL(fileURLWithPath: bundlePath!)
    }

    // MARK: - Private Files

    fileprivate func updateWeatherOfTheDay() {
        repository.getWeatherWeekItems(callback: { (items) in
            let itemsOfTheCity = items.filter { (weatherItems) in
                weatherItems.cityId == self.selectedWeatherItem.cityId
            }
            let itemsOfTheDay = itemsOfTheCity.filter { item in
                item.time.contains(self.selectedWeatherItem.time.dayFormat) }
            guard !itemsOfTheDay.isEmpty else {
                self.delegate?.displayWeatherAlert(for: .errorService)
                return }
            self.visibleItems?(itemsOfTheDay)
        })
    }
}
