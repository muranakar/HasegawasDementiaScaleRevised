//
//  DateFormatter.swift
//  TimerAssessment
//
//  Created by Takehito Koshimizu on 2022/02/20.
//

import Foundation

extension DateFormatter {
    /// 評価日の `DateFormatter`
    static func evaluated() -> Self {
        let formatter = self.init()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateStyle = .medium
        formatter.dateFormat = "yyyy'年'MM'月'dd'日' HH'時'mm'分'"
        return formatter
    }
}
