//
//  DogStore.swift
//  DogsApp
//
//  Created by Galina Abdurashitova on 25.08.2025.
//

import Foundation
import RealmSwift

protocol DogStoreProtocol: Actor {
    func save(_ dog: Dog) throws
    func delete(_ dog: Dog) throws
    func fetchAll() throws -> [Dog]
    func fetchDog(message: String) throws -> Dog?
    func isSaved(_ dog: Dog) throws -> Bool
}

actor DogStore: DogStoreProtocol {
    private let config: Realm.Configuration
    
    init(config: Realm.Configuration = .defaultConfiguration) {
        self.config = config
    }

    func save(_ dog: Dog) throws {
        let realm = try initializeDB()
        let e = DogEntity()
        e.status = dog.status
        e.imageUrl = dog.imageUrl
        e.saveDate = Date()
        try realm.write { realm.add(e, update: .modified) }
    }
    
    func delete(_ dog: Dog) throws {
        let realm = try initializeDB()
        if let entity = realm.object(ofType: DogEntity.self, forPrimaryKey: dog.imageUrl) {
            try realm.write { realm.delete(entity) }
        }
    }

    func fetchAll() throws -> [Dog] {
        let realm = try initializeDB()
        return realm.objects(DogEntity.self).map { Dog(imageUrl: $0.imageUrl, status: $0.status, saveDate: $0.saveDate) }
    }
    
    func fetchDog(message: String) throws -> Dog? {
        let realm = try initializeDB()
        if let savedDog = realm.object(ofType: DogEntity.self, forPrimaryKey: message) {
            return Dog(imageUrl: savedDog.imageUrl, status: savedDog.status, saveDate: savedDog.saveDate)
        }
        return nil
    }
    
    func isSaved(_ dog: Dog) throws -> Bool {
        if let _ = try fetchDog(message: dog.imageUrl) {
            return true
        }
        return false
    }
    
    private func initializeDB() throws -> Realm {
        do {
            return try Realm(configuration: config)
        } catch {
            _ = try? Realm.deleteFiles(for: config)
            return try Realm(configuration: config)
        }
    }
}
