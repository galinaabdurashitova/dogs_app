//
//  DogRepository.swift
//  DogsApp
//
//  Created by Galina Abdurashitova on 18.08.2025.
//

import Foundation

protocol DogsRepositoryProtocol {
    func fetchDog() async throws -> Dog
    func saveDog(_ dog: Dog) async throws
    func deleteSavedDog(_ dog: Dog) async throws
    func getDogSaveStatus(_ dog: Dog) async throws -> Bool
    func fetchSavedDogs() async throws -> [Dog]
}

class DogsRepository: DogsRepositoryProtocol {
    private let dogService: DogsServiceProtocol
    private let store: DogStoreProtocol
    
    init(
        dogService: DogsServiceProtocol = DogsService(),
        store: DogStoreProtocol = DogStore()
    ) {
        self.dogService = dogService
        self.store = store
    }
    
    func fetchDog() async throws -> Dog {
        let dogDTO = try await dogService.fetchRandomDog()
        if let savedDog = try? await store.fetchDog(message: dogDTO.message) {
            return savedDog
        }
        return Dog(imageUrl: dogDTO.message, status: dogDTO.status)
    }
    
    func saveDog(_ dog: Dog) async throws {
        try await store.save(dog)
    }
    
    func deleteSavedDog(_ dog: Dog) async throws {
        try await store.delete(dog)
    }
    
    func getDogSaveStatus(_ dog: Dog) async throws -> Bool {
        return try await store.isSaved(dog)
    }
    
    func fetchSavedDogs() async throws -> [Dog] {
        let savedDogs = try await store.fetchAll()
        return savedDogs
    }
}
