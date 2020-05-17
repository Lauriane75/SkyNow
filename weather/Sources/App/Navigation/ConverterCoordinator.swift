//
//  ConverterCoordinator.swift
//  weather
//
//  Created by Lauriane Haydari on 15/05/2020.
//  Copyright © 2020 Lauriane Haydari. All rights reserved.
//

import UIKit

final class ConverterCoordinator {

    // MARK: - Properties

    private let navigationController: UINavigationController

    var childCoordinator: CoordinatorProtocol?

    private let screens: Screens

    // MARK: - Initializer

    init(presenter: UINavigationController, screens: Screens) {
        self.navigationController = presenter
        self.screens = screens
    }
}

    // MARK: - CoordinatorProtocol

extension ConverterCoordinator: CoordinatorProtocol {

    func start() {
        showConverterView()
    }

    private func showConverterView() {
        let viewController = screens.createConverterViewController(delegate: self)
        navigationController.pushViewController(viewController, animated: false)
    }

    private func showAlert(for type: AlertType) {
        let alert = screens.createAlertView(for: type)
        navigationController.visibleViewController?.present(alert, animated: true, completion: nil)
    }
}

extension ConverterCoordinator: ConverterViewModelDelegate {

    func displayAlert(for type: AlertType) {
        showAlert(for: type)
    }
}
