//
//  AssessorRepository.swift
//  TimerAssessment
//
//  Created by Takehito Koshimizu on 2022/02/14.
//

import Foundation
import RealmSwift

// MARK: - AssessorRepository
protocol AssessorRepository {
    // MARK: Write object.
    /// 評価者を追加
    func add(value: Assessor)
    /// 評価者を更新
    func update(value: Assessor)
    /// 評価者を削除
    func remove(id: Assessor.ID)

    // MARK: Observe objects.
    /// 評価者の変更を監視
    func observe(callBack: @escaping ResultHandler<[Assessor]>) -> NotificationToken
}

// MARK: -
extension Repository: AssessorRepository where Value == Assessor, ParentValue == Never {
    /// 評価者のリポジトリ
    static func assessor(realm: Realm = .default, observingQueue: DispatchQueue = .observingQueue) -> Self {
        self.init(realm: realm, observingQueue: observingQueue)
    }
}
