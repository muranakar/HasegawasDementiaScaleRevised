//
//  RealmTargetPerson.swift
//  TimerAssessment
//
//  Created by Takehito Koshimizu on 2022/02/20.
//

import Foundation
import RealmSwift

// MARK: - RealmTagetPerson
/// 対象者
final class RealmTargetPerson: Object {
    @Persisted(primaryKey: true)
    var uuidString = ""
    @Persisted
    var name = ""
    @Persisted
    var assessments: List<RealmAssessment>
    @Persisted(originProperty: "targetPersons")
    var assessors: LinkingObjects<RealmAssessor>
}

extension RealmTargetPerson: RealmEntityParent {
    var childlen: List<RealmAssessment> {
        assessments
    }

    func update(value: TargetPerson) {
        name = value.name
    }
}
