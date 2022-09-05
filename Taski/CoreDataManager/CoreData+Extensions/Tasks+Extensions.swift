//
//  Tasks+Extensions.swift
//  Taski
//
//  Created by Sam Kishline
//

import Foundation

extension Tasks {
    
    func convertToTask() -> TaskInfo {
        return TaskInfo(_taskId: self.taskId, _taskName: self.taskName ?? "", _sectionId: self.sectionId, _isNotify: self.isNotity, _notifyTime: self.notificationTime)
    }
}
