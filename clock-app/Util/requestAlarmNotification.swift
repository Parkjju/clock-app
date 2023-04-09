//
//  requestAlarmNotification.swift
//  clock-app
//
//  Created by 박경준 on 2023/04/09.
//

import Foundation
import UserNotifications

func requestAlarmNotification(repeatedly:Bool = false, withInterval interval: TimeInterval, notificationId: String, soundName: String){
    let content = UNMutableNotificationContent()
    content.title = "시계"
    content.subtitle = "알람"
    
    content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "\(soundName).wav"))
    
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: repeatedly)
    
    let request = UNNotificationRequest(identifier: notificationId, content: content, trigger: trigger)
    
    // remove All peding notification requests
    NotificationService.sharedInstance.UNCurrentCenter.removePendingNotificationRequests(withIdentifiers: [notificationId])
    
    NotificationService.sharedInstance.UNCurrentCenter.add(request)
}
