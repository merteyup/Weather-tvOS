//
//  WeatherData.swift
//  weather-tvOS
//
//  Created by Brian Advent on 09/02/2017.
//  Copyright © 2017 Brian Advent. All rights reserved.
//

import Foundation


struct WeatherData : Decodable {
    var forecast:[Forecast]
}
