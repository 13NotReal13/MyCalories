//
//  Date + Ext.swift
//  MyCalories
//
//  Created by Иван Семикин on 15/04/2024.
//

import Foundation

extension Date {
    static func dateToString(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "dd MMMM yyyy"
        let dateInString = dateFormatter.string(from: date)
        return dateInString
    }
}
