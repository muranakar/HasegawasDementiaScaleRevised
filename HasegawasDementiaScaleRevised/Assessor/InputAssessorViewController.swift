//
//  InputAssessorViewController.swift
//  Functional Independence Measure
//
//  Created by 村中令 on 2021/12/07.
//

import UIKit

final class InputAssessorViewController: UIViewController {
    typealias Mode = InputMode<Void, Assessor>

    private let mode: Mode
    private let repository: AssessorRepository
    @IBOutlet weak private var assessorNameTextField: UITextField! {
        willSet (textField) {
            textField.text = mode.value?.name
        }
    }

    required init?(coder: NSCoder, repository: AssessorRepository, mode: Mode) {
        self.mode = mode
        self.repository = repository
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - 評価者データを保存するUIButtonのIBAction
    @IBAction private func saveAction(_ sender: Any) {
        let name = assessorNameTextField.text ?? ""
        switch mode {
        case .input:
            repository.add(value: Assessor(name: name))
        case .edit(var value):
            value.name = name
            repository.update(value: value)
        }
        performSegue(withIdentifier: "back", sender: sender)
    }
}
