//
//  SwiftDataModels.swift
//  HasegawasDementiaScaleRevised
//
//  Realm から SwiftData へ移行したモデル定義。
//  uuidString は旧Realmの主キーをそのまま引き継ぐ（移行時の同一性担保のため）。
//

import Foundation
import SwiftData

// MARK: - Assessor
/// 評価者
@Model
final class Assessor {
    @Attribute(.unique) var uuidString: String = ""
    var name: String = ""
    var createdAt: Date = Date.distantPast

    @Relationship(deleteRule: .cascade, inverse: \TargetPerson.assessor)
    var targetPersons: [TargetPerson] = []

    init(uuidString: String = UUID().uuidString, name: String, createdAt: Date = .now) {
        self.uuidString = uuidString
        self.name = name
        self.createdAt = createdAt
    }

    var uuid: UUID? { UUID(uuidString: uuidString) }
}

// MARK: - TargetPerson
/// 対象者
@Model
final class TargetPerson {
    @Attribute(.unique) var uuidString: String = ""
    var name: String = ""
    var createdAt: Date = Date.distantPast

    var assessor: Assessor?

    @Relationship(deleteRule: .cascade, inverse: \Assessment.targetPerson)
    var assessments: [Assessment] = []

    init(uuidString: String = UUID().uuidString, name: String, createdAt: Date = .now) {
        self.uuidString = uuidString
        self.name = name
        self.createdAt = createdAt
    }

    var uuid: UUID? { UUID(uuidString: uuidString) }
}

// MARK: - Assessment
/// HDS-R評価
@Model
final class Assessment {
    @Attribute(.unique) var uuidString: String = ""

    var itemAge: Int = 0
    var itemDateOrientation: Int = 0
    var itemPlaceOrientation: Int = 0
    var itemMemory: Int = 0
    var itemCalculation: Int = 0
    var itemDigitSpan: Int = 0
    var itemDelayedPlayback: Int = 0
    var itemVisualMemory: Int = 0
    var itemWordRecall: Int = 0

    var createdAt: Date = Date.distantPast
    var updatedAt: Date?

    var targetPerson: TargetPerson?

    init(
        uuidString: String = UUID().uuidString,
        itemAge: Int = 0,
        itemDateOrientation: Int = 0,
        itemPlaceOrientation: Int = 0,
        itemMemory: Int = 0,
        itemCalculation: Int = 0,
        itemDigitSpan: Int = 0,
        itemDelayedPlayback: Int = 0,
        itemVisualMemory: Int = 0,
        itemWordRecall: Int = 0,
        createdAt: Date = .now,
        updatedAt: Date? = nil
    ) {
        self.uuidString = uuidString
        self.itemAge = itemAge
        self.itemDateOrientation = itemDateOrientation
        self.itemPlaceOrientation = itemPlaceOrientation
        self.itemMemory = itemMemory
        self.itemCalculation = itemCalculation
        self.itemDigitSpan = itemDigitSpan
        self.itemDelayedPlayback = itemDelayedPlayback
        self.itemVisualMemory = itemVisualMemory
        self.itemWordRecall = itemWordRecall
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    /// 9項目を評価順で並べた配列
    convenience init(results: [Int], createdAt: Date = .now) {
        self.init(
            itemAge: results[safe: 0] ?? 0,
            itemDateOrientation: results[safe: 1] ?? 0,
            itemPlaceOrientation: results[safe: 2] ?? 0,
            itemMemory: results[safe: 3] ?? 0,
            itemCalculation: results[safe: 4] ?? 0,
            itemDigitSpan: results[safe: 5] ?? 0,
            itemDelayedPlayback: results[safe: 6] ?? 0,
            itemVisualMemory: results[safe: 7] ?? 0,
            itemWordRecall: results[safe: 8] ?? 0,
            createdAt: createdAt
        )
    }
}

// MARK: - Assessment 集計
extension Assessment {
    /// 評価項目名（評価順）
    static let hdsrItemName = [
        "年齢",
        "日付の見当識",
        "場所の見当識",
        "即時記憶",
        "計算",
        "逆唱",
        "遅延再生",
        "視覚記憶",
        "語想起・流暢性"
    ]

    /// 満点（30点）
    static let fullScore = 30

    /// 各項目の満点（評価順）。HDSR.json の選択肢の最高点と一致する
    static let hdsrItemFullScore = [1, 4, 2, 3, 2, 2, 6, 5, 5]

    /// 各項目の得点（評価順）
    var hdsrItemResult: [Int] {
        [
            itemAge,
            itemDateOrientation,
            itemPlaceOrientation,
            itemMemory,
            itemCalculation,
            itemDigitSpan,
            itemDelayedPlayback,
            itemVisualMemory,
            itemWordRecall
        ]
    }

    /// 合計点
    var hdsrItemSum: Int {
        hdsrItemResult.reduce(0, +)
    }
}

// MARK: -
private extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
