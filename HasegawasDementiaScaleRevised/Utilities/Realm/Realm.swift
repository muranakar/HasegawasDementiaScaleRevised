//
//  Realm.swift
//  TimerAssessment
//
//  Created by Takehito Koshimizu on 2022/02/14.
//

import Foundation
import RealmSwift

extension Realm {
    static let `default`: Realm = {
        // swiftlint:disable:next force_cast
        try! Realm()
    }()
}
