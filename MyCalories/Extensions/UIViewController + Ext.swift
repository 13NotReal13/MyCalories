//
//  UIViewController + Ext.swift
//  MyCalories
//
//  Created by Иван Семикин on 16/05/2024.
//

import UIKit

extension UIViewController {
    func createToolbar(title: String, selector: Selector) -> UIToolbar {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(
            title: title,
            style: .done,
            target: self,
            action: selector
        )
        
        let flexButton = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil
        )
        
        keyboardToolbar.setItems([flexButton, doneButton], animated: true)
        return keyboardToolbar
    }
    
    func showAlertInvalidValue(_ textField: UITextField) {
        let alert = UIAlertController(title: "Ошибка", message: "Недопустимое значение", preferredStyle: .alert)
        
        let okButton = UIAlertAction(title: "OK", style: .default) { _ in
            textField.text = ""
            textField.becomeFirstResponder()
            alert.dismiss(animated: true)
        }
        
        alert.addAction(okButton)
        present(alert, animated: true)
    }
    
    func showAlertWrongFormat(fromTextField textField: UITextField) {
        let alert = UIAlertController(title: "Ошибка", message: "Неверный формат", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default) { _ in
            textField.text = ""
            textField.becomeFirstResponder()
            alert.dismiss(animated: true)
        }
        alert.addAction(okButton)
        present(alert, animated: true)
    }
}
