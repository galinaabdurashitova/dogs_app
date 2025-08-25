//
//  DogStore.swift
//  DogsApp
//
//  Created by Galina Abdurashitova on 25.08.2025.
//

import Foundation
import RealmSwift

actor DogStore {
    private let config = Realm.Configuration.defaultConfiguration

    func save(_ dog: Dog) throws {
        let realm = try Realm(configuration: config)
        let e = DogEntity()
        e.status = dog.status
        e.message = dog.message
        e.saveDate = Date()
        try realm.write { realm.add(e) }
    }

    func fetchAll() throws -> [Dog] {
        let realm = try Realm(configuration: config)
        return realm.objects(DogEntity.self).map { Dog(message: $0.message, status: $0.status) }
    }
}
