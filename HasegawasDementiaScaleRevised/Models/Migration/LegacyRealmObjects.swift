//
//  LegacyRealmObjects.swift
//  HasegawasDementiaScaleRevised
//
//  旧バージョン（〜1.1.5）が保存した Realm ファイルを読み取るためだけの定義。
//  Realm はクラス名をそのままスキーマ名として使うため、
//  既存ファイルを読めるようクラス名は当時のまま変更しないこと。
//

import Foundation
import RealmSwift

// MARK: - RealmAssessor
final class RealmAssessor: Object {
    @Persisted(primaryKey: true) var uuidString = ""
    @Persisted var name = ""
    @Persisted var targetPersons: List<RealmTargetPerson>
}

// MARK: - RealmTargetPerson
final class RealmTargetPerson: Object {
    @Persisted(primaryKey: true) var uuidString = ""
    @Persisted var name = ""
    @Persisted var assessments: List<RealmAssessment>
    @Persisted(originProperty: "targetPersons") var assessors: LinkingObjects<RealmAssessor>
}

// MARK: - RealmAssessment
final class RealmAssessment: Object {
    @Persisted(primaryKey: true) var uuidString = ""
    @Persisted var itemAge: Int = 0
    @Persisted var itemDateOrientation: Int = 0
    @Persisted var itemPlaceOrientation: Int = 0
    @Persisted var itemMemory: Int = 0
    @Persisted var itemCalculation: Int = 0
    @Persisted var itemDigitSpan: Int = 0
    @Persisted var itemDelayedPlayback: Int = 0
    @Persisted var itemVisualMemory: Int = 0
    @Persisted var itemWordRecall: Int = 0
    @Persisted var createdAt: Date?
    @Persisted var updatedAt: Date?
    @Persisted(originProperty: "assessments") var targetPersons: LinkingObjects<RealmTargetPerson>
}
