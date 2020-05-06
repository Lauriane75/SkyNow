//
//  CityListDataSource.swift
//  weather
//
//  Created by Lauriane Haydari on 02/03/2020.
//  Copyright © 2020 Lauriane Haydari. All rights reserved.
//

import UIKit

final class CityListDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {

    // MARK: Private properties

    private var weahterItems: [WeatherListItem] = []

    var selectedCity: ((Int) -> Void)?

    var selectedCityToDelete: ((Int) -> Void)?

    // MARK: Public function

    func update(with items: [WeatherListItem]) {
        self.weahterItems = items
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weahterItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard weahterItems.count > indexPath.item else {
            return UITableViewCell() // Should be monitored
        }
        let visibleWeather = weahterItems[indexPath.item]
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityListTableViewCell", for: indexPath) as! CityListTableViewCell
        cell.configure(with: visibleWeather)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row < weahterItems.count else { return }
        selectedCity?(indexPath.row)
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard indexPath.row < weahterItems.count else { return }
        weahterItems.remove(at: indexPath.row)
        selectedCityToDelete?(indexPath.row)
    }
}
