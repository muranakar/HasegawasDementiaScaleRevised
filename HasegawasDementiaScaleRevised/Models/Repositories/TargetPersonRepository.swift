//
//  TargetPersonRepository.swift
//  TimerAssessment
//
//  Created by Takehito Koshimizu on 2022/02/13.
//

import Foundation
import RealmSwift

// MARK: - TargetPersonRepository
protocol TargetPersonRepository {
    // MARK: Write object.
    /// 該当評価者に対象者を追加
    func add(value: TargetPerson, id: Assessor.ID)
    /// 対象者を更新
    func update(value: TargetPerson)
    /// 対象者を削除
    func remove(id: TargetPerson.ID)

    // MARK: Observe objects.
    /// 該当評価者の対象者の変更を監視
    func observe(id: Assessor.ID, callBack: @escaping ResultHandler<[TargetPerson]>) -> NotificationToken
}

// MARK: -
extension Repository: TargetPersonRepository where Value == TargetPerson, ParentValue == Assessor {
    /// 対象者のリポジトリ
    static func targetPerson(realm: Realm = .default, observingQueue: DispatchQueue = .observingQueue) -> Self {
        self.init(realm: realm, observingQueue: observingQueue)
    }
}
