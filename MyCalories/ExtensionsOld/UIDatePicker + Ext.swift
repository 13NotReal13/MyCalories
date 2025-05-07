//
//  UIDatePicker + Ext.swift
//  MyCalories
//
//  Created by Иван Семикин on 14/04/2024.
//

import UIKit

extension UIDatePicker {
    func dateToString(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let dateInString = dateFormatter.string(from: date)
        return dateInString
    }
}
