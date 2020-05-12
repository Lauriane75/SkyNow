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

class CityListViewController: UIViewController,
CLLocationManagerDelegate {

    // MARK: - Outlet

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var weatherChanelButton: UIButton!
    @IBOutlet weak var unitButton: UIButton!

    @IBOutlet weak var tableViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!

    // MARK: - Properties

    var viewModel: CityListViewModel!

    private var source = CityListDataSource()

    var animator: UIViewPropertyAnimator?

    var isCelsius = true

    let locationManager = CLLocationManager()

    // MARK: - View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        checkForAutorization()

        navigationBarCustom()
        elementCustom()

        tableView.delegate = source
        tableView.dataSource = source

        tapGestureRecognizerCustom()

        bind(to: viewModel)
        bind(to: source)

        viewModel.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        viewModel.viewWillAppear()
    }

    override func viewDidAppear(_ animated: Bool) {
        viewModel.viewDidAppear()
    }

    deinit {
        keyboardWillHide()
         NotificationCenter.default.removeObserver(self,
                                                   name: UIResponder.keyboardWillShowNotification,
                                                   object: nil)
         NotificationCenter.default.removeObserver(self,
                                                   name: UIResponder.keyboardWillHideNotification,
                                                   object: nil)
         NotificationCenter.default.removeObserver(self,
                                                   name: UIResponder.keyboardWillChangeFrameNotification,
                                                   object: nil)
     }

    // MARK: - Private Functions

    private func bind(to viewModel: CityListViewModel) {
        viewModel.visibleItems = { [weak self] weatherItems in
            DispatchQueue.main.async {
                self?.source.update(with: weatherItems)
                self?.tableView.reloadData()
            }
        }

        viewModel.isLoading = { [weak self] loadingState in
            DispatchQueue.main.async {
                guard let self = self else { return }
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
        viewModel.unitText = { [weak self] text in
            self?.unitButton.setTitle(text, for: .normal)
        }
        viewModel.cityText = { [weak self] text in
            self?.cityLabel.text = text
        }
        viewModel.cityPlaceHolder = { [weak self] text in
            self?.cityTextField.placeholder = text
        }
        viewModel.countryText = { [weak self] text in
            self?.countryLabel.text = text
        }
        viewModel.countryPlaceHolder = { [weak self] text in
            self?.countryTextField.placeholder = text
        }
        viewModel.addButtonText = { [weak self] text in
            DispatchQueue.main.async {
                self?.addButton.setTitle(text, for: .normal)
            }
        }
    }

    private func bind(to source: CityListDataSource) {
        source.selectedCity = viewModel.didSelectCity
        source.selectedCityToDelete = viewModel.didPressDeleteCity
    }

    // MARK: - View actions

    @IBAction func didPressAddButton(_ sender: Any) {
        guard let city = cityTextField.text?.lowercased() else { return }
        guard let country = countryTextField.text?.prefix(2).lowercased() else { return }

        viewModel.didPressAddCity(nameCity: city, country: country)
        hideStackView()
        guard animator != nil else { return }
        animator!.startAnimation()
    }

    @IBAction func didPressplusButton(_ sender: Any) {
        showStackView()
        guard animator != nil else { return }
        animator!.startAnimation()
    }

    @IBAction func didPressWeatherChanelButton(_ sender: Any) {
        viewModel.didPressWeatherChanelButton()
        viewModel.urlString = { text in
            guard let url = URL(string: text) else { return }
            UIApplication.shared.open(url)
         }
    }

    @IBAction func didPressUnitButton(_ sender: Any) {
        if isCelsius {
            isCelsius = false
            viewModel.didPressUnitButton(unit: isCelsius)
        } else {
            isCelsius = true
            viewModel.didPressUnitButton(unit: isCelsius)
        }
        viewModel.unitText = { [weak self] text in
            self?.unitButton.setTitle(text, for: .normal)
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        viewModel.didSendUserLocation(latitude: "\(locValue.latitude)", longitude: "\(locValue.longitude)")
    }

    // MARK: - Private Files

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
        animator = UIViewPropertyAnimator(duration: 1.0, dampingRatio: 1.0) {
            self.tableViewTopConstraint.constant = 40
            self.plusButton.isHidden = false
            self.stackView.isHidden = true
            UIView.animate(withDuration: 2.0) {
                self.view.layoutIfNeeded()
            }
        }
    }

    fileprivate func showStackView() {
        animator = UIViewPropertyAnimator(duration: 2.0, dampingRatio: 1.0) {
            self.tableViewTopConstraint.constant = 200
            self.plusButton.isHidden = true
            self.stackView.isHidden = false
            UIView.animate(withDuration: 1.0) {
                self.view.layoutIfNeeded()
            }
        }
    }

    /// HideKeyBoard from textField
    @objc private func hideKeyBoard() {
        cityTextField.resignFirstResponder()
        countryTextField.resignFirstResponder()
        addButton.resignFirstResponder()
        tableView.resignFirstResponder()
    }

    fileprivate func settingNotificationCenter() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillChange(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillChange(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillChange(notification:)),
                                               name: UIResponder.keyboardWillChangeFrameNotification,
                                               object: nil)
    }

    fileprivate func keyboardWillHide() {
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillShowNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillChangeFrameNotification,
                                                  object: nil)
    }

    fileprivate func tapGestureRecognizerCustom() {
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(hideKeyBoard))
        tap.cancelsTouchesInView = false

        view.addGestureRecognizer(tap)
    }

    @objc private func keyboardWillChange(notification: Notification) {
        guard let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height

        if notification.name == UIResponder.keyboardWillShowNotification ||
            notification.name == UIResponder.keyboardWillChangeFrameNotification {
            view.frame.origin.y = -(keyboardHeight/2)
        } else {
            view.frame.origin.y = 0
        }
    }

    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hideKeyBoard()
        return true
    }

    fileprivate func elementCustom() {
        addButton.layer.cornerRadius = 10
    }

    fileprivate func navigationBarCustom() {
        self.viewModel.navBarTitle = { [weak self] text in
            guard let self = self else { return }
            self.navigationItem.title = text
        }
        let textAttributes = [
                            NSAttributedString.Key.foregroundColor: UIColor.white,
                            NSAttributedString.Key.font: UIFont(name: "kailasa", size: 20)]
        guard let bar = navigationController?.navigationBar else { return }
        bar.tintColor = .white
        bar.titleTextAttributes = textAttributes as [NSAttributedString.Key: Any]
    }
}
