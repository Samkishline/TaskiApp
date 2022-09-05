//
//  Sections+Extensions.swift
//  Taski
//
//  Created by Sam Kishline
//

import Foundation

extension Sections {
    
    func convertToSectionInfo() -> SectionInfo {
        return SectionInfo(_sectionId: self.sectionId, _sectionName: self.sectionName ?? "", _taskInfo: self.convertToTasks())
    }

    private func convertToTasks() -> [TaskInfo]? {
        guard self.toTask != nil && self.toTask?.count != 0 else { return nil }

        var tasks: [TaskInfo] = []

        self.toTask?.forEach({ cdTask in
            tasks.append(cdTask.convertToTask())
        })

        return tasks
    }
}
