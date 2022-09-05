//
//  TaskInfo.swift
//  Taski
//
//  Created by Sam Kishline
//

import Foundation

class TaskInfo {
    let taskId: Int64
    let taskName: String
    let sectionId: Int64
    var isNotify: Bool
    var notifyTime: Date?
    
    init(_taskId: Int64, _taskName: String, _sectionId: Int64, _isNotify: Bool, _notifyTime: Date? = nil) {
        self.taskId = _taskId
        self.taskName = _taskName
        self.sectionId = _sectionId
        self.isNotify = _isNotify
        self.notifyTime = _notifyTime
    }
}
