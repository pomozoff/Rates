//
//  DependenciesFactory.swift
//  Rates
//
//  Created by Anton Pomozov on 30/09/2018.
//  Copyright © 2018 Anton Pomozov. All rights reserved.
//

import Foundation

protocol DependenciesFactory: class {

    func resolveObject<T>(builder: () -> T) -> T where T: AnyObject

}

final class DependenciesStorage {

    // MARK: - Public

    static let shared = DependenciesStorage()

    func flush() {
        singletones.removeAllObjects()
    }

    // MARK: - Private

    private let singletones = NSMapTable<NSString, AnyObject>(keyOptions: .strongMemory, valueOptions: .weakMemory)

}

// MARK: - DependenciesFactory

extension DependenciesStorage: DependenciesFactory {

    func resolveObject<T>(builder: () -> T) -> T where T: AnyObject {
        let key = String(describing: T.self) as NSString

        if let object = singletones.object(forKey: key) as? T {
            return object
        }

        let object = builder()
        singletones.setObject(object, forKey: key)

        return object
    }

}
