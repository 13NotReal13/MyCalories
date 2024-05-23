//
//  UIViewController + Ext.swift
//  MyCalories
//
//  Created by Иван Семикин on 16/05/2024.
//

import UIKit

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
                title: "Отмена",
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
