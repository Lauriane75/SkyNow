//
//  SelectCityViewModel.swift
//  weather
//
//  Created by Lauriane Haydari on 12/02/2020.
//  Copyright © 2020 Lauriane Haydari. All rights reserved.
//

import Foundation

protocol MapViewModelDelegate: class {
    func goToCityListView(cityId: String)
}

final class MapViewModel {

    // MARK: - Properties

    private let repository: WeatherRepositoryType

    private weak var delegate: MapViewModelDelegate?

    private var cityId = ""

    // MARK: - Initializer

    init(repository: WeatherRepositoryType, delegate: MapViewModelDelegate?) {
        self.repository = repository
        self.delegate = delegate
    }

    // MARK: - Outputs

    var cancelButtonText: ((String) -> Void)?
    var addButtonText: ((String) -> Void)?
    var labelText: ((String) -> Void)?
    var viewState: ((Bool) -> Void)?

    // MARK: - Inputs

    func viewDidLoad() {
    }

    func viewWillAppear() {

    }

    // MARK: - Private Files

    func findCity(lat: String, long: String) {
        repository.getWeatherCityFromMap(lat: lat, long: long, callback: { (city) in
            switch city {
            case .success(value: let cityValue):
                let cityFromMapItem = CityFromMapItem(id: "\(cityValue.id)", name: "\(cityValue.name)")
                DispatchQueue.main.async {
                    self.viewState?(false)
                    self.cancelButtonText?("Cancel")
                    self.addButtonText?("Add")
                    self.labelText?("\(cityFromMapItem.name)")
                    self.cityId = "\(cityFromMapItem.id)"
                }
            case .error(let error):
                print(error)
            }
        }, onError: { [weak self] _ in
            guard let self = self else { return }
            self.viewState?(true)
        })
    }

    func didPressCancelButton() {
        self.viewState?(true)
    }

    func didPressAddButton() {
        self.viewState?(true)
        guard cityId != "" else {
            return
        }
        delegate?.goToCityListView(cityId: cityId)
    }

    func setUpVideo() -> URL? {
          let bundlePath = Bundle.main.path(forResource: "sky-cloud-sunny", ofType: "mp4")
          guard bundlePath != nil else { return nil }
          return URL(fileURLWithPath: bundlePath!)
      }
}
