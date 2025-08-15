//
//  DogsService.swift
//  DogsApp
//
//  Created by Galina Abdurashitova on 14.08.2025.
//

import Alamofire
import Foundation

protocol DogsServiceProtocol {
    func fetchDogs() async throws -> Dog
}

class DogsService: DogsServiceProtocol {
    func fetchDogs() async throws -> Dog {
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
            .serializingDecodable(Dog.self)
            .response
        
        return try response.result.get()
    }
}
