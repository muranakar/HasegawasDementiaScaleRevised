//
//  DispatchQueue.swift
//  TimerAssessment
//
//  Created by Takehito Koshimizu on 2022/02/22.
//

import Dispatch

extension DispatchQueue {
    static let observingQueue = DispatchQueue(label: "observing.repository.queue")
}
