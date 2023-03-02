//
//  AlarmData+CoreDataProperties.swift
//  clock-app
//
//  Created by Jun on 2023/03/02.
//
//

import Foundation
import CoreData


extension AlarmData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AlarmData> {
        return NSFetchRequest<AlarmData>(entityName: "AlarmData")
    }

    @NSManaged public var isAgain: Bool
    @NSManaged public var isOn: Bool
    @NSManaged public var repeatDays: [String]?
    @NSManaged public var label: String?
    @NSManaged public var sound: String?
    @NSManaged public var time: Int64

}

extension AlarmData : Identifiable {

}
