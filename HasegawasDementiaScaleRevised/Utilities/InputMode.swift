//
//  InputMode.swift
//  TimerAssessment
//
//  Created by Takehito Koshimizu on 2022/02/20.
//

import Foundation

enum InputMode<ParentID, EditingValue> {
    case input(ParentID)
    case edit(EditingValue)

    var value: EditingValue? {
        switch self {
        case let .edit(value):
            return value
        case _:
            return nil
        }
    }
}

extension InputMode where ParentID == Void {
    init() {
        self = .input(())
    }
}
