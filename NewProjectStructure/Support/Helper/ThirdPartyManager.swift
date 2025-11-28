//
//  ThirdPartyManager.swift
//  NewProjectStructure
//
//  Created by Swapnil on 26/11/25.
//

import Foundation
import UIKit
//import Firebase
import Kingfisher
import UserNotifications
import AHKNavigationController

final class ThirdPartyManager: NSObject {

    static let shared = ThirdPartyManager()
    private override init() {}

    // MARK: - Firebase Setup
//    func configureFirebase() {
//        FirebaseApp.configure()
//        Utility.printDebug("Firebase configured")
//    }

    // MARK: - Kingfisher Setup (if needed)
    func configureKingfisherCache(maxCacheSize: UInt = 100 * 1024 * 1024) {
        let cache = ImageCache.default
        cache.memoryStorage.config.totalCostLimit = Int(maxCacheSize)
        cache.diskStorage.config.sizeLimit = maxCacheSize
        Utility.printDebug("Kingfisher cache configured with max size: \(maxCacheSize)")
    }

    // MARK: - Navigation Controller Style
    func configureAHKNavigationAppearance(tintColor: UIColor = .systemBlue, backgroundColor: UIColor = .white, titleColor: UIColor = .label, titleFont: UIFont = .boldSystemFont(ofSize: 18)) {
        let navBarAppearance = UINavigationBar.appearance()
        navBarAppearance.barTintColor = backgroundColor
        navBarAppearance.tintColor = tintColor
        navBarAppearance.isTranslucent = false
        navBarAppearance.titleTextAttributes = [.foregroundColor: titleColor, .font: titleFont]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: titleColor, .font: titleFont]
        navBarAppearance.shadowImage = UIImage()
        Utility.printDebug("AHKNavigationController appearance configured")
    }

    // MARK: - Push Notification Setup
    func registerForPushNotifications() {
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                Utility.printDebug("Push notification authorization error: \(error.localizedDescription)")
                return
            }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
            Utility.printDebug("Push notifications authorization granted: \(granted)")
        }
    }

    // Call this from AppDelegate's didRegisterForRemoteNotificationsWithDeviceToken
    func didRegisterForRemoteNotifications(deviceToken: Data) {
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        Utility.printDebug("Device Token: \(token)")
        // Send token to server if needed
    }

    // Call this from AppDelegate's didFailToRegisterForRemoteNotificationsWithError
    func didFailToRegisterForRemoteNotifications(error: Error) {
        Utility.printDebug("Failed to register for push notifications: \(error.localizedDescription)")
    }

    // MARK: - Other third-party SDKs
    func setupOtherSDKs() {
        // Analytics, Crashlytics, etc.
    }
}

// MARK: - UNUserNotificationCenterDelegate
extension ThirdPartyManager: UNUserNotificationCenterDelegate {

    // Foreground notification handling
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        Utility.printDebug("Foreground notification received: \(notification.request.content.userInfo)")
        completionHandler([.alert, .badge, .sound])
    }

    // Background / tapped notification handling
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        Utility.printDebug("Notification tapped: \(response.notification.request.content.userInfo)")
        completionHandler()
    }
}

