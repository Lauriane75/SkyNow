//
//  ToPickerViewDataSource.swift
//  weather
//
//  Created by Lauriane Haydari on 17/05/2020.
//  Copyright © 2020 Lauriane Haydari. All rights reserved.
//

import UIKit

final class ToPickerViewDataSource: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {

    // MARK: - Properties

    var items: [String] = []

    var name: String = ""

    var frenchName: String = ""

    // MARK: - Public

    func update(with items: [String]) {
        self.items = items
    }

    var didSelectItemAt: ((Int) -> Void)?

    // MARK: - UIPickerViewDataSource

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {

        return items.count
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int,
                    forComponent component: Int, reusing view: UIView?) -> UIView {

        name = items[row]

        setItemName(index: row)

        var label = UILabel()

        customLabel(view, &label)

        label.text = frenchName

        return label
    }

    // MARK: - UIPickerViewDelegate

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        didSelectItemAt?(row)
    }

    // MARK: - Private Functions

    fileprivate func customLabel(_ view: UIView?, _ label: inout UILabel) {
        if let uiLabel = view {
            label = uiLabel as! UILabel
        }

        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .white
        label.textAlignment = .center
    }

    private func setItemName(index: Int) {
        if name == "EUR" {
            frenchName = "Euro €"
        }
        if name == "USD" {
            frenchName = "Dollar Américain $"
        }
        if name == "GBP" {
            frenchName = "Livre Sterling £"
        }
        if name == "JPY" {
            frenchName = "Yen ¥"
        }
    }
}
