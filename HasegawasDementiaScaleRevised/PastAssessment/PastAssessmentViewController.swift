//
//  PastAssessmentViewController.swift
//  HasegawasDementiaScaleRevised
//
//  Created by 村中令 on 2022/03/24.
//

import UIKit

final class PastAssessmentViewController: UIViewController {
    private var token: NotificationToken?
    private let targetPerson: TargetPerson
    private let repository: AssessmentRepository
    private let pasteboardFormatter = AssessmentResultPasteboardFormatter()
    private var ascending = false {
        didSet {
            assessmentViewItems = repository.load(id: targetPerson.id, sortKey: "createdAt", ascending: ascending)
                .compactMap(PastAssessmentViewItem.init)
        }
    }
    private var assessmentViewItems = [PastAssessmentViewItem]() {
        didSet {
            Task { [weak tableView] in
                tableView?.reloadData()
            }
        }
    }

    private var assessments :[Assessment]{
        repository.load(id: targetPerson.id, sortKey: "createdAt", ascending: ascending)
    }

    @IBOutlet weak private var tableView: UITableView! {
        didSet {
            // TODO: 未編集
            tableView.registerNib(PastAssessmentTableViewCell.self)
        }
    }

    required init?(coder: NSCoder, targetPerson: TargetPerson, repository: AssessmentRepository) {
        self.targetPerson = targetPerson
        self.repository = repository
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "対象者:　\(targetPerson.name)　様"
        startObserving()
    }
}

private extension PastAssessmentViewController {
    private func startObserving() {
        token = repository.observe(id: targetPerson.id, sortKey: "createdAt") { [weak self] in
            self?.ascending
        } callBack: { [weak self] result in
            self?.assessmentViewItems = (try result.get())
                .compactMap(PastAssessmentViewItem.init)
        }
    }
}

// MARK: - Action
extension PastAssessmentViewController {
    @IBAction private func sortTableView(_ sender: Any) {
        ascending.toggle()
    }

    @objc func copyPasteboard(sender: PastAssessmentTableViewCellCopyButton) {
        guard
            let id = sender.id,
            let assessment = repository.load(id: id)
        else {
            return
        }
        UIPasteboard.general.string = pasteboardFormatter.string(from: assessment)
        present(UIAlertController.copyingCompletedPastAssessment(), animated: true)
    }
}

// MARK: - UITableViewDataSource
extension PastAssessmentViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        assessmentViewItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PastAssessmentTableViewCell = tableView.dequeueCell(for: indexPath)
        cell.configure(item: assessmentViewItems[indexPath.row])
        return cell
    }

    func tableView(_: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        repository.remove(id: assessmentViewItems[indexPath.row].id)
    }
}

extension PastAssessmentViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "DetailAssessment", sender: indexPath)
    }
}

extension PastAssessmentViewController {
    @IBSegueAction
        func makeDetailAssessment(
            coder: NSCoder,
            sender: Any?,
            segueIdentifier: String?
        ) -> DetailAssessmentViewController? {
//            guard let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) else {
//                return nil
//            }
            guard let indexPath = sender as? IndexPath else { return nil }
            return .init(coder: coder, repository: repository, id: assessments[indexPath.row].id)
        }
}
