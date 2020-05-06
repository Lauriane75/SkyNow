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

class MapViewController: UIViewController, CLLocationManagerDelegate {

    // MARK: - Outlet

    @IBOutlet weak var mapView: MKMapView!

    // MARK: - Properties

    var viewModel: MapViewModel!
    let locationManager = CLLocationManager()
    var userLocation: [Location] = []

    // MARK: - View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        checkForAutorization()
        navigationBarCustom()
        elementCustom()
        mapViewCustom()
        bind(to: viewModel)
        viewModel.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        viewModel.viewWillAppear()
    }

    deinit {
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

    private func bind(to viewModel: MapViewModel) {
//        viewModel.titleText = { [weak self] text in
//            self?.titleLabel.text = text
//        }
    }

    // MARK: - View actions

    // MARK: - Private Files

    fileprivate func navigationBarCustom() {
        guard let bar = navigationController?.navigationBar else { return }
        bar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        bar.shadowImage = UIImage()
        bar.alpha = 0.0
    }

    fileprivate func elementCustom() {
    }

    fileprivate func mapViewCustom() {
        mapView.register(PointAnnotation.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)

        let poi = MKPointAnnotation()
        poi.coordinate = CLLocationCoordinate2D(latitude: 48.866667, longitude: 2.333333)
        mapView.addAnnotation(poi)
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

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        let locationUser = Location(latitude: locValue.latitude, longitude: locValue.longitude)

        userLocation.append(locationUser)
        if let userLocation = userLocation.first {
            mapView.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: userLocation.latitude, longitude: userLocation.longitude), span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)), animated: false)
        }
        mapView.showsUserLocation = true
    }
}
