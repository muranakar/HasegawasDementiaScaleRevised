//
//  TargetPerson.swift
//  TimerAssessment
//
//  Created by Takehito Koshimizu on 2022/02/13.
//

import Foundation

// MARK: -
extension TargetPerson {
    // MARK: ID
    // swiftlint:disable:next type_name
    struct ID: RawRepresentable {
        let rawValue: UUID

        var uuidString: String {
            rawValue.uuidString
        }
    }
}

// MARK: - TagetPerson
/// 対象者
struct TargetPerson {
    let id: ID
    var name: String
    let assessor: Assessor?
}

extension TargetPerson: Entity {
    init(name: String) {
        self.init(id: .init(rawValue: UUID()), name: name, assessor: nil)
    }

    init?(object: RealmTargetPerson) {
        guard let uuid = UUID(uuidString: object.uuidString) else {
            return nil
        }
        self.init(
            id: .init(rawValue: uuid),
            name: object.name,
            assessor: object.assessors.first.flatMap(Assessor.init)
        )
    }
}
