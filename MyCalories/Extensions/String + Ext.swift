//
//  String + Ext.swift
//  MyCalories
//
//  Created by Иван Семикин on 13/06/2024.
//

import Foundation

extension String {
    static var addWaterAlert: String {
        NSLocalizedString("AddWaterAlert", comment: "Сколько воды вы выпили?")
    }
    static var save: String {
        NSLocalizedString("Save", comment: "Сохранить")
    }
    static var cancel: String {
        NSLocalizedString("Cancel", comment: "Отмена")
    }
    static var done: String {
        NSLocalizedString("Done", comment: "Готово")
    }
    static var ml: String {
        NSLocalizedString("Ml", comment: "мл.")
    }
    static var version: String {
        NSLocalizedString("Version", comment: "Версия: ")
    }
    static var update: String {
        NSLocalizedString("Update", comment: " (обновить)")
    }
    static var updateAlertTitle: String {
        NSLocalizedString("UpdateAlertTitle", comment: "Доступно обновление")
    }
    static var updateAlertMessagePart1: String {
        NSLocalizedString("UpdateAlertMessagePart1", comment: "Доступна новая версия ")
    }
    static var updateAlertMessagePart2: String {
        NSLocalizedString("UpdateAlertMessagePart2", comment: ". Пожалуйста, обновитесь до последней версии.")
    }
    static var updateAlertOkButton: String {
        NSLocalizedString("UpdateAlertOkButton", comment: "Обновить")
    }
    static var proteinsTableView: String {
        NSLocalizedString("ProteinsTableView", comment: "БЕЛКИ: ")
    }
    static var fatsTableView: String {
        NSLocalizedString("FatsYableView", comment: "ЖИРЫ: ")
    }
    static var carbohydratesTableView: String {
        NSLocalizedString("CarbohydratesTableView", comment: "УГЛЕВОДЫ: ")
    }
    static var caloriesTableView: String {
        NSLocalizedString("CaloriesTableView", comment: "ККАЛ: ")
    }
    static var per100gTableView: String {
        NSLocalizedString("Per100gTableView", comment: " НА 100 Г.")
    }
}
