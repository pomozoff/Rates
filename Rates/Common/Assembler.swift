//
//  Assembler.swift
//  Rates
//
//  Created by Anton Pomozov on 30/09/2018.
//  Copyright © 2018 Anton Pomozov. All rights reserved.
//

import Foundation

protocol Assembler: class {

    func assemble()
    func resolve<T>() -> T where T: AnyObject

}
