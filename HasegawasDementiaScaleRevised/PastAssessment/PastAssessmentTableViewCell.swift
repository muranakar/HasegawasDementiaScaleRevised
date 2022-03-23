//
//  PastAssessmentTableViewCell.swift
//  HasegawasDementiaScaleRevised
//
//  Created by 村中令 on 2022/03/24.
//

import UIKit

class PastAssessmentTableViewCell: UITableViewCell {
    @IBOutlet weak private var assessmentResultNumLabel: UILabel!
    @IBOutlet weak private var createdAtLabel: UILabel!
    @IBOutlet weak private var copyTextButton: PastAssessmentTableViewCellCopyButton!

    func configure(item: PastAssessmentViewItem) {
//        copyTextButton.id = item.id
        assessmentResultNumLabel.text = item.assessmentResult
        createdAtLabel.text = item.creationDate
    }

    func configure(id: Assessment.ID?, assessmentResult: String, creationDate: String) {
        copyTextButton.id = id
        assessmentResultNumLabel.text = assessmentResult
        createdAtLabel.text = creationDate
    }
}

final class PastAssessmentTableViewCellCopyButton: UIButton {
    fileprivate(set) var id: Assessment.ID?

    override func awakeFromNib() {
        super.awakeFromNib()
        tintColor = Colors.mainColor
        addTarget(nil, action: #selector(PastAssessmentViewController.copyPasteboard), for: .touchUpInside)
    }
}
