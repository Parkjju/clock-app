//
//  NotificationService.swift
//  clock-app
//
//  Created by 박경준 on 2023/03/07.
//

import Foundation
import UserNotifications

class NotificationService: NSObject{
    
    // 싱클톤 클래스
    private override init(){}
    static let sharedInstance = NotificationService()
    
    let UNCurrentCenter = UNUserNotificationCenter.current()
    
    func authorizeNotification(){
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]
        
        UNCurrentCenter.requestAuthorization(options: options){ (granted, error) in
            print(error ?? "No UNAuthorize error")
            
            guard granted else {
                print("사용자가 알람 권한을 허용하지 않았습니다.")
                return
            }
            
            self.UNCurrentCenter.delegate = self
        }
    }
    
    // 전달되는 date는 현재 변경 대상에 대한 날짜값
    // 이전에 전달된 date를 가지고 pendingNotification을 삭제해야됨
    func requestAlarmNotification(_ date: Date?, type:String,title: String, subtitle: String, sound: String, repeatedly:Bool = false, withInterval interval: TimeInterval?, notificationId: String){
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle
        
        let sound = sound
        
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "\(sound).wav"))
        
        let trigger = getTrigger(type: "Alarm", date) as! UNCalendarNotificationTrigger
        
        let request = UNNotificationRequest(identifier: notificationId, content: content, trigger: trigger)
        
        
        
        
        // remove All peding notification requests
        // 타이머를 작동시키는 상황에서 알람 돌리면 기존 노티 삭제됨?
        NotificationService.sharedInstance.UNCurrentCenter.removePendingNotificationRequests(withIdentifiers: [notificationId])
        
        NotificationService.sharedInstance.UNCurrentCenter.add(request)
    }
    
    func getTrigger(type: String, _ date: Date?) -> UNNotificationTrigger{
        let date = date!
        
        // dateComponents => in: current 파라미터 설정으로 하면 안됨.
        var dateComponents = Calendar.current.dateComponents([.day,.month,.year,.hour,.minute], from: date)
    
        let currentDateComponents = Calendar.current.dateComponents([.day,.month,.year,.hour,.minute], from: Date.now)
        
        // 알람을 맞췄는데 해당 시간이 현재 시간보다 이전에 맞춰졌다면
        // 다음날에 대한 알람이므로 - 캘린더 트리거를 하루 뒤로 미뤄야함
        if(currentDateComponents.day! > dateComponents.day!){
            dateComponents.day! += 1
        }
        
        return UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
    }
}

extension NotificationService: UNUserNotificationCenterDelegate{
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print(response.actionIdentifier)
        switch response.actionIdentifier{
        case UNNotificationDismissActionIdentifier:
            print("dismiss")
        case UNNotificationDefaultActionIdentifier:
            print("default")
        default:
            break
        }
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("willPresent notification")
        
        let options: UNNotificationPresentationOptions = [.banner, .sound]
        completionHandler(options)
    }
    
}
