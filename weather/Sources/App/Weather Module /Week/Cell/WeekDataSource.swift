//
//  WeatherDataSource.swift
//  weather
//
//  Created by Lauriane Haydari on 12/02/2020.
//  Copyright © 2020 Lauriane Haydari. All rights reserved.
//

import UIKit

final class WeekDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {

    // MARK: Private properties

    private var items: [WeatherWeekItem] = []

    var selectedWeatherDay: ((Int) -> Void)?

    // MARK: Public function

    func update(with items: [WeatherWeekItem]) {
        self.items = items
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard items.count > indexPath.item else {
            return UITableViewCell() // Should be monitored
        }
        let visibleWeather = items[indexPath.item]
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherTableViewCell", for: indexPath) as! WeeekTableViewCell
        cell.configure(with: visibleWeather)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row < items.count else { return }
        selectedWeatherDay?(indexPath.row)
    }
}
