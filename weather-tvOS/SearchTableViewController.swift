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
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
     
     
     return cell
     }
     
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
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
