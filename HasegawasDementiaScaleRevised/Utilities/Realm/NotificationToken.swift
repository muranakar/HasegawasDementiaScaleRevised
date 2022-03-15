//
//  NotificationToken.swift
//  TimerAssessment
//
//  Created by Takehito Koshimizu on 2022/02/14.
//

import Foundation
import RealmSwift

protocol NotificationToken: AnyObject {
    func invalidate()
}

extension RealmSwift.NotificationToken: NotificationToken {
}
