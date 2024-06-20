//
//  UIViewController + Ext.swift
//  MyCalories
//
//  Created by Иван Семикин on 16/05/2024.
//

import UIKit
import FirebaseAnalytics

enum TypeOfAlert {
    case invalidValue
    case wrongFormat
}

extension UIViewController {
    func createToolbar(title: String, isCancelSelector: Bool? = nil, selector: Selector) -> UIToolbar {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        
        let flexButton = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil
        )
        
        let doneButton = UIBarButtonItem(
            title: title,
            style: .done,
            target: self,
            action: selector
        )
        
        if isCancelSelector != nil {
            let cancelButton = UIBarButtonItem(
                title: String.cancel,
                style: .plain,
                target: self,
                action: #selector(cancelButtonSelector)
            )
            keyboardToolbar.setItems([cancelButton, flexButton, doneButton], animated: true)
        } else {
            keyboardToolbar.setItems([flexButton, doneButton], animated: true)
        }
        
        return keyboardToolbar
    }
    
    @objc func cancelButtonSelector() {
        view.endEditing(true)
    }
    
    func showAlertError(textField: UITextField, type: TypeOfAlert) {
        let alert = UIAlertController(
            title: String.error,
            message: type == .invalidValue ? String.invalidValue : String.wrongFormat,
            preferredStyle: .alert
        )
        
        let okButton = UIAlertAction(title: String.ok, style: .default) { _ in
            textField.text = ""
            textField.becomeFirstResponder()
            alert.dismiss(animated: true)
        }
        
        alert.addAction(okButton)
        present(alert, animated: true)
    }
    
    func showAlertDelete(for target: String, inTableView tableView: UITableView? = nil, completion: @escaping() -> Void) {
        let alert = UIAlertController(title: String.askToDelete, message: target, preferredStyle: .alert)
        
        let deleteButton = UIAlertAction(title: String.delete, style: .destructive) { _ in
            completion()
        }
        
        let cancelButton = UIAlertAction(title: String.cancel, style: .cancel) { _ in
            alert.dismiss(animated: true)
            guard let tableView, let indexPath = tableView.indexPathForSelectedRow else { return }
                tableView.deselectRow(at: indexPath, animated: true)
        }
        
        alert.addAction(deleteButton)
        alert.addAction(cancelButton)
        present(alert, animated: true)
    }
    
    func showRatingAlert() {
        let alert = UIAlertController(
            title: String.rateAlertTitle,
            message: String.rateAlertMessage,
            preferredStyle: .alert
        )
        
        // imageKitty
        let kittyImage = UIImage(named: "littleKitty")
        let imageView = UIImageView(image: kittyImage)
        imageView.contentMode = .scaleAspectFit
        let maxSize = CGSize(width: 372, height: 387)
        var imageSize = imageView.sizeThatFits(maxSize)
        imageSize = CGSize(width: min(maxSize.width, imageSize.width), height: min(maxSize.height, imageSize.height))
        imageView.frame = CGRect(x: 10, y: 10, width: imageSize.width, height: imageSize.height)
        alert.view.addSubview(imageView)
        
        alert.view.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: alert.view.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: alert.view.topAnchor, constant: Locale.current.languageCode == "ru" ? 160 : 100),
            imageView.bottomAnchor.constraint(equalTo: alert.view.bottomAnchor, constant: -50),
            imageView.widthAnchor.constraint(equalToConstant: imageSize.width),
            imageView.heightAnchor.constraint(equalToConstant: imageSize.height),
        ])
        
        
        let rateButton = UIAlertAction(title: String.rateAlertOkButton, style: .default) { _ in
            if let urlApp = URL(string: "https://apps.apple.com/pl/app/мои-калории-24-7/id6502844957") {
                UIApplication.shared.open(urlApp)
                Analytics.logEvent("rate_5_stars_button_pressed", parameters: nil)
            } else {
                Analytics.logEvent("rate_5_stars_button_error_url", parameters: nil)
            }
            alert.dismiss(animated: true)
        }
        
        let cancelButton = UIAlertAction(title: String.cancel, style: .cancel) { _ in
            Analytics.logEvent("rate_cancel_button_pressed", parameters: nil)
        }
        
        alert.addAction(cancelButton)
        alert.addAction(rateButton)
        
        present(alert, animated: true)
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: String.ok, style: .default) { _ in
            alert.dismiss(animated: true)
        }
        alert.addAction(okButton)
        
        DispatchQueue.main.async { [unowned self] in
            present(alert, animated: true)
        }
    }
}
