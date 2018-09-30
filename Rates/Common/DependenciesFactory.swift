//
//  DependenciesFactory.swift
//  Rates
//
//  Created by Anton Pomozov on 30/09/2018.
//  Copyright © 2018 Anton Pomozov. All rights reserved.
//

import Foundation

final class ObjectKey: NSObject {

    let type: AnyObject.Type
    let tag: String

    init(type: AnyObject.Type) {
        self.type = type
        self.tag = ""
    }

    override var hash: Int {
        return String(describing: type).hashValue ^ tag.hashValue
    }

    override func isEqual(_ object: Any?) -> Bool {
        guard let object = object as? ObjectKey else { return false }
        return type == object.type && tag == object.tag
    }

}

protocol DependenciesFactory: class {

    func resolveObject<T>(builder: () -> T) -> T where T: AnyObject

}

final class DependenciesStorage {

    static let shared = DependenciesStorage()

    private let singletones = NSMapTable<NSString, AnyObject>(keyOptions: .strongMemory, valueOptions: .weakMemory)

}

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
