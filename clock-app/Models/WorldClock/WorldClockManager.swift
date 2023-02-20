//
//  WorldClockManager.swift
//  clock-app
//
//  Created by 박경준 on 2023/02/14.
//

import UIKit
import CoreData

class WorldClockManager{
    
    static let shared = WorldClockManager()
    
    private var KST: String{
        get{
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "ko_KR")
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.dateFormat = "yyyy/MM/d HH:mm"
            return dateFormatter.string(from: Date())
        }
    }
    
    private init(){}
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    lazy var context = appDelegate?.persistentContainer.viewContext
    
    let modelName = "WorldClockData"
    
    // 1. 저장한 전체 세계시간 목록 가져오기
    func getSavedWorldClock() -> [WorldClockData]{
        var result: [WorldClockData] = []
        
        if let context = context {
            let request = NSFetchRequest<NSManagedObject>(entityName: self.modelName)
            
            let indexOrder = NSSortDescriptor(key: "index", ascending: true)
            request.sortDescriptors = [indexOrder]
            
            do{
                if let fetchedClock = try context.fetch(request) as? [WorldClockData] {
                    result = fetchedClock
                }
            }catch {
                print("get all clock logic error")
            }
            
        }
        
        return result
    }
    
    // 2. 세계시간 새로 저장하기
    func saveWorldClockData(newRegion:String, newTimezone: TimeZone, completion: @escaping () -> Void){
        guard let context = context else {
            print("Create: context error")
            completion()
            return
        }
        
        guard let entity = NSEntityDescription.entity(forEntityName: self.modelName, in: context) else {
            print("Create: Entity description error")
            completion()
            return
        }
        
        guard let newWorldClock = NSManagedObject(entity: entity, insertInto: context) as? WorldClockData else {
            print("Create: New Entity create error")
            completion()
            return
        }
        
        newWorldClock.timezone = newTimezone.identifier
        newWorldClock.region = newRegion
        newWorldClock.date = Date()
        newWorldClock.index = Int64(getSavedWorldClock().count - 1)
        
        
        if(context.hasChanges){
            do{
                try context.save()
                completion()
            } catch {
                print("Create: Context save error")
                completion()
            }
        }
    }
    
    // 3. iOS 자체 타임존 목록 불러오기
    func getWorldClockData() -> [(String, TimeZone)]{
        var worldClickArray:[(String, TimeZone)] = []
        
        
        for tz in TimeZone.knownTimeZoneIdentifiers{
            guard let timezone = TimeZone(identifier: tz) else {
                continue
            }

            guard var regionName = timezone.localizedName(for: .shortGeneric, locale: Locale(identifier:"ko-KR")) else {
                continue
            }
            
            var data = regionName.split(separator: " ")
            let _ = data.popLast()
            
            regionName = data.joined()
            
            // 정규식 검사 로직
            if(!nameValidation(text: regionName) || regionName.first == nil){
                continue
            }
        
            var selectedWorld = Date.FormatStyle.dateTime
            selectedWorld.timeZone = timezone
            
            worldClickArray.append((regionName, timezone))
        }
        
        worldClickArray.sort { lhs, rhs in
            lhs.0 < rhs.0
        }
        
        
        return worldClickArray
    }
    
    
    private func nameValidation(text: String) -> Bool {
        // String -> Array
        let arr = Array(text)
        // 정규식 pattern. 한글, 영어, 숫자, 밑줄(_)만 있어야함
        let pattern = "^[가-힣ㄱ-ㅎㅏ-ㅣ]$"
        if let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) {
            var index = 0
            while index < arr.count { // string 내 각 문자 하나하나 마다 정규식 체크 후 충족하지 못한것은 제거.
                let results = regex.matches(in: String(arr[index]), options: [], range: NSRange(location: 0, length: 1))
                if results.count == 0 {
                    return false
                } else {
                    index += 1
                }
            }
        }
        return true
    }
    
    func getTimeFromTimeZone(timezone: String, isNoon: Bool) -> String{
        
        guard let timezone = TimeZone(identifier: timezone) else {
            return ""
        }
        
        let worldDate = Date()
        var selectedWorld = Date.FormatStyle.dateTime
        selectedWorld.timeZone = timezone
        
        var time = worldDate.formatted(selectedWorld).split(separator: " ")
        time.removeFirst()
        
        if(time.last! == "AM" || time.last! == "PM"){
            
            return isNoon ? "\(time.last! == "AM" ? "오전" : "오후")" : "\(time.first!)"
        }
        
        return isNoon ? "\(time.first!)" : "\(time.last!)"
    }
    
    // GMT+0, GMT+1 등 T기준 스플릿해서 마지막요소 리턴
    func getOffsetFromTimeZone(timezone: String) -> String{
        guard let timezone = TimeZone(identifier: timezone) else {
            return ""
        }
        
        guard let abbreviationName = timezone.localizedName(for: Foundation.NSTimeZone.NameStyle.shortStandard, locale: Locale(identifier:"ko-KR")) else {
            return ""
        }
        
        let isTodayString = checkIsToday(timezone: timezone)
        
        let splitArray = abbreviationName.split(separator: "T")
        
        // GMT+0으로 숫자표기가 아닌 GMT만 남아있으면 GMT+0으로 가정
        // GMT일때 -9인지 +9인지 모름. TODO!
        if(splitArray.count == 1){
            return "오늘, +9시간"
        }
        
        // TODO - 반례 +5:45, 분단위 GMT에러처리 필요.
        let result = Int(splitArray.last!)!
        
        // 오늘인지 어제인지 판단 여부를 알아야하는데 그건 타임존에서 가능하다
        return 9 - result > 0 ? "\(isTodayString), -\(9 - result)시간" : "\(isTodayString), +\(result - 9)시간"
    }
    
    private func checkIsToday(timezone: TimeZone) -> String{
        let worldDate = Date()
        var selectedWorld = Date.FormatStyle.dateTime
        selectedWorld.timeZone = timezone
        
        // 2/13/2023 오후 11:35 - formattedString 예시
        let formattedString = worldDate.formatted(selectedWorld)
        
        let date =  formattedString.split(separator: " ").first!
        var dateArray = date.split(separator: "/")
        
        // 2/13/2013중에 13일만 남기고 전체 삭제
        dateArray.removeFirst()
        let _ = dateArray.popLast()
        
        
        // 한국 시간 KST 계산속성에서 얻어오기
        let KSTArray = self.KST.split(separator: " ")
        
        let KSTDateArray = KSTArray.first!.split(separator: "/")
        
        if(Int("\(KSTDateArray.last!)")! < Int(dateArray.first!)!){
            return "내일"
        }else if(Int("\(KSTDateArray.last!)")! == Int(dateArray.first!)!){
            return "오늘"
        }else{
            return "어제"
        }
    }
    
    func removeClock(deleteTarget: WorldClockData, completion: @escaping () -> Void){
        guard let context = context else {
            print("removeClock: context load error")
            completion()
            return
        }
        
        guard let targetId = deleteTarget.date else {
            print("removeClock: remove target id error")
            completion()
            return
        }
        
        let request = NSFetchRequest<NSManagedObject>(entityName: self.modelName)
        request.predicate = NSPredicate(format: "date = %@", targetId as CVarArg)
        
        do{
            guard let fetchData = try context.fetch(request) as? [WorldClockData] else {
                print("removeClock: fetch error")
                completion()
                return
            }
            
            guard let data = fetchData.first else {
                print("removeClock: data indexing error")
                completion()
                return
            }
            
            context.delete(data)
            
            do{
                try context.save()
                completion()
            }catch{
                print("removeClock: context save error")
                completion()
            }
            
            
        }catch {
            
        }
    }
    
    func updateIndex(sourceData: WorldClockData, destinationData: WorldClockData, completion: @escaping () -> Void){
        let destinationIndex = destinationData.index
        let sourceIndex = sourceData.index
        // ArraySlice 활용
        // 1. source 데이터 빼오기
        // 2. destination index에 끼워넣기
        // 3. 전체 Array 인덱스값 업데이트
        // 4. 코어데이터 컨텍스트 저장
        guard let context = context else {
            print("updateIndex: context load error")
            return
        }
        
        // 코어데이터는 순서에 대한 표기가 불가능하기 때문에 Index 프로퍼티를 가지고 표현해야한다.
        // index 프로퍼티를 업데이트 하려면?
        // 1. 전체 데이터를 fetch하고 데이터를 변경해준다
        
        let fetchAllRequest = NSFetchRequest<NSManagedObject>(entityName: self.modelName)
        let indexOrder = NSSortDescriptor(key: "index", ascending: true)
        fetchAllRequest.sortDescriptors = [indexOrder]
        
        do{
            guard var fetchedData = try context.fetch(fetchAllRequest) as? [WorldClockData] else {
                completion()
                return
            }
            
            // 데이터 추가 후 index ascending으로 fetch까지는 문제없이 됨.
            // int64나 int나 대수비교에는 큰 차이 없음
            if(sourceData.index < destinationData.index){
                for idx in sourceIndex ..< destinationIndex + 1{
                    if(idx == 0){
                        continue
                    }
                    fetchedData[Int(idx)].index -= 1
                }
                fetchedData[Int(sourceIndex)].index = destinationIndex
            }else{
                for idx in destinationIndex ..< sourceIndex + 1 {
                    fetchedData[Int(idx)].index += 1
                }
                fetchedData[Int(sourceIndex)].index = destinationIndex
            }
            
            
            print("=======최종!=======")
            print(fetchedData)
            do{
                try context.save()
                completion()
            }catch{
                print("updateIndex: context save error")
                completion()
            }
        }catch{
            print("ERROR in updateIndex")
        }
        
    }
    
}


