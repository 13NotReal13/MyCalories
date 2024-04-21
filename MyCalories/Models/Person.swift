//
//  Person.swift
//  MyCalories
//
//  Created by Иван Семикин on 13/04/2024.
//

import Foundation
import RealmSwift

final class Person: Object {
    @Persisted var gender: String
    @Persisted var dateOfBirthday: Date
    @Persisted var height: Double
    @Persisted var weight: Double
    @Persisted var activity: String
    @Persisted var goal: String
}
