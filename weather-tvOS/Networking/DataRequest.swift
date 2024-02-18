//
//  DataRequest.swift
//  weather-tvOS
//
//  Created by Brian Advent on 05.01.19.
//  Copyright © 2019 Brian Advent. All rights reserved.
//

import Foundation
import CoreLocation

enum GetDataRequest<Type> {
    case success([Type])
    case failure
}

struct DataRequest<Type> where Type : Decodable{
    let basePath = "http://explorecalifornia.org/api/weather"
    let dataURL:URL
    
    init(location:CLLocation) {
        let coordinate = location.coordinate
        let dataPathString = basePath + "/lat/\(coordinate.latitude)/lng/\(coordinate.longitude)/qty/1"
        print(dataPathString)
        guard let dataURL = URL(string: dataPathString) else {fatalError()}
        
        self.dataURL = dataURL
    }
    
    func getData (completion: @escaping (GetDataRequest<Type>) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: dataURL) {data, response, error in
            guard let jsonData = data else {completion(.failure); return}
            do {
                let resources = try JSONDecoder().decode([Type].self, from: jsonData)
                completion(.success(resources))
            }catch{
                print(error.localizedDescription)
                completion(.failure)
            }
        }
        
        dataTask.resume()
        
    }
}
