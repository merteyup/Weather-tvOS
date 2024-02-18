//
//  Forecast.swift
//  Weather
//
//  Created by Brian Advent on 05.01.19.
//  Copyright © 2019 Brian Advent. All rights reserved.
//

import Foundation

struct Forecast : Decodable {
    var temp_max:Float
    var condition_name:String
    var condition_desc:String
}
