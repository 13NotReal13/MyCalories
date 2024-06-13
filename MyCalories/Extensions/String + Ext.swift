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
    
    // MARK: - HistoryVC
    static var pfckCal: String {
        NSLocalizedString("PFCKcal", comment: "Б / Ж / У  Ккал")
    }
    static var total: String {
        NSLocalizedString("Total", comment: "Всего:")
    }
    static var weight: String {
        NSLocalizedString("Weight", comment: "Вес:")
    }
    static var selectTheOption: String {
        NSLocalizedString("SelectTheOption", comment: "Выберите нужный вариант")
    }
    static var editWeight: String {
        NSLocalizedString("EditWeight", comment: "Изменить вес")
    }
    static var delete: String {
        NSLocalizedString("Delete", comment: "Удалить")
    }
    
    // MARK: - AddProductToHistoryVC
    static var kcalPer100G: String {
        NSLocalizedString("KcalPer100G", comment: "кКал на 100 г.")
    }
    static var today: String {
        NSLocalizedString("Today", comment: "СЕГОДНЯ")
    }
    static var yesterday: String {
        NSLocalizedString("Yesterday", comment: "ВЧЕРА")
    }
    
    // MARK: - AddNewProductVC
    static var productNotFound: String {
        NSLocalizedString("ProductNotFound", comment: "Product not found")
    }
    static var solutionOptions: String {
        NSLocalizedString("SolutionOptions", comment: "Possible solutions: \n1. Ensure you are scanning only the barcode, without any extra numeric characters around; \n2. Check if there are other barcodes or QR codes on the product.")
    }
    
    static var information: String {
        NSLocalizedString("Information", comment: "Information")
    }
    static var someDataIsMissing: String {
        NSLocalizedString("SomeDataIsMissing.", comment: "Some data is missing.")
    }
    static var ok: String {
        NSLocalizedString("Ok", comment: "OK")
    }
    
    static var accessCameraIsRestricted: String {
        NSLocalizedString("AccessCameraIsRestricted", comment: "Camera access is restricted")
    }
    static var accessCameraIsRestrictedInfo: String {
        NSLocalizedString("AccessCameraIsRestrictedInfo", comment: "To scan barcodes, you need to allow camera access in the settings. Please go to Settings and enable camera access for this app.")
    }
    static var openSettings: String {
        NSLocalizedString("OpenSettings", comment: "Open Settings")
    }
    
    // MARK: - EditWeightVC
    static var error: String {
        NSLocalizedString("Error", comment: "Error")
    }
    static var needEnterWeight: String {
        NSLocalizedString("NeedEnterWeight", comment: "It is necessary to enter the weight.")
    }
}
