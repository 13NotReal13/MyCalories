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
}
