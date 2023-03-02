//
//  AlarmManager.swift
//  clock-app
//
//  Created by 박경준 on 2023/02/21.
//

import UIKit
import CoreData

class AlarmManager{
    static let shared = AlarmManager()
    
    private init(){}
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    lazy var context = appDelegate?.persistentContainer.viewContext
    
    let modelName = "AlarmData"
    
    
    // 1. 코어데이터에서 저장된 알람정보 전부 가져오기
    func getSavedAlarm() -> [AlarmData] {
        var data: [AlarmData] = []
        guard let context = context else {
            print("getSavedAlarm: context load error")
            return []
        }
        
        let request = NSFetchRequest<NSManagedObject>(entityName: "AlarmData")
        
        let descriptor = NSSortDescriptor(key: "time", ascending: true)
        
        request.sortDescriptors = [descriptor]
        
        do{
            guard let fetchedData = try context.fetch(request) as? [AlarmData] else {
                print("getSavedAlarm: fetch error")
                return data
            }
            
            data = fetchedData
        }catch{
            print("error")
        }
        
        return data
    }
    
    // 2. 코어데이터에 알람정보 저장하기
    func saveAlarm(isOn: Bool, time: Date, label: String, isAgain: Bool, repeatDays: String, sound: String , completion: @escaping () -> Void){
        guard let context = context else {
            print("saveAlarm: context load error")
            return
        }
        
        guard let entity = NSEntityDescription.entity(forEntityName:self.modelName , in: context) else {
            return
        }
        
        guard let newAlarm = NSManagedObject(entity: entity, insertInto: context) as? AlarmData else {
            print("saveAlarm: entity insert error")
            return
        }
        
        newAlarm.isOn = isOn
        newAlarm.time = time
        newAlarm.label = label
        newAlarm.isAgain = isAgain
        newAlarm.repeatDays = repeatDays
        newAlarm.sound = sound
        
        if(context.hasChanges){
            do{
                try context.save()
                completion()
            }catch{
                print("saveAlarm: context save error")
                completion()
            }
        }
        
    }
    
}

// 커스텀 델리게이트 패턴 정의
protocol AlarmManagerDelegate{
    // 요일정보 업데이트 후 테이블뷰에 저장해야됨.
    // daylist를 detail viewController에서 파라미터에 전달하면
    // Repeat setting view controller에서 자신의 테이블 뷰 중 repeat label에 세팅하고, 코어데이터에도 추후 저장해야됨.
    func repeatUpdate(index: Int)
}

protocol AlarmSoundDelegate{
    func soundUpdate(index: Int)
}
