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
        return savedDogs
    }
}
