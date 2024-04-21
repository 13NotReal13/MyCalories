//
//  WaterList.swift
//  MyCalories
//
//  Created by Иван Семикин on 21/04/2024.
//

import Foundation
import RealmSwift

final class WaterHistoryList: Object {
    @Persisted var date = Date()
    @Persisted var waterList = List<Water>()
}

final class Water: Object {
    @Persisted var ml = 0
}
