//
//  UITextField + Ext.swift
//  MyCalories
//
//  Created by Иван Семикин on 07/04/2024.
//

import UIKit

extension UITextField {
    func setCornerRadius() {
        self.layer.cornerRadius = self.frame.height / 2
    }
}
