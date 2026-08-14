//
//  Route.swift
//  HasegawasDementiaScaleRevised
//
//  同じ TargetPerson から「評価する」「過去の評価をみる」の2方向へ分岐するため、
//  遷移先を型ではなく列挙で表現している。
//

import Foundation

enum Route: Hashable {
    /// 新規にHDS-R評価を行う
    case newAssessment(TargetPerson)
    /// 過去の評価一覧
    case pastAssessments(TargetPerson)
    /// 評価結果の詳細
    case assessmentDetail(Assessment)
}
