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
import AVKit

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UIGestureRecognizerDelegate {

    // MARK: - Outlet

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!

    // MARK: - Properties

    var viewModel: MapViewModel!
    let locationManager = CLLocationManager()
    var userLocation: [Location] = []

    private var videoPlayer: AVPlayer?
    private var videoPlayerLayer: AVPlayerLayer?

    var playerLooper: AVPlayerLooper?
    var queuePlayer: AVQueuePlayer?

    // MARK: - View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
        mapViewCustom()

        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        gestureRecognizer.delegate = self
        mapView.addGestureRecognizer(gestureRecognizer)

        viewModel.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        viewModel.viewWillAppear()
        bind(to: viewModel)
    }

    // MARK: - Private Functions

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
        viewModel.cityNameText = { [weak self] text in
            self?.alertLabel.text = text
        }
        viewModel.iconText = { [weak self] text in
            self?.iconImageView.image = UIImage(named: text)
        }
        viewModel.tempText = { [weak self] text in
            self?.tempLabel.text = text
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
        setUpAlertViewVideo()
    }

    fileprivate func setUpAlertViewVideo() {
        let url = viewModel.setUpVideo()
        guard url != nil else { return }
        let item = AVPlayerItem(url: url!)
        videoPlayer = AVPlayer(playerItem: item)
        videoPlayerLayer = AVPlayerLayer(player: videoPlayer!)
        // adjust the size and frame
        videoPlayerLayer?.frame = CGRect(x: self.alertView.bounds.minX,
                                         y: self.alertView.bounds.minY,
                                         width: self.alertView.bounds.maxX + 41,
                                         height: self.alertView.bounds.maxY + 41)

        // add it to the view and play it
        guard videoPlayer != nil else { return }
        videoPlayer!.actionAtItemEnd = AVPlayer.ActionAtItemEnd.none
        videoPlayer!.playImmediately(atRate: 1)
        videoPlayerLayer?.videoGravity = .resizeAspectFill
        alertView.layer.insertSublayer(videoPlayerLayer!, at: 0)

        alertView.layer.cornerRadius = 15
        alertView.layer.masksToBounds = true

        NotificationCenter.default.addObserver(self, selector: #selector(playerItemEnded), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: videoPlayer!.currentItem)
        videoPlayer!.seek(to: CMTime.zero)
        videoPlayer!.play()
        self.videoPlayer?.isMuted = true
    }

    @objc func playerItemEnded() {
        videoPlayer!.seek(to: CMTime.zero)
    }

    // MARK: - View actions

    @IBAction func didPressCancelButton(_ sender: Any) {
        viewModel.didPressCancelButton()
    }

    @IBAction func didPressAddButton(_ sender: Any) {
        viewModel.didPressAddButton()
    }
}
