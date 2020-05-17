//
//  ConverterViewController.swift
//  weather
//
//  Created by Lauriane Haydari on 15/05/2020.
//  Copyright © 2020 Lauriane Haydari. All rights reserved.
//

import UIKit

class ConverterViewController: UIViewController {

    // MARK: - Outlets

    @IBOutlet weak var amountLabel: UILabel!

    @IBOutlet weak var textField: UITextField!

    @IBOutlet weak var fromLabel: UILabel!

    @IBOutlet weak var fromPickerView: UIPickerView!

    @IBOutlet weak var fromRateLabel: UILabel!

    @IBOutlet weak var toLabel: UILabel!

    @IBOutlet weak var toPickerView: UIPickerView!

    @IBOutlet weak var toRateLabel: UILabel!

    @IBOutlet weak var resultLabel: UILabel!

    // MARK: - Properties

    var viewModel: ConverterViewModel!

    private var fromDataSource = FromPickerViewDataSource()
    private var toDataSource = ToPickerViewDataSource()

    // MARK: - View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        elementCustom()

        fromPickerView.dataSource = fromDataSource
        fromPickerView.delegate = fromDataSource

        toPickerView.dataSource = toDataSource
        toPickerView.delegate = toDataSource

        bind(to: viewModel)
        bind(to: fromDataSource)
        bind(to: toDataSource)

        viewModel.viewDidLoad()
    }

    // MARK: - Private Functions

    private func bind(to viewModel: ConverterViewModel) {
        viewModel.titleLabel = { [weak self] text in
            self?.amountLabel.text = text
        }
        viewModel.initialValuetextField = { [weak self] text in
            DispatchQueue.main.async {
                self?.textField.text = text
            }
        }
        viewModel.placeHolderTextField = { [weak self] text in
            DispatchQueue.main.async {
                self?.textField.placeholder = text
            }
        }
        viewModel.visibleRequestCurrencyName = { [weak self] rates in
            DispatchQueue.main.async {
                self?.fromDataSource.update(with: rates)
                self?.fromPickerView.reloadAllComponents()
            }
        }
        viewModel.visibleResultCurrencyName = { [weak self] rates in
            DispatchQueue.main.async {
                self?.toDataSource.update(with: rates)
                self?.toPickerView.reloadAllComponents()
            }
        }
        viewModel.selectedRequestRateValue = { [weak self] text in
            DispatchQueue.main.async {
                self?.fromRateLabel.text = text
            }
        }
        viewModel.selectedResultRateValue = { [weak self] text in
            DispatchQueue.main.async {
                self?.toRateLabel.text = text
            }
        }
        viewModel.resultText = { [weak self] text in
            DispatchQueue.main.async {
                self?.resultLabel.text = text
            }
        }
    }

    private func bind(to dataSource: FromPickerViewDataSource) {
        dataSource.didSelectItemAt = viewModel.didSelectRequestRate
    }

    private func bind(to dataSource: ToPickerViewDataSource) {
        dataSource.didSelectItemAt = viewModel.didSelectResultRate
    }

    // MARK: - View actions

    @IBAction func didTypeValueInTextField(_ sender: Any) {
        guard textField.text != nil else { return }
        guard let textValue = textField.text else {
            return
        }
        viewModel.didTapInitialValuetextField(valueFromTextField: Double(textValue)!)
    }

    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        textField.resignFirstResponder()

    }

    // MARK: - Fileprivate Functions

    fileprivate func elementCustom() {
        resultLabel.layer.cornerRadius = 20
        fromPickerView.layer.cornerRadius = 20
        toPickerView.layer.cornerRadius = 20
        textField.attributedPlaceholder = NSAttributedString(string: "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.green ])
    }
}
