//
//  YourLocationViewController.swift
//  weather-tvOS
//
//  Created by Eyüp Mert on 17.02.2024.
//

import UIKit

class YourLocationViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var nextDayButton: UIButton!
    
    // MARK: - Statements
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Actions
    @IBAction func nextDayAction(_ sender: UIButton) {
        
    }
    
}

