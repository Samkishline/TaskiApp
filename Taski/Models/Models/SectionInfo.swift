//
//  SectionInfo.swift
//  Taski
//
//  Created by Sam Kishline
//

import Foundation

class SectionInfo {
    let sectionId: Int64
    let sectionName: String
    var taskInfo: [TaskInfo]?

    init(_sectionId: Int64, _sectionName: String, _taskInfo: [TaskInfo]? = nil) {
        self.sectionId = _sectionId
        self.sectionName = _sectionName
        self.taskInfo = _taskInfo
    }
}
