//
//  LaunchScreenViewModel.swift
//  mvvmSample
//
//  Created by Lauriane Haydari on 10/12/2020.
//  Copyright © 2020 Lauriane Haydari. All rights reserved.
//

import Foundation

protocol LaunchScreenViewModelDelegate: AnyObject {
    func goToHomeView()
}

final class LaunchScreenViewModel {

    // MARK: - Properties

    private weak var delegate: LaunchScreenViewModelDelegate?

    // MARK: - Initializer

    init(delegate: LaunchScreenViewModelDelegate?) {
        self.delegate = delegate
    }

    // MARK: - Output

    var nameImageViewText: ((String) -> Void)?

    // MARK: - Input

    func viewDidLoad() {
        nameImageViewText?("skynow-logo")
    }

    func goToHomeView() {
        delegate?.goToHomeView()
    }

    // MARK: - Private Functions

}
