//
//  LaunchScreenViewController.swift
//  mvvmSample
//
//  Created by Lauriane Haydari on 10/12/2020.
//  Copyright © 2020 Lauriane Haydari. All rights reserved.
//

import UIKit

class LaunchScreenViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!

    // MARK: - Properties

    var viewModel: LaunchScreenViewModel!

    // MARK: - Outlets

    // MARK: - View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        bind(to: viewModel)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        animate()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        DispatchQueue.main.asyncAfter(deadline: .now()+1, execute: {
            self.viewModel.goToHomeView()
        })
    }

    // MARK: - Private Functions

    private func bind(to viewModel: LaunchScreenViewModel) {
        viewModel.nameImageViewText = { [weak self] text in
            self?.imageView.image = UIImage(named: text)
        }
    }

    private func animate() {
        UIView.animate(withDuration: 1, animations: {
            let size = self.view.frame.size.width * 2.5
            let diffX = size - self.view.frame.size.width
            let diffY = self.view.frame.size.height - size

            self.imageView.frame = CGRect(
                x: -(diffX/2),
                y: diffY/2,
                width: size,
                height: size
            )
            self.imageView.alpha = 0
        })

        UIView.animate(withDuration: 1.5, animations: {
            self.imageView.alpha = 0
        })
    }
}
