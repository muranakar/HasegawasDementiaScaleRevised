//
//  AssessmentResultFormatter.swift
//  TimerAssessment
//
//  Created by Takehito Koshimizu on 2022/02/19.
//

import Foundation

final class AssessmentResultPasteboardFormatter {
    /// 評価日 formatter
    private let evaluatedFormatter: DateFormatter = .evaluated()
    /// 評価結果
    ///
    /// 下記のフォーマットに整形する
    ///
    /// ```
    /// 評価結果
    /// 評価日:9999年99月99日 99時99分
    /// 評価者:XXX
    /// 対象者:XXX
    /// 評価項目:XXX
    /// 評価結果:
    /// ```
    func string(from assessment: Assessment) -> String? {
        guard
            let targetPerson = assessment.targetPerson,
            let assessor = targetPerson.assessor
        else {
            return nil
        }
        return """
        評価結果
        評価日:\(evaluatedFormatter.string(from: assessment.createdAt))
        評価者:\(assessor.name)
        対象者:\(targetPerson.name)
        評価項目:\("HDS-R")
        評価結果:
        合計:\(assessment.hdsrItemSum)
        年齢:\(assessment.resultHDSR.itemAge)
        日付の見当識:\(assessment.resultHDSR.itemDateOrientation)
        場所の見当識:\(assessment.resultHDSR.itemPlaceOrientation)
        即時記憶:\(assessment.resultHDSR.itemMemory)
        計算:\(assessment.resultHDSR.itemCalculation)
        逆唱:\(assessment.resultHDSR.itemDigitSpan)
        遅延再生:\(assessment.resultHDSR.itemDelayedPlayback)
        視覚記憶:\(assessment.resultHDSR.itemVisualMemory)
        語想起・流暢性:\(assessment.resultHDSR.itemWordRecall)
        """
    }
}
