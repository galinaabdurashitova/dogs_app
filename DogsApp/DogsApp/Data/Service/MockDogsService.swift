//
//  MockDogsService.swift
//  DogsApp
//
//  Created by Galina Abdurashitova on 25.08.2025.
//

import Foundation

class MockDogsService: DogsServiceProtocol {
    func fetchDogs() async throws -> Dog {
        return Dog(message: "https://images.dog.ceo/breeds/australian-shepherd/forest.jpg", status: "success")
    }
}
