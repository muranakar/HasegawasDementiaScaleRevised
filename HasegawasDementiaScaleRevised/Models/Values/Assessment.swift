//
//  TimerAssessment.swift
//  TimerAssessment
//
//  Created by 村中令 on 2022/01/26.
//

import Foundation

// MARK: -
extension Assessment {
    // MARK: ID
    // swiftlint:disable:next type_name
    struct ID: RawRepresentable {
        let rawValue: UUID

        var uuidString: String {
            rawValue.uuidString
        }
    }

    // MARK: Time
    struct HDSR {
        var itemAge: Int
        var itemDateOrientation: Int
        var itemPlaceOrientation: Int
        var itemMemory: Int
        var itemCalculation: Int
        var itemDigitSpan: Int
        var itemDelayedPlayback: Int
        var itemVisualMemory: Int
        var itemWordRecall: Int
    }
}

// MARK: - TimerAssessment
/// 時間評価
struct Assessment {
    let id: ID
    var resultHDSR: HDSR
    var createdAt = Date()
    var updatedAt: Date?
    let targetPerson: TargetPerson?
}

extension Assessment: Entity {
    init(resultHDSR: HDSR) {
        self.init(id: .init(rawValue: UUID()), resultHDSR: resultHDSR, targetPerson: nil)
    }

    init?(object: RealmAssessment) {
        guard let uuid = UUID(uuidString: object.uuidString) else {
            return nil
        }
        self.init(
            id: .init(rawValue: uuid),
            resultHDSR: .init(
                itemAge: object.itemAge,
                itemDateOrientation: object.itemDateOrientation,
                itemPlaceOrientation: object.itemPlaceOrientation,
                itemMemory: object.itemMemory,
                itemCalculation: object.itemCalculation,
                itemDigitSpan: object.itemDigitSpan,
                itemDelayedPlayback: object.itemDelayedPlayback,
                itemVisualMemory: object.itemVisualMemory,
                itemWordRecall: object.itemWordRecall),
            createdAt: object.createdAt,
            updatedAt: object.updatedAt,
            targetPerson: object.targetPersons.first.flatMap(TargetPerson.init)
        )
    }
}
