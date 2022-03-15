//
//  UITableView+Extensions.swift
//  TimerAssessment
//
//  Created by Takehito Koshimizu on 2022/02/13.
//

import UIKit

extension UITableView {
    func registerNib<Cell: UITableViewCell>(_ type: Cell.Type, nibName: String? = nil, identifier: String? = nil) {
        let nibName = nibName ?? String(describing: type)
        let bundle = Bundle(for: type)
        let nib = UINib(nibName: nibName, bundle: bundle)
        let identifier = identifier ?? nibName
        register(nib, forCellReuseIdentifier: identifier)
    }

    func dequeueCell<Cell: UITableViewCell>(
        _ type: Cell.Type = Cell.self,
        identifier: String? = nil,
        for indexPath: IndexPath
    ) -> Cell {
        let cell = dequeueReusableCell(withIdentifier: identifier ?? String(describing: type), for: indexPath)
        // swiftlint:disable:next force_cast
        return cell as! Cell
    }
}
