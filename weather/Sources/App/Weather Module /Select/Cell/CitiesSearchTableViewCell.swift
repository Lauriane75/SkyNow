//
//  CitiesSearchTableViewCell.swift
//  weather
//
//  Created by Lauriane Haydari on 14/05/2020.
//  Copyright © 2020 Lauriane Haydari. All rights reserved.
//

import UIKit

final class CitiesSearchTableViewCell: UITableViewCell {

    // MARK: - Outlets

    @IBOutlet weak var cityLabel: UILabel!

    // MARK: - Configure

    func configure(with visibleItem: CityData) {
        cityLabel.text = "\(visibleItem.name), \(visibleItem.country), \(visibleItem.state)"
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        cityLabel.text = nil
    }
}
