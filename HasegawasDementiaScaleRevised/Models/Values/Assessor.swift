//
//  Assessor.swift
//  TimerAssessment
//
//  Created by Takehito Koshimizu on 2022/02/14.
//

import Foundation

// MARK: -
extension Assessor {
    // MARK: ID
    // swiftlint:disable:next type_name
    struct ID: RawRepresentable {
        let rawValue: UUID

        var uuidString: String {
            rawValue.uuidString
        }
    }
}

// MARK: - Assessor
/// 評価者
struct Assessor {
    let id: ID
    var name: String
}

extension Assessor: Entity {
    init(name: String) {
        self.init(id: .init(rawValue: UUID()), name: name)
    }

    init?(object: RealmAssessor) {
        guard let uuid = UUID(uuidString: object.uuidString) else {
            return nil
        }
        self.init(
            id: .init(rawValue: uuid),
            name: object.name
        )
    }
}
