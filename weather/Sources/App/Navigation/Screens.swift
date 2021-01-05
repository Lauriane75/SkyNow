//
//  Screens.swift
//  weather
//
//  Created by Lauriane Haydari on 12/02/2020.
//  Copyright © 2020 Lauriane Haydari. All rights reserved.
//

import UIKit

final class Screens {

    let storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: Screens.self))

    private let context: Context

    init(context: Context) {
        self.context = context
    }
}

// MARK: - LaunchScreen

extension Screens {
    func createLaunchScreenViewController(delegate: LaunchScreenViewModelDelegate?) -> UIViewController {
        let viewController = storyboard.instantiateViewController(withIdentifier:
            "LaunchScreenViewController") as! LaunchScreenViewController
        let viewModel = LaunchScreenViewModel(delegate: delegate)
        viewController.viewModel = viewModel
        return viewController
    }
}

// MARK: - Select

extension Screens {
    func createSelectViewController(delegate: CityListViewModelDelegate?, cityId: String) -> UIViewController {
        let viewController = storyboard.instantiateViewController(withIdentifier:
            "CityListViewController") as! CityListViewController
        let repository = WeatherRepository(context: context)
        let viewModel = CityListViewModel(repository: repository,
                                          delegate: delegate, cityId: cityId)
        viewController.viewModel = viewModel
        return viewController
    }
}

// MARK: - Week

extension Screens {
    func createWeekViewController(delegate: WeekViewModelDelegate?, weatherListItem: WeatherListItem) -> UIViewController {
        let viewController = storyboard.instantiateViewController(withIdentifier:
            "WeekViewController") as! WeekViewController
        let repository = WeatherRepository(context: context)
        let viewModel = WeekViewModel(repository: repository,
                                      delegate: delegate, weatherListItem: weatherListItem)
        viewController.viewModel = viewModel
        return viewController
    }
}

// MARK: - Detail

extension Screens {
    func createWeatherDetailViewController(selectedWeatherItem: WeatherWeekItem,
                                           delegate: DetailDayViewModelDelegate?) -> UIViewController {
        let viewController = storyboard.instantiateViewController(withIdentifier:
            "DetailDayViewController") as! DetailDayViewController
        let repository = WeatherRepository(context: context)
        let viewModel = DetailDayViewModel(repository: repository,
                                           delegate: delegate,
                                           selectedWeatherItem: selectedWeatherItem)
        viewController.viewModel = viewModel
        return viewController
    }
}

// MARK: - Map

extension Screens {
    func createMapViewController(delegate: MapViewModelDelegate?) -> UIViewController {
        let viewController = storyboard.instantiateViewController(withIdentifier:
            "MapViewController") as! MapViewController
        let repository = WeatherRepository(context: context)
        let viewModel = MapViewModel(repository: repository, delegate: delegate)
        viewController.viewModel = viewModel
        return viewController
    }
}

// MARK: - Alert

extension Screens {
    func createAlertView(for type: AlertType) -> UIAlertController {
        let alert = Alert(type: type)
        let alertViewController = UIAlertController(title: alert.title,
                                                    message: alert.message,
                                                    preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertViewController.addAction(action)
        return alertViewController
    }
}
