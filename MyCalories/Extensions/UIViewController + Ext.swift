//
//  UIViewController + Ext.swift
//  MyCalories
//
//  Created by Иван Семикин on 16/05/2024.
//

import UIKit

extension UIViewController {
    func createToolbar(withDoneButtonSelector selector: Selector) -> UIToolbar {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(
            title: "Готово",
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
    
    func checkValueForTextField(_ textField: UITextField) {
        let alert = UIAlertController(title: "Ошибка", message: "Недопустимое значение", preferredStyle: .alert)
        
        let okButton = UIAlertAction(title: "OK", style: .cancel) { _ in
            textField.text = ""
            alert.dismiss(animated: true)
        }
        
        alert.addAction(okButton)
        present(alert, animated: true)
    }
}
