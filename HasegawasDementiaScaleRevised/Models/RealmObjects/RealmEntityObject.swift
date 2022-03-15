//
//  RealmEntityObject.swift
//  TimerAssessment
//
//  Created by Takehito Koshimizu on 2022/02/21.
//

import Foundation
import RealmSwift

// MARK: - RealmEntityObject
protocol RealmEntityObject: RealmSwift.Object {
    associatedtype Value: Entity
    var uuidString: String { get set }
    func update(value: Value)
}

// MARK: -
extension RealmEntityObject {
    init(value: Value) {
        self.init()
        uuidString = value.id.rawValue.uuidString
        update(value: value)
    }
}

// MARK: - RealmEntityParent
protocol RealmEntityParent: RealmEntityObject {
    associatedtype Child: RealmCollectionValue
    var childlen: List<Child> { get }
}
