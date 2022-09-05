//
//  SectionsRepository.swift
//  Taski
//
//  Created by Sam Kishline
//

import Foundation
import CoreData

protocol SectionRepository: BaseRepository {}

struct SectionDataRepository: SectionRepository {
    
    func create(record: SectionInfo) {

        let cdSection = Sections(context: PersistentStorage.shared.context)
        cdSection.sectionId = record.sectionId
        cdSection.sectionName = record.sectionName
        
        if(record.taskInfo != nil && record.taskInfo?.count != 0) {
            var tasksSet = Set<Tasks>()
            record.taskInfo?.forEach({ (task) in

                let cdTasks = Tasks(context: PersistentStorage.shared.context)
                cdTasks.sectionId = task.sectionId
                cdTasks.taskName = task.taskName
                cdTasks.taskId = task.taskId
                cdTasks.isNotity = task.isNotify
                cdTasks.notificationTime = task.notifyTime
                tasksSet.insert(cdTasks)
            })

            cdSection.toTask = tasksSet
        }

        PersistentStorage.shared.saveContext()

    }

    func getAll() -> [SectionInfo]? {

        let sections = PersistentStorage.shared.fetchManagedObject(managedObject: Sections.self)
        guard sections != nil && sections?.count != 0 else { return nil }

        var results: [SectionInfo] = []
        sections!.forEach({ (cdSection) in
            results.append(cdSection.convertToSectionInfo())
        })

        return results
    }

    func get(byIdentifier id: Int64) -> SectionInfo? {

        let section = self.getCdSection(byId: id)
        guard section != nil else { return nil }

        return (section?.convertToSectionInfo())!
    }

    func update(record: SectionInfo) -> Bool {

        let section = getCdSection(byId: record.sectionId)
        guard section != nil else { return false }
        section?.sectionName = section?.sectionName
        
        if(record.taskInfo != nil && record.taskInfo?.count != 0) {
            var taskSet = Set<Tasks>()
            record.taskInfo?.forEach({ (task) in

                let cdTask = Tasks(context: PersistentStorage.shared.context)
                cdTask.sectionId = task.sectionId
                cdTask.taskId = task.taskId
                cdTask.taskName = task.taskName
                cdTask.isNotity = task.isNotify
                cdTask.notificationTime = task.notifyTime
                taskSet.insert(cdTask)
            })

            section?.toTask = taskSet
        }
        
        PersistentStorage.shared.saveContext()
        return true
    }

    func delete(byIdentifier id: Int64) -> Bool {

        let section = getCdSection(byId: id)
        guard section != nil else { return false }

        PersistentStorage.shared.context.delete(section!)
        PersistentStorage.shared.saveContext()

        return true
    }

    private func getCdSection(byId id: Int64) -> Sections? {
        let fetchRequest = NSFetchRequest<Sections>(entityName: "Sections")
        let fetchById = NSPredicate(format: "sectionId == %@", NSNumber(value: id))
        fetchRequest.predicate = fetchById

        let result = try! PersistentStorage.shared.context.fetch(fetchRequest)
        guard result.count != 0 else {return nil}

        return result.first
    }

    typealias T = SectionInfo
}
