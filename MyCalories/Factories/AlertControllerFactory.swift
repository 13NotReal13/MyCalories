//
//  AlertControllerFactory.swift
//  MyCalories
//
//  Created by Иван Семикин on 07/04/2024.
//

import UIKit

final class AlertControllerFactory {
    let title: String
    let message: String
    
    init(title: String, message: String) {
        self.title = title
        self.message = message
    }
    
    func createAlert(completion: @escaping() -> Void) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default) { _ in
            completion()
        }
        alert.addAction(okButton)
        
        return alert
    }
}
