//
//  CurrencyFetcher.swift
//  Rates
//
//  Created by Anton Pomozov on 24/09/2018.
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

protocol CurrencyFetcher: class {

    // TODO: Update to Promises
    func fetchCurrencyList(url: URL, completion: @escaping (Result<CurrencyRates>) -> Void)

}

final class CurrencyFetcherImpl {

    // MARK: - Life cycle

    init(session: URLSession) {
        self.session = session
    }

    // MARK: - Private

    private let session: URLSession

}

// MARK: - CurrencyFetcher

extension CurrencyFetcherImpl: CurrencyFetcher {

    func fetchCurrencyList(url: URL, completion: @escaping (Result<CurrencyRates>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NetworkError.emptyData("Response: \(String(describing: response))").error))
                return
            }
            guard let rates = try? JSONDecoder().decode(CurrencyRates.self, from: data) else {
                completion(.failure(NetworkError.decoding("Data: \(data)").error))
                return
            }

            completion(.success(rates))
        }
        
        task.resume()
    }
    
}
