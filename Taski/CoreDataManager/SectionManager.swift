//
//  SectionManager.swift
//  Taski
//
//  Created by Sam Kishline
//

import Foundation

struct SectionManager {
    
    private let _sectionDataRepository = SectionDataRepository()
    
    func createSection(record: SectionInfo) -> Bool {
        _sectionDataRepository.create(record: record)
        return true
    }
    
    func updateSection(record: SectionInfo) -> Bool {
        return _sectionDataRepository.update(record: record)
    }

    func getAll() -> [SectionInfo]? {
        return _sectionDataRepository.getAll()
    }
    
    func deleteSection(for sectionId: Int64) -> Bool {
        return _sectionDataRepository.delete(byIdentifier: sectionId)
    }
}
