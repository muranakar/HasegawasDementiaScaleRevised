//
//  TargetPersonViewController.swift
//  FunctionalIndependenceMeasure
//
//  Created by 村中令 on 2022/01/11.
//

import UIKit

final class TargetPersonViewController: UIViewController {
    private let assessor: Assessor
    private let repository: TargetPersonRepository
    private var token: NotificationToken?
    @IBOutlet @BottomFloatingItems private var floatingItems: [UIView]
    @IBOutlet weak private var tableView: UITableView!

    private var targetPersons = [TargetPerson]() {
        didSet {
            Task { [weak tableView] in
                tableView?.reloadData()
            }
        }
    }

    required init?(coder: NSCoder, assessor: Assessor, repository: TargetPersonRepository) {
        self.assessor = assessor
        self.repository = repository
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "\(assessor.name)　様の対象者リスト"
        startObserving()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.selectRow(at: nil, animated: animated, scrollPosition: .none)
    }
}

private extension TargetPersonViewController {
    private func startObserving() {
        token = repository.observe(id: assessor.id) { [weak self] result in
            self?.targetPersons = try result.get()
        }
    }
}

// MARK: - UITableViewDataSource
extension TargetPersonViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        targetPersons.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TargetPersonTableViewCell = tableView.dequeueCell(for: indexPath)
        cell.configue(name: targetPersons[indexPath.row].name)
        return cell
    }

    func tableView(_: UITableView, commit style: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard style == .delete else { return }
        repository.remove(id: targetPersons[indexPath.row].id)
    }
}

// MARK: - UITableViewDelegate
extension TargetPersonViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        performSegue(withIdentifier: "edit", sender: indexPath)
    }
}

// MARK: - UIScrollViewDelegate
extension TargetPersonViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        $floatingItems.updateVisibility(scrollView)
    }
}

// MARK: - Segue
extension TargetPersonViewController {
    @IBSegueAction
    func makeInputTarget(coder: NSCoder, sender: Any?, segueIdentifier: String?) -> InputTargetPersonViewController? {
        switch (segueIdentifier, sender) {
        case ("input", _):
            return .init(coder: coder, repository: repository, mode: .input(assessor.id))
        case ("edit", let indexPath) as (String, IndexPath):
            let targetPerson = targetPersons[indexPath.row]
            return .init(coder: coder, repository: repository, mode: .edit(targetPerson))
        case _:
            return nil
        }
    }

@IBSegueAction
    func makeFunctionSelection(
        coder: NSCoder,
        sender: Any?,
        segueIdentifier: String?
    ) -> FunctionSelectionViewController? {
        guard let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) else {
            return nil
        }
        return .init(
            coder: coder,
            targetPerson: targetPersons[indexPath.row],
            repository: repository
        )
    }

    @IBAction private func backToTargetPersonTableViewController(segue: UIStoryboardSegue) {
    }
}
