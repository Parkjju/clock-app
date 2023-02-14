//
//  WorldClock+CoreDataProperties.swift
//  clock-app
//
//  Created by 박경준 on 2023/02/14.
//
//

import Foundation
import CoreData


extension WorldClock {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WorldClock> {
        return NSFetchRequest<WorldClock>(entityName: "WorldClock")
    }

    @NSManaged public var offset: Int64
    @NSManaged public var region: String?
    @NSManaged public var time: Date?

}

extension WorldClock : Identifiable {

}
