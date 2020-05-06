//
//  AppDelegate.swift
//  weather
//
//  Created by Lauriane Haydari on 12/02/2020.
//  Copyright © 2020 Lauriane Haydari. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator?
    var context: Context!

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let client = HTTPClient()
        let stack = CoreDataStack(modelName: "weather",
                                  type: .prod)
        context = Context(client: client, stack: stack)
        let screens = Screens(context: context)
        let mainCoordinator = MainCoordinator(screens: screens)
        appCoordinator = AppCoordinator(appDelegate: self,
        context: context,
        screens: screens, mainCoordinator: mainCoordinator)
        appCoordinator?.start()
        return true
    }
}
