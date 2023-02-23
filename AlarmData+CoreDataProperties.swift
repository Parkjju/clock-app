//
//  AlarmData+CoreDataProperties.swift
//  clock-app
//
//  Created by 박경준 on 2023/02/23.
//
//

import Foundation
import CoreData


extension AlarmData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AlarmData> {
        return NSFetchRequest<AlarmData>(entityName: "AlarmData")
    }

    @NSManaged public var isOn: Bool
    @NSManaged public var time: Int64
    @NSManaged public var label: String?
    @NSManaged public var isRepeat: Bool
    @NSManaged public var sound: Int64
    @NSManaged public var isAgain: Bool

}

extension AlarmData : Identifiable {

}
