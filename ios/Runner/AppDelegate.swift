import UIKit
import Flutter
import UserNotifications

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(
          options: [.alert, .badge, .sound],
          completionHandler: { granted, error in
            if granted {
              print("알림 권한이 허용되었습니다.")
            } else {
              print("알림 권한이 거부되었습니다.")
            }
          }
        )

        // 알림 채널 설정
        let notificationCenter = UNUserNotificationCenter.current()
        let notificationOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        notificationCenter.requestAuthorization(
            options: notificationOptions) { (granted, error) in
                if !granted {
                    print("알림 권한이 거부되었습니다.")
                }
            }
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
