//
//  NotificationManager.swift
//  DemoAlternateAppIcon
//
//  Created by miss.menut on 10/11/2568 BE.
//

import Foundation
import UserNotifications

/// Handles notification permissions, scheduling and delegates icon changes back to the view model.
final class NotificationManager: NSObject, ObservableObject {
    private enum Constants {
        static let userInfoIconKey = "iconName"
    }

    private let notificationCenter = UNUserNotificationCenter.current()
    private let iconViewModel: ChangeAppIconViewModel
    private let shouldRequestAuthorization: Bool

    init(iconViewModel: ChangeAppIconViewModel, requestPermissionOnInit: Bool = true) {
        self.iconViewModel = iconViewModel
        self.shouldRequestAuthorization = requestPermissionOnInit
        super.init()
        notificationCenter.delegate = self
        if shouldRequestAuthorization {
            requestAuthorization()
        }
    }

    private func requestAuthorization() {
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error = error {
                print("Notification authorization failed: \(error.localizedDescription)")
                return
            }

            if !granted {
                print("Notification authorization denied by the user.")
            }
        }
    }

    /// Schedules a demo notification that, once delivered, updates the app icon.
    func scheduleIconChangeNotification(for icon: AppIcon, after seconds: TimeInterval) {
        let content = UNMutableNotificationContent()
        content.title = "New App Icon Ready"
        content.body = "Tap to switch to \(icon.description)."
        content.sound = .default
        content.userInfo = [Constants.userInfoIconKey: icon.rawValue]

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: max(1, seconds), repeats: false)
        let identifier = "icon-change-\(icon.rawValue)-\(UUID().uuidString)"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

        notificationCenter.add(request) { error in
            if let error = error {
                print("Failed to schedule notification: \(error.localizedDescription)")
            }
        }
    }

    private func handleIconChange(from notification: UNNotification) {
        guard let iconName = notification.request.content.userInfo["iconName"] as? String,
              let icon = AppIcon(rawValue: iconName) else { return }

        Task { @MainActor in
            iconViewModel.updateAppIcon(to: icon)
        }
    }
}

// MARK: - UNUserNotificationCenterDelegate
extension NotificationManager: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        handleIconChange(from: notification)
        completionHandler([.banner, .sound])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        handleIconChange(from: response.notification)
        completionHandler()
    }
}
