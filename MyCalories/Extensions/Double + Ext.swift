//
//  Double + Ext.swift
//  MyCalories
//
//  Created by Иван Семикин on 07/05/2025.
//

import Foundation

extension Double {
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
