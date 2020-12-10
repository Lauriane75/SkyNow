//
//  WeatherViewController.swift
//  weather
//
//  Created by Lauriane Haydari on 12/02/2020.
//  Copyright © 2020 Lauriane Haydari. All rights reserved.
//

import UIKit
import AVKit

class WeekViewController: UIViewController {

    // MARK: - Outlet
    @IBOutlet weak var videoBackgroundUIView: UIView!

    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet weak var weatherChanelButton: UIButton!
    @IBOutlet weak var unitButton: UIButton!

    // MARK: - Properties

    var viewModel: WeekViewModel!
    private var source = WeekDataSource()
    private var isCelsius = true
    private var urlString: String?

    private var videoPlayer: AVPlayer?
    private var videoPlayerLayer: AVPlayerLayer?

    // MARK: - View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBackgroundVideo()

        tableView.delegate = source
        tableView.dataSource = source

        bind(to: viewModel)
        bind(to: source)

        navigationBarCustom()

        viewModel.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        viewModel.viewWillAppear()
    }

    // MARK: - Private Functions

    private func bind(to viewModel: WeekViewModel) {
        viewModel.unitText = { [weak self] text in
            self?.unitButton.setTitle(text, for: .normal)
        }
        viewModel.urlString = { [weak self] text in
            self?.urlString = text
        }
        viewModel.visibleItems = { [weak self] items in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.navigationItem.title = items.first?.nameCity.capitalized
                self.source.update(with: items)
                self.tableView.reloadData()
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
    }

    private func bind(to source: WeekDataSource) {
        source.selectedWeatherDay = viewModel.didSelectDay
    }

    // MARK: - View actions

    @IBAction func didPressWeatherChanelButton(_ sender: Any) {
        guard urlString != nil else { return }
        guard let url = URL(string: urlString!) else { return }
        UIApplication.shared.open(url)
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

    // MARK: - Private Files

    fileprivate func navigationBarCustom() {
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white,
                              NSAttributedString.Key.font: UIFont(name: "kailasa", size: 20)]
        guard let bar = navigationController?.navigationBar else { return }
        bar.titleTextAttributes = textAttributes as [NSAttributedString.Key: Any]
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
