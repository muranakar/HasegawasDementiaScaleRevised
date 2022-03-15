//
//  Entity.swift
//  TimerAssessment
//
//  Created by Takehito Koshimizu on 2022/02/21.
//

import Foundation

// MARK: - Entity
protocol Entity {
    // swiftlint:disable:next type_name
    associatedtype ID: RawRepresentable where ID.RawValue == UUID
    associatedtype Object: RealmEntityObject
    var id: ID { get }
    init?(object: Object)
}
