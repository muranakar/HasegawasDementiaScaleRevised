////
////  AssessmentResultFormatter.swift
////  TimerAssessment
////
////  Created by Takehito Koshimizu on 2022/02/19.
////
//
//import Foundation
//
//final class AssessmentResultPasteboardFormatter {
//    /// 評価日 formatter
//    private let evaluatedFormatter: DateFormatter = .evaluated()
//    /// 時間評価 formatter
//    private let resultTimeFormatter: ResultTimerFormatter = .init()
//
//    /// 評価結果
//    ///
//    /// 下記のフォーマットに整形する
//    ///
//    /// ```
//    /// 評価結果
//    /// 評価日:9999年99月99日 99時99分
//    /// 評価者:XXX
//    /// 対象者:XXX
//    /// 評価項目:XXX
//    /// 評価結果:99時99分99秒99
//    /// ```
//    func string(from timerAssessment: TimerAssessment) -> String? {
//        guard
//            let assessmentItem = timerAssessment.assessmentItem,
//            let targetPerson = assessmentItem.targetPerson,
//            let assessor = targetPerson.assessor
//        else {
//            return nil
//        }
//        return """
//        評価結果
//        評価日:\(evaluatedFormatter.string(from: timerAssessment.createdAt))
//        評価者:\(assessor.name)
//        対象者:\(targetPerson.name)
//        評価項目:\(assessmentItem.name)
//        評価結果:\(resultTimeFormatter.string(from: timerAssessment.resultTimer))
//        """
//    }
//}
