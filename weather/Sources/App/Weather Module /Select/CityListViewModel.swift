//
//  CityListViewModel.swift
//  weather
//
//  Created by Lauriane Haydari on 02/03/2020.
//  Copyright © 2020 Lauriane Haydari. All rights reserved.
//

import Foundation

protocol CityListViewModelDelegate: class {
    func didSelectCity(weatherListItem: WeatherListItem)
    func displayAlert(for type: AlertType)
}

final class CityListViewModel {

    // MARK: - Properties

    private let repository: WeatherRepositoryType

    private weak var delegate: CityListViewModelDelegate?

    private var cityId = ""

    private var isCelsius = true

    private var fromDataBase = false

    private var longitude = ""

    private var latitude = ""

    private var weatherListItems: [WeatherListItem] = [] {
        didSet {
            self.visibleItems?(self.weatherListItems)
        }
    }

    // MARK: - Initializer

    init(repository: WeatherRepositoryType, delegate: CityListViewModelDelegate?) {
        self.repository = repository
        self.delegate = delegate
    }

    // MARK: - Output

    var visibleItems: (([WeatherListItem]) -> Void)?

    var isLoading: ((Bool) -> Void)?

    var labelText: ((String) -> Void)?

    var navBarTitle: ((String) -> Void)?

    var cityText: ((String) -> Void)?

    var cityPlaceHolder: ((String) -> Void)?

    var countryText: ((String) -> Void)?

    var countryPlaceHolder: ((String) -> Void)?

    var addButtonText: ((String) -> Void)?

    var unitText: ((String) -> Void)?

    var urlString: ((String) -> Void)?

    // MARK: - Input

    func viewDidLoad() {
        labelText?("Press + to add your first city")
        navBarTitle?("City list")
        cityText?("Enter a city")
        cityPlaceHolder?("Paris")
        countryText?("Enter it's country")
        countryPlaceHolder?("France")
        addButtonText?("Add this city to the list")
        unitText?(" °F")
        urlString?("https://weather.com/")
    }

    func viewWillAppear() {
        updateCityID()
    }

    func viewDidAppear() {
        updateWeatherLocation()
        updateWeatherListItems()
    }

    func didPressAddCity(nameCity: String, country: String) {
        if nameCity.contains(" ") || country.contains(" ") || nameCity.isEmpty || country.isEmpty {
            self.delegate?.displayAlert(for: .wrongSpelling)
            return }
        let cityVerif = CityVerif(nameCity: nameCity, country: country)
        if containsCity(cityVerif: cityVerif) {
            delegate?.displayAlert(for: .nonUniqueCity)
        } else {
            getWeatherId(nameCity: nameCity, country: country)
        }
    }

    func didPressUnitButton(unit: Bool) {
        unit ? self.unitText?(" °F") : self.unitText?(" °C")
        isCelsius = unit
        fromDataBase ? delegate?.displayAlert(for: .errorService) : updateWeatherListItems()
    }

    func didSelectCity(at index: Int) {
        guard !self.weatherListItems.isEmpty, index < self.weatherListItems.count else { return }
        let item = self.weatherListItems[index]
        self.delegate?.didSelectCity(weatherListItem: item)
    }

    func didPressDeleteCity(at index: Int) {
        guard !self.weatherListItems.isEmpty, index < self.weatherListItems.count else { return }
        let item = self.weatherListItems[index]
        deleteItemInDataBase(item: item)
        weatherListItems.remove(at: index)
    }

    func didSendUserLocation(latitude: String, longitude: String) {
        self.latitude = latitude
        self.longitude = longitude
    }

    // MARK: - Private Functions

    fileprivate func updateWeatherLocation() {
        DispatchQueue.main.async {
            self.repository.getLocationWeather(latitude: self.latitude, longitude: self.longitude, callback: { (weather) in
                switch weather {
                case .success(value: let weatherLocation):
                    let id = "\(weatherLocation.city.id)"
                    let name = weatherLocation.city.name
                    let country = weatherLocation.city.country
                    let cityVerif = CityVerif(nameCity: name, country: country)

                    if self.containsCity(cityVerif: cityVerif) == false {
                        let cityItem = CityItem(id: id, nameCity: name, country: country)
                        self.repository.saveCityItem(cityItem: cityItem)
                        self.updateCityID()
                        self.updateWeatherListItems()
                    }
                case .error(error: let error):
                    print(error)
                }
            }, onError: { [weak self] _ in
                guard let self = self else { return }
                self.delegate?.displayAlert(for: .errorService)
            })
        }
    }

    fileprivate func getWeatherId(nameCity: String, country: String) {
        self.repository.getWeatherId(nameCity: nameCity, country: country, callback: { (weather) in
            switch weather {
            case .success(value: let weatherItem):
                let id = "\(weatherItem.city.id)"
                guard id != "" else { return }
                let cityItem = CityItem(id: id, nameCity: nameCity, country: country)
                self.repository.saveCityItem(cityItem: cityItem)
                self.updateCityID()
                self.updateWeatherListItems()
            case .error: break
            }
        }, onError: { [weak self] _ in
            guard let self = self else { return }
            self.delegate?.displayAlert(for: .errorService)
        })
    }

    fileprivate func containsCity(cityVerif: CityVerif) -> Bool {
        if repository.containsCity(for: cityVerif) {
            self.isLoading?(false)
            return true
        }
        return false
    }

    fileprivate func updateCityID() {
        self.isLoading?(true)
        self.cityId = ""
        repository.getCityItems { (cityItems) in
            cityItems.enumerated().forEach { (_, item) in
                self.cityId.append(",\(item.id)")
            }
        }
    }

    fileprivate func getWeatherList() {
        self.repository.getWeatherList(cityId: cityId, callback: { (weather) in
            switch weather {
            case .success(let weatherList):
                self.isLoading?(false)
                self.repository.deleteAllWeatherListInDataBase()
                self.weatherListItems = weatherList.list.map { list in
                    WeatherListItem(list: list, isCelsius: self.isCelsius)
                }
                self.deleteAllWeatherListItemInDataBase()
                self.saveWeatherListItemInDataBase(self.weatherListItems)
            case .error:
                self.delegate?.displayAlert(for: .errorService)
            }
        }, onError: { [weak self] _ in
            guard let self = self else { return }
            self.fromDataBase = true
            self.repository.getWeatherListItems(callback: { (items) in
                guard !items.isEmpty else {
                    self.delegate?.displayAlert(for: .errorService)
                    return }
                self.isLoading?(false)
                self.weatherListItems = items
            })
        })
    }

    fileprivate func updateWeatherListItems() {
        guard !cityId.isEmpty else {
            self.isLoading?(false)
            delegate?.displayAlert(for: .addCity)
            return
        }
        getWeatherList()
    }

    fileprivate func deleteAllWeatherListItemInDataBase() {
        DispatchQueue.main.async {
            self.repository.deleteAllWeatherListInDataBase()
        }
    }

    fileprivate func saveWeatherListItemInDataBase(_ items: ([WeatherListItem])) {
        DispatchQueue.main.async {
            items.enumerated().forEach { _, item in
                self.repository.saveWeatherListItem(weatherListItem: item)
            }
        }
    }

    fileprivate func deleteItemInDataBase(item: WeatherListItem) {
        DispatchQueue.main.async {
            self.repository.deleteWeatherListItemInDataBase(idCity: item.id)
            self.repository.deleteCityItemInDataBase(idCity: item.id)
            self.repository.deleteWeatherWeekItemInDataBase(idCity: item.id)
        }
    }
}
