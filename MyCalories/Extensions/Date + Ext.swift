//
//  Date + Ext.swift
//  MyCalories
//
//  Created by Иван Семикин on 07/06/2025.
//

import Foundation

extension Date {
    static func getAge(fromDate date: Date) -> Double {
        let currentDate = Date()
        let calendar = Calendar.current
        
        let ageComponents = calendar.dateComponents([.year], from: date, to: currentDate)
        return Double(ageComponents.year ?? 0)
    }
}
