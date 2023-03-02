//
//  WorldClockData+CoreDataProperties.swift
//  clock-app
//
//  Created by Jun on 2023/03/02.
//
//

import Foundation
import CoreData


extension WorldClockData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WorldClockData> {
        return NSFetchRequest<WorldClockData>(entityName: "WorldClockData")
    }

    @NSManaged public var date: Date?
    @NSManaged public var index: Int64
    @NSManaged public var region: String?
    @NSManaged public var timezone: String?

}

extension WorldClockData : Identifiable {

}
