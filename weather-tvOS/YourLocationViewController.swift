//
//  YourLocationViewController.swift
//  weather-tvOS
//
//  Created by Eyüp Mert on 17.02.2024.
//

import UIKit
import AVFoundation
import CoreLocation

class YourLocationViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var nextDayButton: UIButton!
    
    // MARK: - Variables
    var avPlayer: AVPlayer!
    var avPlayerLayer: AVPlayerLayer!
    
    // MARK: - Location Properties
    var locationManger = CLLocationManager()
    var currentLocation: CLLocation?
    
    // MARK: - Statements
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLocationServices()
        initVideoBackground()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        avPlayer.play()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        avPlayer.pause()
    }
    
    // MARK: - Functions
    func initVideoBackground() {
        avPlayer = AVPlayer(playerItem: preparePlayerItem(withIcon: Icon.sun))
        avPlayerLayer = AVPlayerLayer(player: avPlayer)
        avPlayerLayer.videoGravity = .resizeAspectFill
        avPlayerLayer.frame = view.layer.bounds
        
        avPlayer.volume = 0
        avPlayer.actionAtItemEnd = .none
        
        view.backgroundColor = .clear
        view.layer.insertSublayer(avPlayerLayer, at: 0)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playerItemDidReachEnd(notification:)),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                               object: avPlayer.currentItem)
    }
    
    func preparePlayerItem(withIcon icon: Icon) -> AVPlayerItem? {
        guard let url = Bundle.main.url(forResource: icon.rawValue, withExtension: "mp4") else { return nil }
        let item = AVPlayerItem(url: url)
        return item
    }
        
    @objc func playerItemDidReachEnd(notification: Notification) {
        guard let playerItem = notification.object as? AVPlayerItem else { return }
        playerItem.seek(to: .zero, completionHandler: nil)
    }
  
    // MARK: - Actions
    @IBAction func nextDayAction(_ sender: UIButton) {
        
    }
    
}

// MARK: - Extension CLLocationManagerDelegate
extension YourLocationViewController: CLLocationManagerDelegate {
    
    func setUpLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            locationManger.delegate = self
            switch locationManger.authorizationStatus {
            case .restricted, .denied:
                locationManger.requestWhenInUseAuthorization()
            case .notDetermined:
                locationManger.requestWhenInUseAuthorization()
            case .authorizedAlways, .authorizedWhenInUse:
                locationManger.requestLocation()
            default:
                print()
            }
        }
    }
    
}
