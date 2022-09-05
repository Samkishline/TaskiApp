//
//  Sections+CoreDataProperties.swift
//  Taski
//
//  Created by Sam Kishline
//

import Foundation
import CoreData


extension Sections {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Sections> {
        return NSFetchRequest<Sections>(entityName: "Sections")
    }

    @NSManaged public var sectionId: Int64
    @NSManaged public var sectionName: String?
    @NSManaged public var toTask: Set<Tasks>?

}

// MARK: Generated accessors for toTask
extension Sections {

    @objc(addToTaskObject:)
    @NSManaged public func addToToTask(_ value: Tasks)

    @objc(removeToTaskObject:)
    @NSManaged public func removeFromToTask(_ value: Tasks)

    @objc(addToTask:)
    @NSManaged public func addToToTask(_ values: Set<Tasks>)

    @objc(removeToTask:)
    @NSManaged public func removeFromToTask(_ values: Set<Tasks>)

}

extension Sections : Identifiable {

}
