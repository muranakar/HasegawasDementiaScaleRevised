//
//  PastAssessmentViewItem.swift
//  HasegawasDementiaScaleRevised
//
//  Created by 村中令 on 2022/03/24.
//

import Foundation

struct PastAssessmentViewItem {
    let id: Assessment.ID
    let assessmentResult: String
    let creationDate: String
}

extension PastAssessmentViewItem {
    private static let dateFormatter = DateFormatter.evaluated()

    init(_ value: Assessment) {
        self.init(
            id: value.id,
            assessmentResult: String(value.hdsrItemSum),
            creationDate: Self.dateFormatter.string(from: value.createdAt)
        )
    }
}
