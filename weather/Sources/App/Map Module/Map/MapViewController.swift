//
//  SelectCityViewController.swift
//  weather
//
//  Created by Lauriane Haydari on 12/02/2020.
//  Copyright © 2020 Lauriane Haydari. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UIGestureRecognizerDelegate {

    // MARK: - Outlet

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var addButton: UIButton!

    // MARK: - Properties

    var viewModel: MapViewModel!
    let locationManager = CLLocationManager()
    var userLocation: [Location] = []

    // MARK: - View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapViewCustom()

        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        gestureRecognizer.delegate = self
        mapView.addGestureRecognizer(gestureRecognizer)

        setAlertView()

        viewModel.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        viewModel.viewWillAppear()
        bind(to: viewModel)
    }

    // MARK: - Private Functions

    private func setAlertView() {
        let gray = UIColor(named: "gray-skynow")?.cgColor
        let blue = UIColor(named: "blue-skynow")?.cgColor
        alertView.layer.cornerRadius = 15
        alertView.layer.backgroundColor = gray
        cancelButton.layer.cornerRadius = 15
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = UIColor.black.cgColor
        addButton.layer.cornerRadius = 15
        addButton.layer.borderWidth = 1
        addButton.layer.borderColor = blue
    }

    private func bind(to viewModel: MapViewModel) {
        viewModel.viewState = { [weak self] state in
            self?.alertView.isHidden = state
        }
        viewModel.addButtonText = { [weak self] text in
            self?.addButton.setTitle(text, for: .normal)
        }
        viewModel.cancelButtonText = { [weak self] text in
            self?.cancelButton.setTitle(text, for: .normal)
        }
        viewModel.labelText = { [weak self] text in
            self?.alertLabel.text = text
        }
    }

    // MARK: - Private Files

    fileprivate func mapViewCustom() {
        mapView.register(PointAnnotation.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)

        let poi = MKPointAnnotation()
        poi.coordinate = CLLocationCoordinate2D(latitude: 48.866667, longitude: 2.333333)
        mapView.addAnnotation(poi)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        let locationUser = Location(latitude: locValue.latitude, longitude: locValue.longitude)

        userLocation.append(locationUser)
        if let userLocation = userLocation.first {
            mapView.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: userLocation.latitude, longitude: userLocation.longitude), span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)), animated: false)
        }
        mapView.showsUserLocation = true
    }

    @objc func handleTap(gestureRecognizer: UILongPressGestureRecognizer) {

        let location = gestureRecognizer.location(in: mapView)
        let coordinate = mapView.convert(location, toCoordinateFrom: mapView)

        let lat = coordinate.latitude
        let long = coordinate.longitude
        viewModel.findCity(lat: String(lat), long: String(long))
    }

    // MARK: - View actions

    @IBAction func didPressCancelButton(_ sender: Any) {
        viewModel.didPressCancelButton()
    }

    @IBAction func didPressAddButton(_ sender: Any) {
        viewModel.didPressAddButton()
    }

}
