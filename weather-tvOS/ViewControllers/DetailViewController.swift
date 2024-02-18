//
//  DetailViewController.swift
//  weather-tvOS
//
//  Created by Eyüp Mert on 18.02.2024.
//

import UIKit

class DetailViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var conditionImageView: UIImageView!
    
    // MARK: - Variable
    var weatherObject: Forecast! {
        didSet{
            configureView()
        }
    }
    
    // MARK: - Statements
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    // MARK: - Functions
    func configureView() {
        if let summaryLabel = self.summaryLabel {
            summaryLabel.text = weatherObject.condition_desc
            let temperature = convertToCelsius(from: weatherObject.temp_max)
            temperatureLabel.text = "\(Int(temperature)) C°"
            conditionImageView.image = UIImage(named: weatherObject.condition_name)
        }
    }
}
