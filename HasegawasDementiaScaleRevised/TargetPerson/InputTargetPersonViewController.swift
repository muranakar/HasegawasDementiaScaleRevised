//
//  InputTargetPersonViewController.swift
//  Functional Independence Measure
//
//  Created by 村中令 on 2021/12/07.
//

import UIKit

final class InputTargetPersonViewController: UIViewController {
    typealias Mode = InputMode<Assessor.ID, TargetPerson>

    private let mode: Mode
    private let repository: TargetPersonRepository
    @IBOutlet weak private var targetPersonNameTextField: UITextField! {
        willSet(textField) {
            textField.text = mode.value?.name
        }
    }

    required init?(coder: NSCoder, repository: TargetPersonRepository, mode: Mode) {
        self.mode = mode
        self.repository = repository
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - 対象者データを保存するUIButtonのIBAction
    @IBAction private func saveAction(_ sender: Any) {
        let name = targetPersonNameTextField.text ?? ""
        switch mode {
        case .input(let id):
            repository.add(value: .init(name: name), id: id)
        case .edit(var value):
            value.name = name
            repository.update(value: value)
        }
        performSegue(withIdentifier: "back", sender: sender)
    }
}
