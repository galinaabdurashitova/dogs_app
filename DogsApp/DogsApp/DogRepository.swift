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
    private let db: Realm
    
    init(dogService: DogsServiceProtocol, db: Realm) {
        self.dogService = dogService
        self.db = db
    }
    
    func fetchDog() async throws -> Dog {
        return try await dogService.fetchDogs()
    }
    
    func saveDog(_ dog: Dog) async throws {
        let dogEntity = DogEntity()
        dogEntity.status = dog.status
        dogEntity.message = dog.message
        dogEntity.saveDate = Date()
        
        do {
            try db.write {
                db.add(dogEntity)
            }
        } catch {
            throw DogRepositoryError.willDoLater
        }
    }
    
    func fetchSavedDogs() async throws -> [Dog] {
        let savedDogs = db.objects(DogEntity.self)
        let dogs = Array(savedDogs).map { Dog(message: $0.message, status: $0.status) }
        return dogs
    }
}
