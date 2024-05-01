//
//  UITextField + Ext.swift
//  MyCalories
//
//  Created by Иван Семикин on 01/05/2024.
//

import UIKit

extension UITextField {
    func customStyle() {
        self.layer.shadowColor = UIColor.black.cgColor // Цвет тени
        self.layer.shadowOffset = CGSize(width: 0, height: 2) // Смещение тени
        self.layer.shadowOpacity = 0.1 // Прозрачность тени
        self.layer.shadowRadius = 5 // Радиус размытия тени
        self.layer.masksToBounds = false
    }
}
