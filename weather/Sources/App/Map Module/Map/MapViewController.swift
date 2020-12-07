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

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    // MARK: - Outlet

    @IBOutlet weak var mapView: MKMapView!

    // MARK: - Properties

    var viewModel: MapViewModel!
    let locationManager = CLLocationManager()
    var userLocation: [Location] = []

    // MARK: - View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapViewCustom()
        viewModel.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        viewModel.viewWillAppear()
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
}
