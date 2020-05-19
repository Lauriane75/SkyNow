//
//  ConverterViewmodel.swift
//  weather
//
//  Created by Lauriane Haydari on 15/05/2020.
//  Copyright © 2020 Lauriane Haydari. All rights reserved.
//

import Foundation

protocol ConverterViewModelDelegate: class {
    func displayAlert(for type: AlertType)
}

final class ConverterViewModel {

    // MARK: - Properties

    private let repository: ConverterRepositoryType

    private weak var delegate: ConverterViewModelDelegate?

    var fromPickerViewRateValue: Double = 1
    var toPickerViewRateValue: Double = 1
    var fromPickerViewCurrencyText: String = ""
    var toPickerViewCurrencyText: String = ""

    private var ratesTo: [Rate] = [] {
        didSet {
            let keys: [String] = ratesTo.map { $0.key }.sorted(by: { $0 < $1 })
            self.toRateText?(keys)
        }
    }

    private var ratesFrom: [Rate] = [] {
        didSet {
            let keys: [String] = ratesFrom.map { $0.key }.sorted(by: { $0 < $1 })
            self.fromRateText?(keys)
        }
    }

    private var valueToConvert: Double = 0 {
        didSet {
            initialValuetextField?("\(valueToConvert)")
        }
    }

    private var result = "" {
        didSet {
            resultText?(result)
        }
    }

    // MARK: - Initializer

    init(repository: ConverterRepositoryType, delegate: ConverterViewModelDelegate?) {
        self.repository = repository
        self.delegate = delegate
    }

    // MARK: - Outputs

    var navBarText: ((String) -> Void)?

    var titleLabel: ((String) -> Void)?

    var resultText: ((String) -> Void)?

    var fromRateText: (([String]) -> Void)?

    var toRateText: (([String]) -> Void)?

    var fromRateValue: ((String) -> Void)?

    var toRateValue: ((String) -> Void)?

    var initialValuetextField: ((String) -> Void)?

    var placeHolderTextField: ((String) -> Void)?

    // MARK: - Inputs

    func viewDidLoad() {
        self.navBarText?("Converter")
        self.titleLabel?("Enter a value and swipe your currency money")
        self.resultText?("0.0 €")
        self.placeHolderTextField?("Example: 100")
        repository.getCurrency(callback: { (currency) in
            switch currency {
            case .success(value: let currencyItem):
                self.initRatesFrom(from: currencyItem)
                self.initRatesTo(to: currencyItem)
                self.didSelectRateFrom(at: 0)
                self.didSelectRateTo(at: 0)
            case .error:
                self.delegate?.displayAlert(for: .errorService)
            }
        }, onError: { [weak self] _ in
            guard let self = self else { return }
            self.delegate?.displayAlert(for: .errorService)
        })
    }

    func didPressvalidateValue(valueFromTextField: Double) {
        let value = valueFromTextField
        valueToConvert = value
    }

    func didSelectRateFrom(at index: Int) {
        guard index < ratesFrom.count else { return }
        let rate = ratesFrom[index]

        fromRateValue?("Conversion rate : \(Double(round(100*rate.value)/100))")

        fromPickerViewRateValue = rate.value
        fromPickerViewCurrencyText = rate.key

        convert()
    }

    func didSelectRateTo(at index: Int) {
        guard index < ratesTo.count else { return }
        let rate = ratesTo[index]

        toRateValue?("Conversion rate : \(Double(round(100*rate.value)/100))")

        toPickerViewRateValue = rate.value
        toPickerViewCurrencyText = rate.key

        convert()
    }

    // MARK: - Private Functions

    private func initRatesFrom(from currency: Currency) {
        let sorted = currency.rates.sorted { $0.key < $1.key }
        ratesFrom = sorted.map { Rate(key: $0.key, value: $0.value) }
        if let value = ratesFrom.first?.value {
            fromRateValue?("\(Double(round(100*value)/100))")
        }
    }

    private func initRatesTo(to currency: Currency) {
        let sorted = currency.rates.sorted { $0.key < $1.key }
        ratesTo = sorted.map { Rate(key: $0.key, value: $0.value) }
        if let value = ratesTo.first?.value {
            toRateValue?("\(Double(round(100*value)/100))")
        }
    }

    private func convertedValue(valueToConvert: Double, topRateValue: Double, bottomRateValue: Double) -> Double {
        return (valueToConvert / topRateValue) * bottomRateValue
    }

    // MARK: - Private Files

    fileprivate func convert() {
        let convertedValueResult = (Double(round(100 * convertedValue(valueToConvert: valueToConvert,
                                                  topRateValue: fromPickerViewRateValue,
                                                  bottomRateValue: toPickerViewRateValue) / 100)))

        if toPickerViewCurrencyText == "EUR" && toPickerViewRateValue == 1 {
            result = ("\(convertedValueResult) €")
        }
        if toPickerViewCurrencyText == "USD" {
            result = ("$ \(convertedValueResult)")
        }
        if toPickerViewCurrencyText == "GBP" {
            result = ("£ \(convertedValueResult)")
        }
        if toPickerViewCurrencyText == "JPY" {
            result = ("\(convertedValueResult) ¥")
        }
    }
}
