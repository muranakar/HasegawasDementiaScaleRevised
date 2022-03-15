//
//  RealmAssessor.swift
//  TimerAssessment
//
//  Created by Takehito Koshimizu on 2022/02/20.
//

import Foundation
import RealmSwift

// MARK: - RealmAssessor
/// 評価者
final class RealmAssessor: Object {
    @Persisted(primaryKey: true)
    var uuidString = ""
    @Persisted
    var name = ""
    @Persisted
    var targetPersons: List<RealmTargetPerson>
}

extension RealmAssessor: RealmEntityParent {
    var childlen: List<RealmTargetPerson> {
        targetPersons
    }

    func update(value: Assessor) {
        name = value.name
    }
}
