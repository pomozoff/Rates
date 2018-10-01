//
//  URLSessionProtocol.swift
//  RatesTests
//
//  Created by Anton Pomozov on 30/09/2018.
//  Copyright © 2018 Anton Pomozov. All rights reserved.
//

import Foundation

typealias DataTaskResult = (NSData?, URLResponse?, NSError?) -> Void

protocol URLSessionProtocol {

    func dataTaskWithURL(url: URL, completionHandler: DataTaskResult) -> URLSessionDataTask

}
