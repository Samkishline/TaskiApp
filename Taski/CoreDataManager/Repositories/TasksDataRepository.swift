//
//  TasksDataRepository.swift
//  Taski
//
//  Created by Sam Kishline
//

import Foundation
import CoreData

protocol TasksRepository: BaseRepository {}

struct TasksDataRepository: TasksRepository {
    
    func create(record: TaskInfo) {

        let cdTask = Tasks(context: PersistentStorage.shared.context)
        cdTask.taskId = record.taskId
        cdTask.taskName = record.taskName
        cdTask.sectionId = record.sectionId
        cdTask.isNotity = record.isNotify
        cdTask.notificationTime = record.notifyTime
        
        PersistentStorage.shared.saveContext()
    }

    func getAll() -> [TaskInfo]? {

        let sections = PersistentStorage.shared.fetchManagedObject(managedObject: Tasks.self)
        guard sections != nil && sections?.count != 0 else { return nil }

        var results: [TaskInfo] = []
        sections!.forEach({ (cdTask) in
            results.append(cdTask.convertToTask())
        })

        return results
    }
    
    func getAll(for sectionId: Int64) -> [TaskInfo]? {

        let fetchRequest = NSFetchRequest<Tasks>(entityName: "Tasks")
        let fetchById = NSPredicate(format: "sectionId == %@", NSNumber(value: sectionId))
        fetchRequest.predicate = fetchById

        let result = try! PersistentStorage.shared.context.fetch(fetchRequest)
        guard result.count != 0 else { return nil }

        var results: [TaskInfo] = []
        result.forEach({ (cdTask) in
            results.append(cdTask.convertToTask())
        })

        return results
    }

    func get(byIdentifier id: Int64) -> TaskInfo? {

        let section = self.getCdTask(byId: id)
        guard section != nil else { return nil }

        return (section?.convertToTask())!
    }

    func update(record: TaskInfo) -> Bool {

        let section = getCdTask(byId: record.taskId)
        guard section != nil else { return false }
        section?.taskId = record.taskId

        PersistentStorage.shared.saveContext()
        return true
    }

    func delete(byIdentifier id: Int64) -> Bool {

        let section = getCdTask(byId: id)
        guard section != nil else { return false }

        PersistentStorage.shared.context.delete(section!)
        PersistentStorage.shared.saveContext()

        return true
    }

    private func getCdTask(byId id: Int64) -> Tasks? {
        let fetchRequest = NSFetchRequest<Tasks>(entityName: "Tasks")
        let fetchById = NSPredicate(format: "taskId == %@", NSNumber(value: id))
        fetchRequest.predicate = fetchById

        let result = try! PersistentStorage.shared.context.fetch(fetchRequest)
        guard result.count != 0 else {return nil}

        return result.first
    }

    typealias T = TaskInfo
}
