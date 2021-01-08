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

    // MARK: - Initializer

    init(presenter: UINavigationController, screens: Screens) {
        self.navigationController = presenter
        self.screens = screens
        self.tabBarCoordinator = TabBarCoordinator.init(screens: screens)
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

    private func backToWeatherScreen(cityId: String) {
        let viewController = screens.createSelectViewController(delegate: self, cityId: cityId)
        navigationController.setViewControllers([viewController], animated: false)
        tabBarCoordinator.goBackToWeatherItem()
    }

    private func showAlert(for type: AlertType) {
        let alert = screens.createAlertView(for: type)
        navigationController.visibleViewController?.present(alert, animated: true, completion: nil)
    }
}

extension MapCoordinator: MapViewModelDelegate {
    func goToCityListView(cityId: String) {
        backToWeatherScreen(cityId: cityId)
    }

    func displayAlert(for type: AlertType) {
        showAlert(for: type)
    }
}

extension MapCoordinator: CityListViewModelDelegate {
    func didSelectCity(weatherListItem: WeatherListItem) {
    }
}
