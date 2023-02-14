//
//  WorldClockData+CoreDataProperties.swift
//  clock-app
//
//  Created by 박경준 on 2023/02/14.
//
//

import Foundation
import CoreData


extension WorldClockData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WorldClockData> {
        return NSFetchRequest<WorldClockData>(entityName: "WorldClockData")
    }

    @NSManaged public var timezone: String?
    @NSManaged public var date: Date?
    @NSManaged public var region: String?

}

extension WorldClockData : Identifiable {

}
