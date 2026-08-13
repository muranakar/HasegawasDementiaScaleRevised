//
//  AssessmentResultFormatter.swift
//  HasegawasDementiaScaleRevised
//
//  評価結果をクリップボード用テキストへ整形する。書式は旧バージョンと揃えている。
//

import Foundation

enum AssessmentResultFormatter {
    /// 下記のフォーマットに整形する
    ///
    /// ```
    /// 評価結果
    /// 評価日:9999年99月99日 99時99分
    /// 評価者:XXX
    /// 対象者:XXX
    /// 評価項目:HDS-R
    /// 評価結果:
    /// ```
    static func string(from assessment: Assessment) -> String {
        let targetPersonName = assessment.targetPerson?.name ?? "-"
        let assessorName = assessment.targetPerson?.assessor?.name ?? "-"

        return """
        評価結果
        評価日:\(DateFormatter.evaluated.string(from: assessment.createdAt))
        評価者:\(assessorName)
        対象者:\(targetPersonName)
        評価項目:HDS-R
        評価結果:
        合計:\(assessment.hdsrItemSum)
        年齢:\(assessment.itemAge)
        日付の見当識:\(assessment.itemDateOrientation)
        場所の見当識:\(assessment.itemPlaceOrientation)
        即時記憶:\(assessment.itemMemory)
        計算:\(assessment.itemCalculation)
        逆唱:\(assessment.itemDigitSpan)
        遅延再生:\(assessment.itemDelayedPlayback)
        視覚記憶:\(assessment.itemVisualMemory)
        語想起・流暢性:\(assessment.itemWordRecall)
        """
    }
}
