//
//  DogsService.swift
//  DogsApp
//
//  Created by Galina Abdurashitova on 14.08.2025.
//

import Alamofire
import Foundation

protocol DogsServiceProtocol {
    func fetchRandomDog() async throws -> DogDTO
}

class DogsService: DogsServiceProtocol {
    func fetchRandomDog() async throws -> DogDTO {
        let response = await AF
            .request(
                "https://dog.ceo/api/breeds/image/random",
                interceptor: .retryPolicy
            )
            .cacheResponse(using: .cache)
            .redirect(using: .follow)
            .validate()
            .cURLDescription { description in
                print(description)
            }
            .serializingDecodable(DogDTO.self)
            .response
        
        return try response.result.get()
    }
}
