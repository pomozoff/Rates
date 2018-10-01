//
//  QueueRunnerMock.swift
//  RatesTests
//
//  Created by Anton Pomozov on 01/10/2018.
//  Copyright © 2018 Anton Pomozov. All rights reserved.
//

import Foundation
@testable import Rates

final class QueueRunnerMock {}

extension QueueRunnerMock: QueueRunner {

    func runOnMain(_ closure: @escaping () -> Void) {
        closure()
    }

    func runOnMain(deadline: DispatchTime, _ closure: @escaping () -> Void) {
        closure()
    }

}
