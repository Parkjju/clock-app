//
//  ClockDataManager.swift
//  clock-app
//
//  Created by 박경준 on 2023/02/14.
//

import Foundation

class ClockDataManager{
    static let shared = ClockDataManager()
    
    private init(){}
    
    func getWorldClockData() -> [(String, String)]{
        var worldClickArray:[(String, String)] = []
        
        
        for tz in TimeZone.knownTimeZoneIdentifiers{
            guard let timezone = TimeZone(identifier: tz) else {
                continue
            }
            
            guard let GMT = timezone.abbreviation() else {
                continue
            }
            
            guard var regionName = timezone.localizedName(for: .shortGeneric, locale: Locale(identifier:"ko-KR")) else {
                continue
            }
            
            // GMT + -로 시차 알아낼 수 있음.
//            guard var abbreviationName = timezone.localizedName(for: Foundation.NSTimeZone.NameStyle.shortStandard, locale: Locale(identifier:"ko-KR")) else {
//                continue
//            }
            
            var data = regionName.split(separator: " ")
            let _ = data.popLast()
            
            regionName = data.joined()
            
            let worldDate = Date()
            var selectedWorld = Date.FormatStyle.dateTime
            selectedWorld.timeZone = timezone
            
            worldClickArray.append((regionName, worldDate.formatted(selectedWorld)))
            
        }
        
        
        
        
        return worldClickArray
    }
}
