//
//  UIViewController+WeatherConverting.swift
//  weather-tvOS
//
//  Created by Eyüp Mert on 18.02.2024.
//

import UIKit

public extension UIViewController {
    func convertToCelsius(from: Float) -> Float {
        let fahrenheit = Measurement(value: Double(from), unit: UnitTemperature.fahrenheit)
        let celsius = fahrenheit.converted(to: .celsius).value
        return Float(celsius)
    }
}
