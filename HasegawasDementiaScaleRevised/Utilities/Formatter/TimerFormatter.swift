//
//  TimerFormatter.swift
//  TimerAssessment
//
//  Created by Takehito Koshimizu on 2022/02/18.
//

import Foundation

/// タイマーのformatter
final class TimerFormatter {
    func string(from absoluteTime: Double) -> String {
        var (min, sec, msec): (Int, Int, Int)
        (sec, msec) = Int(absoluteTime * 100).quotientAndRemainder(dividingBy: 100)
        (min, sec) = sec.quotientAndRemainder(dividingBy: 60)
        return String(format: "%02ld:%02ld:%02ld", min, sec, msec)
    }
}

/// 時間評価のformatter
final class ResultTimerFormatter {
    func string<R: RawRepresentable>(from value: R) -> String where R.RawValue == Double {
        string(from: value.rawValue)
    }

    func string(from resultTimer: Double) -> String {
        var (hour, min, sec, msec): (Int, Int, Int, Int)
        (sec, msec) = Int(resultTimer * 100).quotientAndRemainder(dividingBy: 100)
        (min, sec) = sec.quotientAndRemainder(dividingBy: 60)
        (hour, min) = min.quotientAndRemainder(dividingBy: 60)
        switch (hour, min, sec, msec) {
        case let (0, 0, sec, msec):
            return String(format: "%02ld秒%02ld", sec, msec)
        case let (0, min, sec, msec):
            return String(format: "%02ld分%02ld秒%02ld", min, sec, msec)
        case let (hour, min, sec, msec):
            return String(format: "%02ld時%02ld分%02ld秒%02ld", hour, min, sec, msec)
        }
    }
}
