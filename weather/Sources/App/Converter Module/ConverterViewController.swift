//
//  ConverterViewController.swift
//  weather
//
//  Created by Lauriane Haydari on 15/05/2020.
//  Copyright © 2020 Lauriane Haydari. All rights reserved.
//

import UIKit

class ConverterViewController: UIViewController {

    // MARK: - Properties

    var viewModel: ConverterViewModel!

    // MARK: - View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.viewDidLoad()
    }
}
