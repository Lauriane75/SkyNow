//
//  WeatherViewModel.swift
//  weather
//
//  Created by Lauriane Haydari on 12/02/2020.
//  Copyright © 2020 Lauriane Haydari. All rights reserved.
//

import Foundation

protocol WeekViewModelDelegate: class {
    func didSelectDay(item: WeatherWeekItem)
    func displayWeatherAlert(for type: AlertType)
}

final class WeekViewModel {

    // MARK: - Properties

    private let repository: WeatherRepositoryType

    private weak var delegate: WeekViewModelDelegate?

    private var weatherListItem: WeatherListItem

    private var isCelsius = true

    private var fromDataBase = false

    private var weatherItems: [WeatherWeekItem] = [] {
        didSet {
            self.visibleItems?(self.weatherItems)
        }
    }

    private let timeWeatherDay = "12:00:00"
    var tempNowText = ""

    // MARK: - Initializer

    init(repository: WeatherRepositoryType, delegate: WeekViewModelDelegate?, weatherListItem: WeatherListItem) {
        self.repository = repository
        self.delegate = delegate
        self.weatherListItem = weatherListItem
    }

    // MARK: - Outputs

    var visibleItems: (([WeatherWeekItem]) -> Void)?

    var isLoading: ((Bool) -> Void)?

    var unitText: ((String) -> Void)?

    var urlString: ((String) -> Void)?

    // MARK: - Inputs

    func viewDidLoad() {
        isLoading?(true)
        unitText?(" °F")
    }

    func viewWillAppear() {
        updateWeekWeatherItems()
    }

    func didSelectDay(at index: Int) {
        guard !self.weatherItems.isEmpty, index < self.weatherItems.count else { return }
        let item = self.weatherItems[index]
        self.delegate?.didSelectDay(item: item)
    }

    func didPressUnitButton(unit: Bool) {
        unit ? self.unitText?(" °F") : self.unitText?(" °C")
        isCelsius = unit
        fromDataBase ? delegate?.displayWeatherAlert(for: .errorService) : self.updateWeekWeatherItems()
    }

    func didPressWeatherChanelButton() {
        urlString?("https://weather.com/")
    }

    // MARK: - Private Files

    fileprivate func updateWeekWeatherItems() {
        repository.getWeatherWeek(idCity: weatherListItem.id, callback: { (weather) in
            switch weather {
            case .success(value: let weatherWeek):
                let weatherItems: [WeatherWeekItem] = weatherWeek.list.map { item in
                    let cityItem = weatherWeek.city
                    return WeatherWeekItem(list: item, city: cityItem, isCelsius: self.isCelsius)
                }
                self.isLoading?(false)
                self.initialize(weatherWeekItems: weatherItems)
                self.repository.deleteWeatherWeekItemInDataBase(idCity: self.weatherListItem.id)
                self.saveWeatherWeekInDataBase(weatherItems)
            case .error:
                self.delegate?.displayWeatherAlert(for: .errorService)
            }
        }, onError: { [weak self] _ in
            guard let self = self else { return }
            self.fromDataBase = true
            self.repository.getWeatherWeekItems(callback: { (items) in
                self.isLoading?(false)
                self.initialize(weatherWeekItems: items)
                guard !self.weatherItems.isEmpty else {
                    self.delegate?.displayWeatherAlert(for: .errorService)
                    return }
            })
        })
    }

    private func initialize(weatherWeekItems: [WeatherWeekItem]) {
        let weekWeatherItems = weatherWeekItems.filter { $0.cityId.contains(self.weatherListItem.id) }
        let items = weekWeatherItems.filter { $0.time.contains(self.timeWeatherDay) }
        if items.isEmpty { return }
        self.weatherItems = items
    }

    private func saveWeatherWeekInDataBase(_ items: ([WeatherWeekItem])) {
        DispatchQueue.main.async {
            items.enumerated().forEach { (_, item) in
                self.repository.saveWeatherWeekItem(weatherWeekItem: item)
            }
        }
    }
}
