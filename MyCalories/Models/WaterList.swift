//
//  WaterList.swift
//  MyCalories
//
//  Created by Иван Семикин on 21/04/2024.
//

import Foundation
import RealmSwift

final class HistoryOfWater: Object {
    @Persisted var date = Date()
    @Persisted var waterList = List<Water>()
}

final class Water: Object {
    @Persisted var date = Date()
    @Persisted var ml = 0
    
    let historyLink = LinkingObjects(fromType: HistoryOfWater.self, property: "waterList")
}
