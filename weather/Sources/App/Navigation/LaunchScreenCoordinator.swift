//
//  LaunchScreenCoordinator.swift
//  weather
//
//  Created by Lauriane Haydari on 10/12/2020.
//  Copyright © 2020 Lauriane Haydari. All rights reserved.
//

import UIKit

final class LaunchScreenCoordinator {

    // MARK: - Properties

    private let presenter: UIWindow

    private let navigationController: UINavigationController

    private let screens: Screens

    var coordinator: AppCoordinator?

    private unowned var appDelegate: AppDelegate

    // MARK: - Initializer

    init(presenter: UIWindow, context: Context, appDelegate: AppDelegate) {
        self.presenter = presenter
        self.screens = Screens(context: context)
        self.navigationController = UINavigationController()
        self.appDelegate = appDelegate
    }

    // MARK: - Coordinator

    func start() {
        let navBar = navigationController.navigationBar
        navBar.setBackgroundImage(UIImage(), for: .default)
        navBar.shadowImage = UIImage()
        navBar.tintColor = .white
        navBar.barTintColor = .clear
        presenter.rootViewController = navigationController
        showLaunchScreenAnimate()
    }

    private func showLaunchScreenAnimate() {
        let viewController = screens.createLaunchScreenViewController(delegate: self)
        viewController.modalTransitionStyle = .crossDissolve
        navigationController.pushViewController(viewController, animated: false)
    }

    private func showHomeView() {
        let tabBarCoordinator = TabBarCoordinator(screens: screens)
        coordinator = AppCoordinator(appDelegate: appDelegate, screens: screens, tabBarCoordinator: tabBarCoordinator)
        coordinator?.start()
    }
}

extension LaunchScreenCoordinator: LaunchScreenViewModelDelegate {
    func goToHomeView() {
        showHomeView()
    }
}
