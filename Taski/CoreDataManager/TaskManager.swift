//
//  TaskManager.swift
//  Taski
//
//  Created by Sam Kishline
//

import Foundation

struct TaskManager {
    
    private let _tasksDataRepository = TasksDataRepository()
    
    func createTask(record: TaskInfo) {
        _tasksDataRepository.create(record: record)
    }

    func getAll() -> [TaskInfo]? {
        return _tasksDataRepository.getAll()
    }
    
    func getAll(for sectionId: Int64) -> [TaskInfo]? {
        return _tasksDataRepository.getAll(for: sectionId)
    }
    
    func deleteTasks(for taskId: Int64) -> Bool {
        return _tasksDataRepository.delete(byIdentifier: taskId)
    }
}
