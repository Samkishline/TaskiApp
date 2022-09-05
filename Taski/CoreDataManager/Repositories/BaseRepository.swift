//
//  BaseRepository.swift
//  Taski
//
//  Created by Sam Kishline
//

import Foundation

protocol BaseRepository {

    associatedtype T

    func create(record: T)
    func getAll() -> [T]?
    func get(byIdentifier id: Int64) -> T?
    func update(record: T) -> Bool
    func delete(byIdentifier id: Int64) -> Bool
}
