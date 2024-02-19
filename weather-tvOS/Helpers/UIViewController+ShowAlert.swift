//
//  UIViewController+ShowAlert.swift
//  weather-tvOS
//
//  Created by Eyüp Mert on 19.02.2024.
//

import UIKit

extension UIViewController {
    func showMessage(_ title: String = "", _ message: String = "") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
        Task.init(operation: {
            self.present(alert, animated: true, completion: nil)
        }) 
    }
}
