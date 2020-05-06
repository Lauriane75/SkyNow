//
//  DetailWeatherDayViewController.swift
//  weather
//
//  Created by Lauriane Haydari on 12/02/2020.
//  Copyright © 2020 Lauriane Haydari. All rights reserved.
//

import UIKit

class DetailDayViewController: UIViewController {

    // MARK: - Outlet

    @IBOutlet private weak var cityLabel: UILabel!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var descriptionLabel: UILabel!

    // MARK: - Properties

    var viewModel: DetailDayViewModel!

    private lazy var collectionDataSource = DetailDayCollectionDataSource()

    private var tableViewDatasource = DetailDayTableViewDataSource()

    var isCelsius = true

    // MARK: - View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = collectionDataSource
        tableView.delegate = tableViewDatasource
        tableView.dataSource = tableViewDatasource

        bind(to: viewModel)

        navigationBarCustom()

        viewModel.viewDidLoad()
    }

    // MARK: - Private Functions

    private func bind(to viewModel: DetailDayViewModel) {

        viewModel.visibleItems = { [weak self] items in
            guard let self = self else { return }
            self.navigationItem.title = items.first?.time.dayPlainTextFormat
            self.descriptionLabel.text = items.first?.description.capitalized
            self.cityLabel.text = items.first?.nameCity
            self.collectionDataSource.update(with: items)
            self.tableViewDatasource.update(with: items)
            self.collectionView.reloadData()
            self.tableView.reloadData()
        }
    }

    // MARK: - Private Files

    fileprivate func navigationBarCustom() {
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white,
                              NSAttributedString.Key.font: UIFont(name: "kailasa", size: 20)]
        guard let bar = navigationController?.navigationBar else { return }
        bar.titleTextAttributes = textAttributes as [NSAttributedString.Key: Any]
    }
}
