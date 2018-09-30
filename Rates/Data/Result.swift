//
//  Result.swift
//  Rates
//
//  Created by Anton Pomozov on 25/09/2018.
//  Copyright © 2018 Anton Pomozov. All rights reserved.
//

import Foundation

enum Result<T> {

    case success(T)
    case failure(Error)

}
