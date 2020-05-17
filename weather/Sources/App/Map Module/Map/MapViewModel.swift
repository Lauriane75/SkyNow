//
//  SelectCityViewModel.swift
//  weather
//
//  Created by Lauriane Haydari on 12/02/2020.
//  Copyright © 2020 Lauriane Haydari. All rights reserved.
//

import Foundation
import StoreKit

protocol MapViewModelDelegate: class {
    func displayAlert(for type: AlertType)
}

final class MapViewModel {

    // MARK: - Properties

    private let repository: WeatherRepositoryType

    private weak var delegate: MapViewModelDelegate?

    // MARK: - Initializer

    init(repository: WeatherRepositoryType, delegate: MapViewModelDelegate?) {
        self.repository = repository
        self.delegate = delegate
    }

    // MARK: - Outputs

    // MARK: - Inputs

    func viewDidLoad() {
    }

    func viewWillAppear() {
    SKStoreReviewController.requestReview()
    }

    // MARK: - Private Files
}
