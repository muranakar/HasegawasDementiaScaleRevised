//
//  RealmTimerAssessment.swift
//  TimerAssessment
//
//  Created by Takehito Koshimizu on 2022/02/20.
//

import Foundation
import RealmSwift

// MARK: - RealmTimerAssessment
/// 時間評価
final class RealmAssessment: Object {
    @Persisted(primaryKey: true)
    var uuidString = ""
    @Persisted
    var itemAge: Int = 0
    @Persisted
    var itemDateOrientation: Int = 0
    @Persisted
    var itemPlaceOrientation: Int = 0
    @Persisted
    var itemMemory: Int = 0
    @Persisted
    var itemCalculation: Int = 0
    @Persisted
    var itemDigitSpan: Int = 0
    @Persisted
    var itemDelayedPlayback: Int = 0
    @Persisted
    var itemVisualMemory: Int = 0
    @Persisted
    var itemWordRecall: Int = 0
    @Persisted
    var createdAt: Date!
    @Persisted
    var updatedAt: Date?
    @Persisted(originProperty: "assessments")
    var targetPersons: LinkingObjects<RealmTargetPerson>
}

extension RealmAssessment: RealmEntityObject {
    func update(value: Assessment) {
        itemAge = value.resultHDSR.itemAge
        itemDateOrientation = value.resultHDSR.itemDateOrientation
        itemPlaceOrientation = value.resultHDSR.itemPlaceOrientation
        itemMemory = value.resultHDSR.itemMemory
        itemCalculation = value.resultHDSR.itemCalculation
        itemDigitSpan = value.resultHDSR.itemDigitSpan
        itemDelayedPlayback = value.resultHDSR.itemDelayedPlayback
        itemVisualMemory = value.resultHDSR.itemVisualMemory
        itemWordRecall = value.resultHDSR.itemWordRecall
        createdAt = value.createdAt
        updatedAt = value.updatedAt
    }
}
