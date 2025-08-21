//
//  DogRepository.swift
//  DogsApp
//
//  Created by Galina Abdurashitova on 18.08.2025.
//

import Foundation
import RealmSwift

enum DogRepositoryError: Error {
    case willDoLater
}

protocol DogsRepositoryProtocol {
    func fetchDog() async throws -> Dog
    func saveDog(_ dog: Dog) async throws
    func fetchSavedDogs() async throws -> [Dog]
}

class DogsRepository: DogsRepositoryProtocol {
    private let dogService: DogsServiceProtocol
    private let store = DogStore()
    
    init(
        dogService: DogsServiceProtocol = DogsService()
    ) {
        self.dogService = dogService
    }
    
    func fetchDog() async throws -> Dog {
        return try await dogService.fetchDogs()
    }
    
    func saveDog(_ dog: Dog) async throws {
        try await store.save(dog)
    }
    
    func fetchSavedDogs() async throws -> [Dog] {
        let savedDogs = try await store.fetchAll()
        print(savedDogs)
        return savedDogs
    }
}

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
