//
//  NotificationManager.swift
//  healthapp
//
//  Created by mac on 2021/9/3.
//

import Foundation
import UserNotifications

class NotificationManager{
    
    func createNotification(title : String, subtitle : String ,body:String){
        let content = UNMutableNotificationContent()
             content.title = title
             content.subtitle = subtitle
             content.body = body
            content.sound = UNNotificationSound.default
             
             let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
             
             let request = UNNotificationRequest(identifier: "notification", content: content, trigger: trigger)
             
             UNUserNotificationCenter.current().add(request, withCompletionHandler: {error in
                 print("成功建立通知...")
             })
        
    }
    
    func createImageNotification(title : String, subtitle : String ,body:String,imageName : String){
        let content = UNMutableNotificationContent()
             content.title = title
             content.subtitle = subtitle
             content.body = body
            content.sound = UNNotificationSound.default
        
        
        // 設置通知的圖片
             let imageURL: URL = Bundle.main.url(forResource: imageName, withExtension: "png")!
             let attachment = try! UNNotificationAttachment(identifier: "image", url: imageURL, options: nil)
             content.attachments = [attachment]
             
             let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
             
             let request = UNNotificationRequest(identifier: "notification", content: content, trigger: trigger)
             
             UNUserNotificationCenter.current().add(request, withCompletionHandler: {error in
                 print("成功建立通知...")
             })
        
    }
    
    
}
