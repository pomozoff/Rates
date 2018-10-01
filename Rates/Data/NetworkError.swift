//
//  NetworkError.swift
//  Rates
//
//  Created by Anton Pomozov on 30/09/2018.
//  Copyright © 2018 Anton Pomozov. All rights reserved.
//

import Foundation

enum NetworkError {

    var domain: String {
        return "network"
    }

    case emptyData(String)
    case decoding(String)

    var error: NSError {
        switch self {
        case .emptyData(let description):
            return NSError.create(withCode: -1, localDomain: domain, description: "Data is empty. \(description)")
        case .decoding(let description):
            return NSError.create(withCode: -2, localDomain: domain, description: "Failed to convert data. \(description)")
        }
    }

}
