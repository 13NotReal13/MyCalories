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
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "dd MMMM yyyy"
        let dateInString = dateFormatter.string(from: date)
        return dateInString
    }
    
    static func timeToString(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let timeInString = dateFormatter.string(from: date)
        return timeInString
    }
    
    static func getAge(fromDate date: Date) -> Double {
        let currentDate = Date()
        let calendar = Calendar.current
        
        let ageComponents = calendar.dateComponents([.year], from: date, to: currentDate)
        return Double(ageComponents.year ?? 0)
    }
}
