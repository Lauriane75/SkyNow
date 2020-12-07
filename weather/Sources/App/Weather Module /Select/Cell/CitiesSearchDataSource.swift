//
//  CitiesSearchDataSource.swift
//  weather
//
//  Created by Lauriane Haydari on 14/05/2020.
//  Copyright © 2020 Lauriane Haydari. All rights reserved.
//

import UIKit

final class CitiesSearchDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {

    // MARK: Private properties

    private var cityItems: [CityData] = []

    var selectedCity: ((Int) -> Void)?

    // MARK: Public function

    func update(with items: [CityData]) {
        self.cityItems = items
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard cityItems.count > indexPath.item else {
            return UITableViewCell() // Should be monitored
        }
        let visibleItem = cityItems[indexPath.item]
        let cell = tableView.dequeueReusableCell(withIdentifier: "CitiesSearchTableViewCell", for: indexPath) as! CitiesSearchTableViewCell
        cell.configure(with: visibleItem)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row < cityItems.count else { return }
        selectedCity?(indexPath.row)
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}
