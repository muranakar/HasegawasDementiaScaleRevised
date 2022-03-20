//
//  DetailAssessmentViewController.swift
//  HasegawasDementiaScaleRevised
//
//  Created by 村中令 on 2022/03/19.
//

import UIKit

class DetailAssessmentViewController: UIViewController {
    private let assessment: Assessment

    @IBOutlet private weak var tableView: UITableView!
    required init?(coder: NSCoder, repository: AssessmentRepository, id: Assessment.ID) {
        guard let assessment = repository.load(id: id) else {
            return nil
        }
        self.assessment = assessment
        super.init(coder: coder)
    }
    private var assessmentItemName = Assessment.hdsrItemName
    private var assessmentItemResult: [Int] {
        assessment.hdsrItemResut()
    }

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
        cell.configure(
            itemTitle: assessmentItemName[indexPath.row],
            itemNum: assessmentItemResult[indexPath.row]
        )
        return cell
    }
}
