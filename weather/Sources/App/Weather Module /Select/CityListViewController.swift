//
//  CityListViewController.swift
//  weather
//
//  Created by Lauriane Haydari on 02/03/2020.
//  Copyright © 2020 Lauriane Haydari. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import AVKit

class CityListViewController: UIViewController,
CLLocationManagerDelegate {

    // MARK: - Outlet

    @IBOutlet weak var videoBackgroundUIView: UIView!

    @IBOutlet weak var stackView: UIStackView!

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    @IBOutlet weak var weatherChanelButton: UIButton!

    @IBOutlet weak var unitButton: UIButton!

    @IBOutlet weak var tableViewTopConstraint: NSLayoutConstraint!

    @IBOutlet weak var searchTableView: UITableView!

    @IBOutlet weak var tableView: UITableView!

    // MARK: - Properties

    var viewModel: CityListViewModel!

    private var videoPlayer: AVPlayer?
    private var videoPlayerLayer: AVPlayerLayer?

    var playerLooper: AVPlayerLooper?
    var queuePlayer: AVQueuePlayer?

    private var source = CityListDataSource()

    private var searchSource = CitiesSearchDataSource()

    private var isCelsius = true

    private var urlString: String?

    private let locationManager = CLLocationManager()

    private lazy var searchController = UISearchController(searchResultsController: nil)

    // MARK: - View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpBackgroundVideo()

        checkForAutorization()

        navigationItem.searchController = searchController

        tableView.delegate = source
        tableView.dataSource = source

        searchTableView.delegate = searchSource
        searchTableView.dataSource = searchSource

        bind(to: viewModel)
        bind(to: source)
        bind(to: searchSource)

        viewModel.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchBarCustom()
        viewModel.viewWillAppear()
    }

    override func viewDidAppear(_ animated: Bool) {
        viewModel.viewDidAppear()
        AppStoreReviewManager .requestReviewIfAppropriate()
    }

    // MARK: - Private Functions

    private func bind(to viewModel: CityListViewModel) {
        viewModel.visibleItems = { [weak self] weatherItems in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.source.update(with: weatherItems)
                self.tableView.reloadData()
            }
        }

        viewModel.isLoading = { [weak self] loadingState in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch loadingState {
                case true:
                    self.tableView.isHidden = true
                    self.activityIndicator.isHidden = false
                    self.activityIndicator.startAnimating()
                case false:
                    self.tableView.isHidden = false
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                }
            }
        }

        viewModel.cityData = { [weak self] items in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.searchSource.update(with: items)
                self.searchTableView.reloadData()
            }
        }
        viewModel.urlString = { [weak self] text in
            self?.urlString = text
        }
        viewModel.unitText = { [weak self] text in
            self?.unitButton.setTitle(text, for: .normal)
        }
        viewModel.tableViewisHidden = { [weak self] state in
            self?.tableView.isHidden = state
            if !state {
                self?.searchController.searchBar.endEditing(true)
            }
        }
        viewModel.stackViewisHidden = { [weak self] state in
            self?.stackView.isHidden = state
        }
        viewModel.tableViewTopConstraint = { [weak self] float in
            self?.tableViewTopConstraint.constant = CGFloat(float)
        }
    }

    private func bind(to source: CityListDataSource) {
        source.selectedCity = viewModel.didSelectWeatherCityInList
        source.selectedCityToDelete = viewModel.didPressDeleteCity
    }

    private func bind(to source: CitiesSearchDataSource) {
        searchSource.selectedCity = viewModel.didSelectCityInSearchBar
    }

    // MARK: - View actions

    @IBAction func didPressWeatherChanelButton(_ sender: Any) {
        guard urlString != nil else { return }
        guard let url = URL(string: urlString!) else { return }
        UIApplication.shared.open(url)
    }

    @IBAction func didPressUnitButton(_ sender: Any) {
        if isCelsius { isCelsius = false
            viewModel.didPressUnitButton(unit: isCelsius)
        } else { isCelsius = true
            viewModel.didPressUnitButton(unit: isCelsius)
        }
        viewModel.unitText = { [weak self] text in
            self?.unitButton.setTitle(text, for: .normal)
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        viewModel.didSendUserLocation(latitude: "\(locValue.latitude)", longitude: "\(locValue.longitude)")
        viewModel.viewWillAppear()
    }

    // MARK: - Private Files

    fileprivate func searchBarCustom() {
        let loopIcon = searchController.searchBar.searchTextField.leftView
        loopIcon?.tintColor = UIColor.white
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.tintColor = UIColor.white
        searchController.searchBar.searchTextField.textColor = UIColor.white
        searchController.searchBar.isTranslucent = true
        searchController.searchBar.searchTextField.backgroundColor = UIColor.gray.withAlphaComponent(0.5)

        viewModel.searchViewPlaceholderText = { [weak self] text in
            self!.searchController.searchBar.placeholder = text
        }
    }

    fileprivate func checkForAutorization() {
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }

    fileprivate func hideStackView() {
        tableViewTopConstraint.constant = view.frame.minY
        stackView.isHidden = true
        tableView.isHidden = false
    }

    fileprivate func showStackView() {
        tableViewTopConstraint.constant = view.frame.height
        stackView.isHidden = false
        tableView.isHidden = true
    }

    fileprivate func setUpBackgroundVideo() {
        let url = viewModel.setUpVideo()
        guard url != nil else { return }
        let item = AVPlayerItem(url: url!)
        videoPlayer = AVPlayer(playerItem: item)
        videoPlayerLayer = AVPlayerLayer(player: videoPlayer!)
        // adjust the size and frame
        videoPlayerLayer?.frame = CGRect(x: 0,
                                         y: 0,
                                         width: self.view.frame.size.width,
                                         height: self.view.frame.size.height)

        // add it to the view and play it
        guard videoPlayer != nil else { return }
        videoPlayer!.actionAtItemEnd = AVPlayer.ActionAtItemEnd.none
        videoPlayer!.playImmediately(atRate: 1)
        videoPlayerLayer?.videoGravity = .resizeAspectFill
        videoBackgroundUIView.layer.insertSublayer(videoPlayerLayer!, at: 0)

        NotificationCenter.default.addObserver(self, selector: #selector(playerItemEnded), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: videoPlayer!.currentItem)
        videoPlayer!.seek(to: CMTime.zero)
        videoPlayer!.play()
        self.videoPlayer?.isMuted = true
    }

    @objc func playerItemEnded() {
        videoPlayer!.seek(to: CMTime.zero)
    }
}

// MARK: - SearchBar

extension CityListViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        showStackView()
        viewModel.getCities()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        hideStackView()
        guard let text = searchController.searchBar.text?.lowercased() else { return }
        viewModel.didSearchCities(with: text, numberOfLetters: text.count)
        DispatchQueue.main.async {
            self.searchController.isActive = false
        }
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        showStackView()
        guard let text = searchController.searchBar.text?.lowercased() else { return }
        viewModel.didSearchCities(with: text, numberOfLetters: text.count)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        hideStackView()
    }
}
