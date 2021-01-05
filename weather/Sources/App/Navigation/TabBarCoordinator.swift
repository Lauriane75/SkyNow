//
//  CoordinatorProtocol.swift
//  weather
//
//  Created by Lauriane Haydari on 02/04/2020.
//  Copyright © 2020 Lauriane Haydari. All rights reserved.
//

import UIKit

protocol CoordinatorProtocol {
    func start()
}

class TabBarCoordinator {

    // MARK: - Properties

    private var screens: Screens

    let tabBarController = UITabBarController()

    var coordinators: [CoordinatorProtocol] = []

    // MARK: - Initializer

    init(screens: Screens) {
        self.screens = screens
    }
}

// MARK: - Creating tabs

extension TabBarCoordinator {

    func createTabBar(_ tabBarController: UITabBarController) {
        let weatherItem = createNavigationController(withTitle: "Weather", image: UIImage(systemName: "sun.min.fill")!)
        let mapItem = createNavigationController(withTitle: "Map", image: UIImage(systemName: "mappin.and.ellipse")!)

        let weatherCoordinator = WeatherCoordinator(presenter: weatherItem, screens: screens)
        coordinators.append(weatherCoordinator)
        weatherCoordinator.start()

        let mapCoordinator = MapCoordinator(presenter: mapItem, screens: screens)
        coordinators.append(mapCoordinator)
        mapCoordinator.start()

        let rootViewControllers = [weatherItem, mapItem]
        tabBarController.setViewControllers(rootViewControllers, animated: false)
    }

    func createNavigationController(withTitle title: String, image: UIImage) -> UINavigationController {
        let navController = UINavigationController()
        let navBar = navController.navigationBar
        navBar.setBackgroundImage(UIImage(), for: .default)
        navBar.shadowImage = UIImage()
        navBar.tintColor = UIColor.white

        navController.tabBarItem = UITabBarItem(title: title, image: image, selectedImage: nil)

        return navController
    }
}
