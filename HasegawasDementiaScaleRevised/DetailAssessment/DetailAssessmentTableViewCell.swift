//
//  DetailAssessmentTableViewCell.swift
//  HasegawasDementiaScaleRevised
//
//  Created by 村中令 on 2022/03/19.
//

import UIKit

class DetailAssessmentTableViewCell: UITableViewCell {

    @IBOutlet weak var assessmentItemTitle: UILabel!
    @IBOutlet weak var assessmentItemNum: UILabel!

    func configure(itemTitle: String,itemNum: Int) {
        assessmentItemTitle.text = itemTitle
        assessmentItemNum.text = String(itemNum)

    }
}
