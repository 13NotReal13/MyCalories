//
//  AppDelegate.swift
//  MyCalories
//
//  Created by Иван Семикин on 01/04/2024.
//

import UIKit
import FirebaseCore
import UserNotifications
import FirebaseMessaging
import FirebaseCrashlytics
import GoogleMobileAds
import AppTrackingTransparency

@main
final class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        FirebaseApp.configure()
        
        // Установка делегата Firebase Messaging
        Messaging.messaging().delegate = self
        
        // Регистрация для получения push-уведомлений
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { granted, error in
            DispatchQueue.main.async {
                if granted {
                    application.registerForRemoteNotifications()
                }
                ATTrackingManager.requestTrackingAuthorization { _ in }
            }
        }
        
        // Инициализация Google Mobile Ads SDK
        DispatchQueue.global(qos: .background).async {
            GADMobileAds.sharedInstance().start(completionHandler: nil)
        }
        
        return true
    }

    // Получение и обработка токена APNs
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        Crashlytics.crashlytics().record(error: error)
    }

    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        if let token = fcmToken {
            Crashlytics.crashlytics().log("Firebase registration token: \(token)")
        } else {
            Crashlytics.crashlytics().log("Firebase registration token is not available.")
        }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    // Приложение получило уведомление в foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Обеспечиваем показ уведомлений даже когда приложение активно
        completionHandler([.banner, .sound, .badge])
    }
}
