//
//  QueueRunner.swift
//  Rates
//
//  Created by Anton Pomozov on 01/10/2018.
//  Copyright © 2018 Anton Pomozov. All rights reserved.
//

import Foundation

protocol QueueRunner: class {

    func runOnMain(_ closure: @escaping () -> Void)
    func runOnMain(deadline: DispatchTime, _ closure: @escaping () -> Void)

}

final class QueueRunnerImpl {}

extension QueueRunnerImpl: QueueRunner {

    func runOnMain(_ closure: @escaping () -> Void) {
        DispatchQueue.main.async(execute: closure)
    }

    func runOnMain(deadline: DispatchTime, _ closure: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: deadline, execute: closure)
    }

}
