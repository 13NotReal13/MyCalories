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
        NSLocalizedString("Сколько воды вы выпили?", comment: "Сколько воды вы выпили?")
    }
    static var save: String {
        NSLocalizedString("Сохранить", comment: "Сохранить")
    }
    static var cancel: String {
        NSLocalizedString("Отмена", comment: "Отмена")
    }
    static var done: String {
        NSLocalizedString("Готово", comment: "Готово")
    }
    static var ml: String {
        NSLocalizedString("мл.", comment: "мл.")
    }
    
    static var version: String {
        NSLocalizedString("Версия: ", comment: "Версия: ")
    }
    static var update: String {
        NSLocalizedString(" (обновить)", comment: " (обновить)")
    }
    
    static var updateAlertTitle: String {
        NSLocalizedString("Доступно обновление", comment: "Доступно обновление")
    }
    static var updateAlertMessagePart1: String {
        NSLocalizedString("Доступна новая версия ", comment: "Доступна новая версия ")
    }
    static var updateAlertMessagePart2: String {
        NSLocalizedString(". Пожалуйста, обновитесь до последней версии.", comment: ". Пожалуйста, обновитесь до последней версии.")
    }
    static var updateAlertOkButton: String {
        NSLocalizedString("Обновить", comment: "Обновить")
    }
    
    static var proteinsTableView: String {
        NSLocalizedString("БЕЛКИ: ", comment: "БЕЛКИ: ")
    }
    static var fatsTableView: String {
        NSLocalizedString("ЖИРЫ: ", comment: "ЖИРЫ: ")
    }
    static var carbohydratesTableView: String {
        NSLocalizedString("УГЛЕВОДЫ: ", comment: "УГЛЕВОДЫ: ")
    }
    static var caloriesTableView: String {
        NSLocalizedString("ККАЛ: ", comment: "ККАЛ: ")
    }
    static var per100gTableView: String {
        NSLocalizedString(" НА 100 Г.", comment: " НА 100 Г.")
    }
    
    // MARK: - ProfileVC
    static var lowTitle: String {
        NSLocalizedString("Низкая", comment: "Низкая")
    }
    static var mediumTitle: String {
        NSLocalizedString("Средняя", comment: "Средняя")
    }
    static var highTitle: String {
        NSLocalizedString("Высокая", comment: "Высокая")
    }
    
    static var lowDescription: String {
        NSLocalizedString("Низкая (1-2 тренировки в неделю или сидячий образ жизни)", comment: "Низкая (1-2 тренировки в неделю или сидячий образ жизни)")
    }
    static var mediumDescription: String {
        NSLocalizedString("Средняя (3-5 тренировок в неделю или лёгкие физические нагрузки)", comment: "Средняя (3-5 тренировок в неделю или лёгкие физические нагрузки)")
    }
    static var highDescription: String {
        NSLocalizedString("Высокая (6-7 тренировок в неделю или тяжёлые физические нагрузки)", comment: "Высокая (6-7 тренировок в неделю или тяжёлые физические нагрузки)")
    }
    
    static var downWeight: String {
        NSLocalizedString("Снизить вес", comment: "Снизить вес")
    }
    static var maintainWeight: String {
        NSLocalizedString("Удержать вес", comment: "Удержать вес")
    }
    static var upWeight: String {
        NSLocalizedString("Набрать вес", comment: "Набрать вес")
    }
    
    static var male: String {
        NSLocalizedString("Мужчина", comment: "Мужчина")
    }
    static var female: String {
        NSLocalizedString("Женщина", comment: "Женщина")
    }
    
    static var normForDownWeight: String {
        NSLocalizedString("Ежедневная рекомендуемая норма для снижения веса:", comment: "Ежедневная рекомендуемая норма для снижения веса:")
    }
    static var normForMaintainWeight: String {
        NSLocalizedString("Ежедневная рекомендуемая норма для поддержания веса:", comment: "Ежедневная рекомендуемая норма для поддержания веса:")
    }
    static var normForUpWeight: String {
        NSLocalizedString("Ежедневная рекомендуемая норма для набора массы:", comment: "Ежедневная рекомендуемая норма для набора массы:")
    }
    
    static var g: String {
        NSLocalizedString("г.", comment: "г.")
    }
    static var cal: String {
        NSLocalizedString("кКал.", comment: "кКал.")
    }
    static var sourceOfFormula: String {
        NSLocalizedString("Источник расчёта формул", comment: "Источник расчёта формул")
    }
    
    // MARK: - HistoryVC
    static var pfckCal: String {
        NSLocalizedString("Б / Ж / У  Ккал", comment: "Б / Ж / У  Ккал")
    }
    static var total: String {
        NSLocalizedString("Всего:", comment: "Всего:")
    }
    static var weight: String {
        NSLocalizedString("Вес:", comment: "Вес:")
    }
    static var selectTheOption: String {
        NSLocalizedString("Выберите нужный вариант", comment: "Выберите нужный вариант")
    }
    static var editWeight: String {
        NSLocalizedString("Изменить вес", comment: "Изменить вес")
    }
    static var delete: String {
        NSLocalizedString("Удалить", comment: "Удалить")
    }
    
    // MARK: - AddProductToHistoryVC
    static var kcalPer100G: String {
        NSLocalizedString("кКал на 100 г.", comment: "кКал на 100 г.")
    }
    static var today: String {
        NSLocalizedString("СЕГОДНЯ", comment: "СЕГОДНЯ")
    }
    static var yesterday: String {
        NSLocalizedString("ВЧЕРА", comment: "ВЧЕРА")
    }
    
    // MARK: - AddNewProductVC
    static var productNotFound: String {
        NSLocalizedString("Product not found", comment: "Product not found")
    }
    static var solutionOptions: String {
        NSLocalizedString("Возможные решения: \n1. Убедитесь, что вы сканируете только штрих-код, без каких-либо дополнительных числовых символов вокруг; \n2. Проверьте, есть ли на товаре другие штрих-коды или QR-коды.", comment: "Возможные решения: \n1. Убедитесь, что вы сканируете только штрих-код, без каких-либо дополнительных числовых символов вокруг; \n2. Проверьте, есть ли на товаре другие штрих-коды или QR-коды.")
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
    
    // MARK: - PurchaseVC
    static var restorePurchase: String {
        NSLocalizedString("RestorePurchase", comment: "Restore Purchases")
    }
    static var requestHasBeenSent: String {
        NSLocalizedString("RequestHasBeenSent", comment: "A request to restore purchases from your AppleID has been sent.")
    }
    static var subscriptionRestored: String {
        NSLocalizedString("SubscriptionRestored", comment: "Subscription Restored")
    }
    static var expirationDate: String {
        NSLocalizedString("ExpirationDate", comment: "Expiration Date:")
    }
    static var privacyPolicy: String {
        NSLocalizedString("PrivacyPolicy", comment: "Privacy Policy")
    }
    static var termsOfUse: String {
        NSLocalizedString("TermsOfUse", comment: "Terms of Use")
    }
    static var expiration: String {
        NSLocalizedString("Expiration", comment: "Expires:")
    }
    static var perMonth: String {
        NSLocalizedString("PerMonth", comment: "/ мес.")
    }
    
    // MARK: - UIViewController + Ext
    static var invalidValue: String {
        NSLocalizedString("InvalidValue", comment: "Invalid value")
    }
    static var wrongFormat: String {
        NSLocalizedString("WrongFormat", comment: "Wrong format")
    }
    static var askToDelete: String {
        NSLocalizedString("AskToDelete", comment: "Are you sure you want to delete?")
    }
    static var rateAlertTitle: String {
        NSLocalizedString("RateAlertTitle", comment: "Нравится ли вам наше приложение?🥹")
    }
    static var rateAlertMessage: String {
        NSLocalizedString("RateAlertMessage", comment: "Мы очень стараемся для Вас и каждый день!❤️")
    }
    static var rateAlertOkButton: String {
        NSLocalizedString("RateAlertOkButton", comment: "5 stars")
    }
    
    static var connectErrorTitle: String {
        NSLocalizedString("ConnectionErrorTitle", comment: "Ошибка подключения")
    }
    static var connectionErrorMessage: String {
        NSLocalizedString("ConnectionErrorMessage", comment: "Проверьте подключение к интернету и попробуйте снова.")
    }
    static var timeoutErrorTitle: String {
        NSLocalizedString("TimeoutErrorTitle", comment: "Время ожидания истекло")
    }
    static var timeoutErrorMessage: String {
        NSLocalizedString("TimeoutErrorMessage", comment: "Сервер не отвечает. Попробуйте повторить запрос позже.")
    }
    static var unexpectedErrorMessage: String {
        NSLocalizedString("UnexpectedErrorMessage", comment: "Произошла неожиданная ошибка.😢")
    }
    static var dataErrorTitle: String {
        NSLocalizedString("DataErrorTitle", comment: "Ошибка данных")
    }
    static var dataErrorMessage: String {
        NSLocalizedString("DataErrorMessage", comment: "Не удалось получить данные с сервера.")
    }
    static var addNewProductTitle: String {
        NSLocalizedString("AddNewProductFromTableView", comment: "Добавить новый продукт")
    }
}
