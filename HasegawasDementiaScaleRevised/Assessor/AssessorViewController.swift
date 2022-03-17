//
//  AssessorViewController.swift
//  FunctionalIndependenceMeasure
//
//  Created by 村中令 on 2022/01/11.
//

import UIKit

final class AssessorViewController: UIViewController {
    private let repository: AssessorRepository = Repository.assessor()
    private var token: NotificationToken?
    private var assessors = [Assessor]() {
        didSet {
            Task { [weak tableView] in
                tableView?.reloadData()
            }
        }
    }
    @IBOutlet @BottomFloatingItems private var floatingItems: [UIView]
    @IBOutlet weak private var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        startObserving()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.selectRow(at: nil, animated: animated, scrollPosition: .none)
    }
}

private extension AssessorViewController {
    private func startObserving() {
        token = repository.observe { [weak self] result in
            self?.assessors = try result.get()
        }
    }
}

// MARK: - UITableViewDataSource
extension AssessorViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        assessors.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AssessorTableViewCell = tableView.dequeueCell(for: indexPath)
        print(String(describing: type(of: AssessorTableViewCell.self)))
        print(String(describing: AssessorTableViewCell.self))
        cell.configue(assessor: assessors[indexPath.row])
        return cell
    }

    func tableView(_: UITableView, commit style: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard style == .delete else { return }
        repository.remove(id: assessors[indexPath.row].id)
    }
}

// MARK: - UITableViewDelegate
extension AssessorViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        performSegue(withIdentifier: "edit", sender: indexPath)
    }
}

// MARK: - UIScrollViewDelegate
extension AssessorViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        $floatingItems.updateVisibility(scrollView)
    }
}

// MARK: - Segue
private extension AssessorViewController {
    @IBSegueAction
    func makeInputAssessor(coder: NSCoder, sender: Any?, segueIdentifier: String?) -> InputAssessorViewController? {
        switch (segueIdentifier, sender) {
        case ("input", _):
            return .init(coder: coder, repository: repository, mode: .init())
        case ("edit", let indexPath) as (String, IndexPath):
            return .init(coder: coder, repository: repository, mode: .edit(assessors[indexPath.row]))
        case _:
            return nil
        }
    }

    @IBSegueAction
    func makeTargetPerson(coder: NSCoder, sender: Any?, segueIdentifier: String?) -> TargetPersonViewController? {
        guard let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) else {
            return nil
        }
        return TargetPersonViewController(
            coder: coder,
            assessor: assessors[indexPath.row],
            repository: Repository.targetPerson()
        )
    }

    @IBAction
    func backToAssessorTableViewController(segue: UIStoryboardSegue) {
    }
}
