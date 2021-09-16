//
//  AppDelegate.swift
//  healthapp
//
//  Created by mac on 2021/8/25.
//

import UIKit
import Firebase
import UserNotifications
@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate  {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        initUserNotifications()
        FirebaseApp.configure()
        Analytics.setAnalyticsCollectionEnabled(true)

        return true
    }


    func initUserNotifications(){
        // 在程式一啟動即詢問使用者是否接受圖文(alert)、聲音(sound)、數字(badge)三種類型的通知
              UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge, .carPlay], completionHandler: { (granted, error) in
                  if granted {
                      print("允許")
                  } else {
                      print("不允許")
                  }
              })
        
        UNUserNotificationCenter.current().delegate = self

    }
    
    // 在前景收到通知時所觸發的 function
      func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
          print("在前景收到通知...")
        completionHandler([.badge, .sound, .alert])
      }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        completionHandler()
        
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?) {
        
        
        
    }
}

