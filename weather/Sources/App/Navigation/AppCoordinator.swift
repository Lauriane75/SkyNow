//
//  AppCoordinator.swift
//  weather
//
//  Created by Lauriane Haydari on 12/02/2020.
//  Copyright © 2020 Lauriane Haydari. All rights reserved.
//

import UIKit

class AppCoordinator {

    // MARK: - Properties

    private unowned var appDelegate: AppDelegate

    private var screens: Screens

    private var tabBarCoordinator: TabBarCoordinator

    // MARK: - Initializer

    init(appDelegate: AppDelegate, screens: Screens, tabBarCoordinator: TabBarCoordinator) {
        self.appDelegate = appDelegate
        self.screens = screens
        self.tabBarCoordinator = tabBarCoordinator
    }
}

// MARK: - CoordinatorProtocol

extension AppCoordinator {

    // MARK: - Start

    func start() {
        let tabBarController = tabBarCoordinator.tabBarController

        appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
        appDelegate.window!.rootViewController = tabBarController
        appDelegate.window!.makeKeyAndVisible()
        tabBarController.viewControllers = []

        // to stop running while testing
        if ProcessInfo.processInfo.environment["IS_RUNNING_UNIT_TESTS"] == "YES" {
            return
        }
        tabBarCoordinator.createTabBar(tabBarController)
    }
}
