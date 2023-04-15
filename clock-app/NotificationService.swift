//
//  NotificationService.swift
//  clock-app
//
//  Created by 박경준 on 2023/03/07.
//

import Foundation
import UserNotifications
import UIKit

class NotificationService: NSObject{
    
    // 싱클톤 클래스
    private override init(){}
    static let sharedInstance = NotificationService()
    
    let UNCurrentCenter = UNUserNotificationCenter.current()
    
    var pendingNotificationArray: [UNNotificationRequest]?
    
    // AlarmData 모델 매니저에서 현재 보유중인 알람데이터들 불러오기
    let alarmManager = AlarmManager.shared
    
    // 리로드가 필요한 테이블뷰
    var reloadTable: UITableView?
    
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
    func requestAlarmNotification(_ date: Date?, type:String,title: String, subtitle: String, sound: String, repeatedly:Bool = false, withInterval interval: TimeInterval?, notificationId: String, _ dataIndex: Int?, needToReloadTableView: UITableView?, updateTarget: Date?){
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle
        content.categoryIdentifier = "Alarm"
        
        let sound = sound
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "\(sound).wav"))
        
        if let needToReloadTableView{
            reloadTable = needToReloadTableView
        }
        
        // 데이터 인덱스가 Alarm 뷰컨에서 전달되었으면 그대로 언래핑 후 사용
        // 데이터 인덱스가 Timer 뷰컨에서 전달되었으면 디폴트값 0 전달
        content.userInfo = ["updateTarget": dataIndex ?? -1]
            
        // 삼항연산자로 타입캐스팅
        let trigger = type == "Alarm" ?  getTrigger(type: type, date: date,interval: interval, notificationId: notificationId, dataIndex, updateTarget: updateTarget) as! UNCalendarNotificationTrigger : getTrigger(type: type, date: date, interval: interval, notificationId: notificationId, dataIndex, updateTarget: updateTarget) as! UNTimeIntervalNotificationTrigger
        
        let request = UNNotificationRequest(identifier: notificationId, content: content, trigger: trigger)
        
        setCustomAction(actionIdentifier: "dismiss", actionTitle: "알람", categoryIdentifier: "Alarm")
    
        // remove All peding notification requests
        // 타이머를 작동시키는 상황에서 알람 돌리면 기존 노티 삭제됨?
        NotificationService.sharedInstance.UNCurrentCenter.removePendingNotificationRequests(withIdentifiers: [notificationId])
        
        NotificationService.sharedInstance.UNCurrentCenter.add(request)
        
        UNCurrentCenter.getPendingNotificationRequests { reqs in
            print(reqs.count)
        }
    }
    
    func getTrigger(type: String, date: Date?, interval: TimeInterval?, notificationId: String, _ dataIndex: Int?, updateTarget: Date?) -> UNNotificationTrigger?{
        switch(type){
        case "Alarm":
            var date = date!
            
            // dateComponents => in: current 파라미터 설정으로 하면 안됨.
            var dateComponents = Calendar.current.dateComponents([.day,.month,.year,.hour,.minute], from: date)
        
            let currentDateComponents = Calendar.current.dateComponents([.day,.month,.year,.hour,.minute], from: Date.now)
            
            // 알람을 맞췄는데 해당 시간이 현재 시간보다 이전에 맞춰졌다면
            // 다음날에 대한 알람이므로 - 캘린더 트리거를 하루 뒤로 미뤄야함
            // 1. 날짜가 아예 24시간 기준으로 전날로 알람이 맞춰지는 경우
            // 2. 날짜는 동일하면서 현재시각이 알람시각보다 앞설때 -> 알람을 하루 미룬다
            // 3. 시간까지 동일하고 분단위가 알람시각보다 현재시각이 앞설때 -> 하루 미룬다
            if(currentDateComponents.day! > dateComponents.day! || currentDateComponents.hour! > dateComponents.hour! || (currentDateComponents.hour! == dateComponents.hour && currentDateComponents.minute! > dateComponents.minute!)){
                
                date = Calendar.current.date(byAdding: .hour,value: 24, to: date)!
                
                dateComponents = Calendar.current.dateComponents([.day,.month,.year,.hour,.minute], from: getCurrentDateFromSimulator(date: date))
                
                
                let _ = alarmManager.getSavedAlarm().map { data in
                    var newData = data
                    
                    if(updateTarget == data.time){
                        newData.time = date
                        alarmManager.updateAlarm(targetId: updateTarget!, newData: newData) {
                            print("time updated!")
                        }
                    }
                }
                
                UNCurrentCenter.removePendingNotificationRequests(withIdentifiers: [notificationId])
            }
            // 푸시알람을 하루 유예시킨 뒤에 alarmData 배열의 값도 코어데이터에 업데이트 시켜야됨
            
            return UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        case "Timer":
            let interval = interval!
            
            return UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: false)
        default:
            return nil
        }
    }
    
    func setCustomAction(actionIdentifier: String, actionTitle: String, categoryIdentifier: String){
        let customAction = UNNotificationAction(identifier: actionIdentifier, title: actionTitle, options: [])
        let category = UNNotificationCategory(identifier: categoryIdentifier, actions: [customAction], intentIdentifiers: [])
        
        self.UNCurrentCenter.setNotificationCategories([category])
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
        case "dismiss":
            print("custom")
        default:
            break
        }
        
        completionHandler()
    }
    
    // willPresent에서 isOn속성 제거
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        // 알람 탭에서 시작된 푸시알람이라면
        // isOn 속성 변경
        if(notification.request.content.userInfo["updateTarget"] as! Int != -1){
            let alarmDataList = alarmManager.getSavedAlarm()
            alarmDataList[notification.request.content.userInfo["updateTarget"] as! Int - 1].isOn = false
        }
        
        // 알람 탭의 테이블뷰가 저장속성에 로드되었다면
        // 알람 울림과 동시에 테이블뷰 리로딩
        if let reloadTable{
            reloadTable.reloadData()
        }
        
        let options: UNNotificationPresentationOptions = [.banner, .sound]
        completionHandler(options)
    }
    
}
