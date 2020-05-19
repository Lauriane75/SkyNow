//
//  ConverterViewController.swift
//  weather
//
//  Created by Lauriane Haydari on 15/05/2020.
//  Copyright © 2020 Lauriane Haydari. All rights reserved.
//

import UIKit

class ConverterViewController: UIViewController, UITextFieldDelegate {

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
        tapGestureRecognizer()

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
        viewModel.navBarText = { [weak self] text in
            self?.navigationController?.navigationItem.title = text
        }
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
        viewModel.fromRateText = { [weak self] rates in
            DispatchQueue.main.async {
                self?.fromDataSource.update(with: rates)
                self?.fromPickerView.reloadAllComponents()
            }
        }
        viewModel.toRateText = { [weak self] rates in
            DispatchQueue.main.async {
                self?.toDataSource.update(with: rates)
                self?.toPickerView.reloadAllComponents()
            }
        }
        viewModel.fromRateValue = { [weak self] text in
            DispatchQueue.main.async {
                self?.fromRateLabel.text = text
            }
        }
        viewModel.toRateValue = { [weak self] text in
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
        dataSource.didSelectItemAt = viewModel.didSelectRateFrom
    }

    private func bind(to dataSource: ToPickerViewDataSource) {
        dataSource.didSelectItemAt = viewModel.didSelectRateTo
    }

    // MARK: - View actions

    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        textField.resignFirstResponder()
    }

    @IBAction func didPressValidateValueButton(_ sender: Any) {
        guard let textValue = textField.text else { return }
        viewModel.didPressvalidateValue(valueFromTextField: Double(textValue)!)
    }

    // MARK: - Fileprivate Functions

    fileprivate func tapGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
    }

    fileprivate func elementCustom() {
        fromPickerView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
        toPickerView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
        resultLabel.layer.cornerRadius = 20
        fromPickerView.layer.cornerRadius = 20
        toPickerView.layer.cornerRadius = 20
        textField.attributedPlaceholder = NSAttributedString(string: "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.green ])
    }
}
