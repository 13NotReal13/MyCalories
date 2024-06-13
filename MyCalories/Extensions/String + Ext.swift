//
//  String + Ext.swift
//  MyCalories
//
//  Created by Иван Семикин on 13/06/2024.
//

import Foundation

extension String {
    // MARK: - MainVC
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
    
    // MARK: - ProfileVC
    static var lowTitle: String {
        NSLocalizedString("LowTitle", comment: "Низкая")
    }
    static var mediumTitle: String {
        NSLocalizedString("MediumTitle", comment: "Средняя")
    }
    static var highTitle: String {
        NSLocalizedString("HighTitle", comment: "Высокая")
    }
    
    static var lowDescription: String {
        NSLocalizedString("LowDescription", comment: "Низкая (1-2 тренировки в неделю или сидячий образ жизни)")
    }
    static var mediumDescription: String {
        NSLocalizedString("MediumDescription", comment: "Средняя (3-5 тренировок в неделю или лёгкие физические нагрузки)")
    }
    static var highDescription: String {
        NSLocalizedString("HighDescription", comment: "Высокая (6-7 тренировок в неделю или тяжёлые физические нагрузки)")
    }
    
    static var downWeight: String {
        NSLocalizedString("DownWeight", comment: "Снизить вес")
    }
    static var maintainWeight: String {
        NSLocalizedString("MaintainWeight", comment: "Удержать вес")
    }
    static var upWeight: String {
        NSLocalizedString("UpWeight", comment: "Набрать вес")
    }
    
    static var male: String {
        NSLocalizedString("Male", comment: "Мужчина")
    }
    static var female: String {
        NSLocalizedString("Female", comment: "Женщина")
    }
    
    static var normForDownWeight: String {
        NSLocalizedString("NormForDownWeight", comment: "Ежедневная рекомендуемая норма для снижения веса:")
    }
    static var normForMaintainWeight: String {
        NSLocalizedString("NormForMaintainWeight", comment: "Ежедневная рекомендуемая норма для поддержания веса:")
    }
    static var normForUpWeight: String {
        NSLocalizedString("NormForUpWeight", comment: "Ежедневная рекомендуемая норма для набора массы:")
    }
    
    static var g: String {
        NSLocalizedString("G", comment: "г.")
    }
    static var cal: String {
        NSLocalizedString("Cal", comment: "кКал.")
    }
    static var sourceOfFormula: String {
        NSLocalizedString("SourceOfFormula", comment: "Источник расчёта формул")
    }
}
