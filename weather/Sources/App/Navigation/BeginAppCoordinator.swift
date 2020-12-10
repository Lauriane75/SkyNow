//
//  BeginAppCoordinator.swift
//  weather
//
//  Created by Lauriane Haydari on 10/12/2020.
//  Copyright © 2020 Lauriane Haydari. All rights reserved.
//

import UIKit

class BeginAppCoordinator {

    // MARK: - Properties

    private var presenter: UIWindow

    private let context: Context

    private var launScreenCoordinator: LaunchScreenCoordinator?

    private unowned var appDelegate: AppDelegate

    // MARK: - Initializer

    init(presenter: UIWindow, context: Context, appDelegate: AppDelegate) {
        self.presenter = presenter
        self.context = context
        self.appDelegate = appDelegate
    }
}

// MARK: - CoordinatorProtocol

extension BeginAppCoordinator {

    // MARK: - Start

    func start() {
        presenter.rootViewController = UIViewController()

        if ProcessInfo.processInfo.environment["IS_RUNNING_UNIT_TESTS"] == "YES" {
            return
        }
        showLaunchScreenAnimate()
    }

    // MARK: - Create viewControllers

    private func showLaunchScreenAnimate() {
        launScreenCoordinator = LaunchScreenCoordinator(presenter: presenter, context: context, appDelegate: appDelegate)
        launScreenCoordinator?.start()
    }
}
