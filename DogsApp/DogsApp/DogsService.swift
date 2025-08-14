//
//  DogsService.swift
//  DogsApp
//
//  Created by Galina Abdurashitova on 14.08.2025.
//

import Alamofire
import Foundation

protocol DogsServiceProtocol {
    func fetchDogs(page: Int, limit: Int) async throws -> Dog
}

class DogsService: DogsServiceProtocol {
    func fetchDogs(page: Int, limit: Int) async throws -> Dog {
//        let keyHeader: HTTPHeaders = ["x-api-key": "live_QHgaBL3kdnwF4ZZZ6HkPq2Dpg7uMN4d67CSLM0feVBZzkxQxX3zW1DJIdJ1sX6eA"]
        let response = await AF
            .request(
                "https://dog.ceo/api/breeds/image/random",
//                headers: keyHeader,
                interceptor: .retryPolicy
            )
//            .authenticate(username: "user", password: "pass")
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

struct Dog: Codable {
    var message: String
    var status: String
    //    "entities": [],
    //    "breeds": [
    //      {
    //        "id": 3,
    //        "name": "Alaskan Malamute",
    //        "wikipedia_url": "https://en.wikipedia.org/wiki/Alaskan_Malamute"
    //      },
    //      {
    //        "id": 2,
    //        "name": "Akita",
    //        "wikipedia_url": "https://en.wikipedia.org/wiki/Akita_(dog)"
    //      }
    //    ],
    //    "animals": [],
    //    "categories": []
}
