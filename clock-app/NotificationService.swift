//
//  NotificationService.swift
//  clock-app
//
//  Created by 박경준 on 2023/03/07.
//

import Foundation
import UserNotifications

class NotificationService: NSObject{
    private override init(){}
    
    static let sharedInstance = NotificationService()
    
    let UNCurrentCenter = UNUserNotificationCenter.current()
    
    func authorizeNotification(){
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]
        
        UNCurrentCenter.requestAuthorization(options: options){ granted, error in
            print(error ?? "No UNAuthorize error")
            
            guard granted else {
                print("사용자가 알람 권한을 허용하지 않았습니다.")
                return
            }
            
            self.UNCurrentCenter.delegate = self
        }
    }
}

extension NotificationService: UNUserNotificationCenterDelegate{
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("didReceive response")
        
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("willPresent notification")
        
        let options: UNNotificationPresentationOptions = [.banner, .sound]
        completionHandler(options)
    }
    
}
