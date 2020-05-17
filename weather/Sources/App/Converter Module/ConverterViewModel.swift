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

    var valueOfRequestPickerView: Double = 1
    var valueOfResultPickerView: Double = 1
    var currencyOfRequestPickerView: String = ""
    var currencyOfResultPickerView: String = ""

    private var resultRates: [Rate] = [] {
        didSet {
            let keys: [String] = resultRates.map { $0.key }.sorted(by: { $0 < $1 })
            self.visibleResultCurrencyName?(keys)
        }
    }

    private var requestRates: [Rate] = [] {
        didSet {
            let keys: [String] = requestRates.map { $0.key }.sorted(by: { $0 < $1 })
            self.visibleRequestCurrencyName?(keys)
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

     var titleLabel: ((String) -> Void)?

     var resultText: ((String) -> Void)?

     var visibleRequestCurrencyName: (([String]) -> Void)?

     var visibleResultCurrencyName: (([String]) -> Void)?

     var selectedRequestRateValue: ((String) -> Void)?

     var selectedResultRateValue: ((String) -> Void)?

     var initialValuetextField: ((String) -> Void)?

     var placeHolderTextField: ((String) -> Void)?

     // MARK: - Inputs

    func viewDidLoad() {
        self.titleLabel?("Enter a value and swipe your currency money")
        self.resultText?("0.0 €")
        self.placeHolderTextField?("Example: 100")
        repository.getCurrency(callback: { (currency) in
            switch currency {
            case .success(value: let currencyItem):
                self.initRequestRates(from: currencyItem)
                self.initResultRates(from: currencyItem)
                self.didSelectRequestRate(at: 0)
                self.didSelectResultRate(at: 0)
            case .error:
                self.delegate?.displayAlert(for: .errorService)
            }
        }, onError: { [weak self] _ in
            guard let self = self else { return }
            self.delegate?.displayAlert(for: .errorService)
        })
    }

     func didTapInitialValuetextField(valueFromTextField: Double) {
         let value = valueFromTextField
         valueToConvert = value
     }

     func didSelectRequestRate(at index: Int) {
         guard index < requestRates.count else { return }
         let rate = requestRates[index]

         selectedRequestRateValue?("Taux de conversion : \(Double(round(100*rate.value)/100))")

         valueOfRequestPickerView = rate.value
         currencyOfRequestPickerView = rate.key

         convert()
     }

     func didSelectResultRate(at index: Int) {
         guard index < resultRates.count else { return }
         let rate = resultRates[index]

         selectedResultRateValue?("Taux de conversion : \(Double(round(100*rate.value)/100))")

         valueOfResultPickerView = rate.value
         currencyOfResultPickerView = rate.key

         convert()
     }

     // MARK: - Private Functions

     private func initRequestRates(from currency: Currency) {
         let sorted = currency.rates.sorted { $0.key < $1.key }
         requestRates = sorted.map { Rate(key: $0.key, value: $0.value) }
         if let value = requestRates.first?.value {
             selectedRequestRateValue?("\(Double(round(100*value)/100))")
         }
     }

     private func initResultRates(from currency: Currency) {
         let sorted = currency.rates.sorted { $0.key < $1.key }
         resultRates = sorted.map { Rate(key: $0.key, value: $0.value) }
         if let value = resultRates.first?.value {
             selectedResultRateValue?("\(Double(round(100*value)/100))")
         }
     }

     private func convertedValue(valueToConvert: Double, topRateValue: Double, bottomRateValue: Double) -> Double {
         return (valueToConvert / topRateValue) * bottomRateValue
     }

     // MARK: - Private Files

     fileprivate func convert() {
         let convertedValueResult = convertedValue(valueToConvert: valueToConvert,
                                                   topRateValue: valueOfRequestPickerView,
                                                   bottomRateValue: valueOfResultPickerView)
         if currencyOfResultPickerView == "EUR" && valueOfResultPickerView == 1 {
             result = ("\(Double(round(100*convertedValueResult)/100)) €")
         }
         if currencyOfResultPickerView == "USD" {
             result = ("$ \(Double(round(100*convertedValueResult)/100))")
         }
         if currencyOfResultPickerView == "GBP" {
             result = ("£ \(Double(round(100*convertedValueResult)/100))")
         }
         if currencyOfResultPickerView == "JPY" {
             result = ("\(Double(round(100*convertedValueResult)/100)) ¥")
         }
     }
}
