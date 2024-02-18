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
    
    // MARK: - Weather Properties
    var weatherArray = [Forecast]()
    
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
        locationManger.delegate = self
        
        let authorizationStatus: CLAuthorizationStatus
        if #available(iOS 14, *) {
            authorizationStatus = locationManger.authorizationStatus
        } else {
            authorizationStatus = CLLocationManager.authorizationStatus()
        }
        
        switch authorizationStatus {
        case .restricted, .denied:
            locationManger.requestWhenInUseAuthorization()
        case .notDetermined:
            locationManger.requestWhenInUseAuthorization()
        case .authorizedAlways, .authorizedWhenInUse:
            print()
        default:
            print()
        }
        
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways {
            manager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location Could Not Get: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        guard let locationObject = locations.first else {return}
        currentLocation = locationObject
        getWeatherForLocation(location: locationObject, andForeCastIndex: 0)
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(locationObject) { placemarks, error in
            if error == nil {
                guard let cityName = placemarks?.first?.locality else { return }
                DispatchQueue.main.async {
                    self.locationLabel.text = cityName
                }
            }
        }
    }
}

// MARK: - Weather
extension YourLocationViewController {
    
    func getWeatherForLocation(location: CLLocation, andForeCastIndex index: Int) {
        let weatherDataRequest = DataRequest<WeatherData>(location: location)
        weatherDataRequest.getData { [weak self] dataResult in
            
            switch dataResult {
            case .success(let array):
                guard let forecastArray = array.first?.forecast else { return }
                self?.weatherArray = forecastArray
                print(forecastArray)
            case .failure:
                print("Failed to fetch weather data")
            }
        }
    }
    
}
