//
//  SearchTableViewController.swift
//  weather-tvOS
//
//  Created by Eyüp Mert on 18.02.2024.
//

import UIKit
import CoreLocation

class SearchTableViewController: UITableViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var searchTextField: UITextField!
    
    // MARK: - Variables
    var weatherArray = [Forecast]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.delegate = self
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let selectedDate = Calendar.current.date(byAdding: .day, value: indexPath.row, to: Date())
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        if let selectedDate = selectedDate {
            cell.textLabel?.text = dateFormatter.string(from: selectedDate)
        }
        
        return cell
    }
    

    
}

// MARK: - Extension UITextFieldDelegate
extension SearchTableViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let locationString = textField.text else { return }
        getWeatherForSearchedLocation(location: locationString)
    }
    
    func getWeatherForSearchedLocation(location: String) {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(location) { placemarks, error in
            guard let firstPlacemark = placemarks?.first else { return }
            guard let firstLocation = firstPlacemark.location else { return }
            
            let weatherDataRequest = DataRequest<WeatherData>(location: firstLocation)
            weatherDataRequest.getData { [weak self] dataResult in
                
                switch dataResult {
                case .success(let array):
                    guard let forecastArray = array.first?.forecast else { return }
                    self?.weatherArray = forecastArray
                    print("Success to fetch weather data \(forecastArray)")
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                case .failure:
                    print("Failed to fetch weather data")
                }
            }
            
        }
    }
}
