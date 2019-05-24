import UIKit
import UserNotifications    // MARK: import

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // MARK: request to user
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            guard granted else { return }

            // MARK: register to APNs
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }

        // MARK: 01. get notification payload
        if let notificationOptions = launchOptions?[.remoteNotification] as? [String: AnyObject] {
            guard let apsPart = notificationOptions["aps"] as? [String: AnyObject] else { return true }

            guard let vc = window?.rootViewController as? ViewController else { return true }
            let text = apsPart.map { (key, value) in "\(key): \(value)" }.joined(separator: "\n")
            vc.payloadText = text
            vc.backgroundColor = .yellow
        }

        return true
    }
}

// MARK: - Callback for Remote Notification
extension AppDelegate {
    // MARK: succeeded to register to APNs
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Data -> Token string
        let tokenBytes = deviceToken.map { (byte: UInt8) in String(format: "%02.2hhx", byte) }
        print("Device token: \(tokenBytes.joined())")
    }

    // MARK: failed to register to APNs
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register to APNs: \(error)")
    }

    // MARK: 02. callback when received remote notification during app is running
    // MARK: 03. this callback needed Background Modes is on in the Capabilities setting and check "Remote notifications"
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {

        // MARK: 04. get notification payload
        guard let apsPart = userInfo["aps"] as? [String: AnyObject] else {
            completionHandler(.failed)
            return
        }

        guard let vc = window?.rootViewController as? ViewController else { return }
        let text = apsPart.map { (key, value) in "\(key): \(value)" }.joined(separator: "\n")
        vc.payloadText = text
        vc.backgroundColor = .green
    }
}
