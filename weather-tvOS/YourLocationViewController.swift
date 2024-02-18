//
//  YourLocationViewController.swift
//  weather-tvOS
//
//  Created by Eyüp Mert on 17.02.2024.
//

import UIKit
import AVFoundation

class YourLocationViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var nextDayButton: UIButton!
    
    var avPlayer: AVPlayer!
    var avPlayerLayer: AVPlayerLayer!
    
    // MARK: - Statements
    override func viewDidLoad() {
        super.viewDidLoad()
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

