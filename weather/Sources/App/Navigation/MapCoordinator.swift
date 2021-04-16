//
//  MapCoordinator.swift
//  weather
//
//  Created by Lauriane Haydari on 07/04/2020.
//  Copyright © 2020 Lauriane Haydari. All rights reserved.
//

import UIKit

final class MapCoordinator {

    // MARK: - Properties

    private let navigationController: UINavigationController

    var childCoordinator: CoordinatorProtocol?

    private let screens: Screens

    let tabBarCoordinator: TabBarCoordinator

    let weatherCoordinator: WeatherCoordinator

    // MARK: - Initializer

    init(presenter: UINavigationController, screens: Screens) {
        self.navigationController = presenter
        self.screens = screens
        self.tabBarCoordinator = TabBarCoordinator.init(screens: screens)
        self.weatherCoordinator = WeatherCoordinator.init(presenter: navigationController, screens: screens)
    }
}

// MARK: - CoordinatorProtocol

extension MapCoordinator: CoordinatorProtocol {

    func start() {
        showMapView()
    }

    private func showMapView() {
        let viewController = screens.createMapViewController(delegate: self)
        navigationController.pushViewController(viewController, animated: false)
    }
}

extension MapCoordinator: CityListViewModelDelegate {
    func displayAlert(for type: AlertType) {

    }

    func didSelectCity(weatherListItemID: String) {

    }
}

extension MapCoordinator: MapViewModelDelegate {
    func goToCityListView(cityId: String) {
        weatherCoordinator.showCityList(cityId: cityId)
    }
}
