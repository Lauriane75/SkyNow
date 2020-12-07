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

class MainCoordinator {

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

extension MainCoordinator {

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
        navController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navController.navigationBar.shadowImage = UIImage()
        navController.navigationBar.tintColor = UIColor.white
        UITabBar.appearance().tintColor = .lightGray
        UITabBar.appearance().backgroundColor = .clear

        navController.tabBarItem = UITabBarItem(title: title, image: image, selectedImage: nil)

        return navController
    }
}
