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

    private var userLocation: UserLocation?

    private var weatherListItems: [WeatherListItem] = [] {
        didSet {
            self.visibleItems?(self.weatherListItems)
        }
    }

    private var cities: [CityData] = []

    private var visibleCities: [CityData] = [] {
        didSet {
            DispatchQueue.main.async {
                self.cityData?(self.visibleCities)
            }
        }
    }

    // MARK: - Initializer

    init(repository: WeatherRepositoryType, delegate: CityListViewModelDelegate?) {
        self.repository = repository
        self.delegate = delegate
    }

    // MARK: - Output

    var visibleItems: (([WeatherListItem]) -> Void)?

    var cityData: (([CityData]) -> Void)?

    var isLoading: ((Bool) -> Void)?

    var navBarTitle: ((String) -> Void)?

    var unitText: ((String) -> Void)?

    var urlString: ((String) -> Void)?

    var selectedCityText: ((String) -> Void)?

    var tableViewisHidden: ((Bool) -> Void)?

    var stackViewisHidden: ((Bool) -> Void)?

    var tableViewTopConstraint: ((Float) -> Void)?

    // MARK: - Input

    func viewDidLoad() {
        navBarTitle?("City list")
        unitText?(" °F")
        urlString?("https://weather.com/")
        tableViewTopConstraint?(0)
    }

    func viewWillAppear() {
        updateWeatherLocation()
        updateCityID()
    }

    func viewDidAppear() {
        updateWeatherListItems()
    }

    func setUpVideo() -> URL? {
        let bundlePath = Bundle.main.path(forResource: "sky-cloud-sunny", ofType: "mp4")
        guard bundlePath != nil else { return nil }
        return URL(fileURLWithPath: bundlePath!)
    }

    // MARK: - Searh bar

    func getCities() {
        repository.loadCities(callback: { (cities) in
            self.cities = cities
        }, onError: { [weak self] _ in
            guard let self = self else { return }
            self.delegate?.displayAlert(for: .errorService)
        })
    }

    func didSelectCityInSearchBar(at index: Int) {
        guard !self.visibleCities.isEmpty, index < self.visibleCities.count else { return }
        let item = self.visibleCities[index]
        self.selectedCityText?("\(item.name), \(item.country), \(item.state)")
        let cityVerif = CityVerif(nameCity: item.name, country: item.country)
        if self.containsCity(cityVerif: cityVerif) == false {
            let cityItem = CityItem(id: "\(item.id)", nameCity: item.name, country: item.country)
            updateList(cityItem: cityItem)
            tableViewisHidden?(false)
            stackViewisHidden?(true)
            tableViewTopConstraint?(0)
        } else {
            delegate?.displayAlert(for: .nonUniqueCity)
        }
    }

    func didSearchCities(with name: String, numberOfLetters: Int) {
        DispatchQueue.main.async {
            let citiesFound = self.cities.filter { (items) in items.name.lowercased().prefix(numberOfLetters) == name }
            guard !citiesFound.isEmpty else { return }
            self.visibleCities = citiesFound
        }
    }

    // MARK: - Unit button

    func didPressUnitButton(unit: Bool) {
        unit ? self.unitText?(" °F") : self.unitText?(" °C")
        isCelsius = unit
        if fromDataBase {
            delegate?.displayAlert(for: .errorService)
        } else {
            updateCityID()
            updateWeatherListItems()
        }
    }

    // MARK: - City list

    func didSelectWeatherCityInList(at index: Int) {
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
        self.userLocation = UserLocation(latitude: latitude, longitude: longitude)
    }

    // MARK: - Private Functions

    fileprivate func updateWeatherLocation() {
        guard userLocation != nil else { return }
        self.repository.getLocationWeather(latitude: userLocation!.latitude, longitude: userLocation!.longitude, callback: { (weather) in
            switch weather {
            case .success(value: let weatherLocation):
                DispatchQueue.main.async {
                    let id = "\(weatherLocation.city.id)"
                    let name = weatherLocation.city.name
                    let country = weatherLocation.city.country

                    let cityVerif = CityVerif(nameCity: name, country: country)

                    if self.containsCity(cityVerif: cityVerif) == false {
                        let cityItem = CityItem(id: id, nameCity: name, country: country)
                        self.updateList(cityItem: cityItem)
                    }
                }
            case .error(error: let error):
                print(error)
            }
        }, onError: { [weak self] _ in
            guard let self = self else { return }
            self.delegate?.displayAlert(for: .userlocation)
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

    fileprivate func updateList(cityItem: CityItem) {
        repository.saveCityItem(cityItem: cityItem)
        updateCityID()
        updateWeatherListItems()
    }
}
