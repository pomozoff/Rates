//
//  Error.swift
//  Rates
//
//  Created by Anton Pomozov on 25/09/2018.
//  Copyright © 2018 Anton Pomozov. All rights reserved.
//

import Foundation

extension NSError {

    static func create(withCode code: Int, localDomain: String, description: String) -> NSError {
        let userInfo = [NSLocalizedDescriptionKey : description]
        let domain = Bundle.main.bundleIdentifier! + "." + localDomain
        return NSError(domain: domain, code: code, userInfo: userInfo)
    }

}
