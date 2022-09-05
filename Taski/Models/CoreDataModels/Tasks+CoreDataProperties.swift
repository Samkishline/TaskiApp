//
//  Tasks+CoreDataProperties.swift
//  Taski
//
//  Created by Sam Kishline
//

import Foundation
import CoreData


extension Tasks {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tasks> {
        return NSFetchRequest<Tasks>(entityName: "Tasks")
    }

    @NSManaged public var isNotity: Bool
    @NSManaged public var notificationTime: Date?
    @NSManaged public var sectionId: Int64
    @NSManaged public var taskId: Int64
    @NSManaged public var taskName: String?
    @NSManaged public var toSection: Sections?

}

extension Tasks : Identifiable {

}
