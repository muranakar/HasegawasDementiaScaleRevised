//
//  DetailAssessmentViewController.swift
//  HasegawasDementiaScaleRevised
//
//  Created by 村中令 on 2022/03/19.
//

import UIKit

class DetailAssessmentViewController: UIViewController {
    private let assessment: Assessment
    private let repository: AssessmentRepository

    @IBOutlet private weak var tableView: UITableView!
    required init?(coder: NSCoder, assessment: Assessment, repository: AssessmentRepository) {
        self.assessment = assessment
        self.repository = repository
        super.init(coder: coder)
    }
    // TODO アセスメントの項目名を入力

    // TODO アセスメントの項目の結果を入力

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension DetailAssessmentViewController: UITableViewDelegate {
}

extension DetailAssessmentViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        9
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: DetailAssessmentTableViewCell = tableView.dequeueCell(for: indexPath)
        // TODO　セルの設定。項目名、結果の配列ができていない
        return cell
    }
}
