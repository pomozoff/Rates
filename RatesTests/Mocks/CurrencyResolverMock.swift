//
//  CurrencyResolverMock.swift
//  RatesTests
//
//  Created by Anton Pomozov on 30/09/2018.
//  Copyright © 2018 Anton Pomozov. All rights reserved.
//

import Foundation
@testable import Rates

final class CurrencyResolverMock: CurrencyResolver {

    override func resolve<T>() -> T where T: Any {
        if T.self == CurrencyFetcher?.self {
            return factory.resolveObject { return CurrencyFetcherMock(assetName: "CurrencyRatesInitBaseEUR") } as! T
        } else if T.self == QueueRunner?.self {
            return factory.resolveObject { return QueueRunnerMock() } as! T
        } else {
            return super.resolve()
        }
    }

}
