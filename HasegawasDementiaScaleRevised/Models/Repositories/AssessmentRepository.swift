//
//  TimerAssessmentRepository.swift
//  TimerAssessment
//
//  Created by Takehito Koshimizu on 2022/02/18.
//

import Foundation
import RealmSwift

// MARK: - TimerAssessmentRepository
protocol AssessmentRepository {
    // MARK: Read objects.
    /// 時間評価を読込む
    func load(id: Assessment.ID) -> Assessment?
    /// 該当評価項目に関連したすべての時間評価を読込む
    /// - Parameters:
    ///   - sortKey: ソート対象のプロパティ名
    ///   - ascending: 昇順の場合は `true`
    func load(id: TargetPerson.ID, sortKey: String, ascending: Bool) -> [Assessment]

    // MARK: Write object.
    /// 該当評価項目に時間評価を追加
    func add(value: Assessment, id: TargetPerson.ID)
    /// 時間評価を更新
    func update(value: Assessment)
    /// 時間評価を削除
    func remove(id: Assessment.ID)

    // MARK: Observe objects.
    /// 該当評価項目の時間評価の変更を監視
    /// - Parameters:
    ///   - id: 評価項目の一意識別子
    ///   - sortKey: ソート対象のプロパティ名
    ///   - ascending: 昇順の場合は `true`
    ///   - callBack: 変更時のコールバックハンドラ
    func observe(
        id: TargetPerson.ID,
        sortKey: String,
        ascending: @escaping () -> Bool?,
        callBack: @escaping ResultHandler<[Assessment]>
    ) -> NotificationToken
}

// MARK: -
extension Repository: AssessmentRepository where Value == Assessment, ParentValue == TargetPerson {
    static func assessment(realm: Realm = .default, observingQueue: DispatchQueue = .observingQueue) -> Self {
        self.init(realm: realm, observingQueue: observingQueue)
    }
}
