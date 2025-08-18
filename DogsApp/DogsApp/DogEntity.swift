//
//  DogEntity.swift
//  DogsApp
//
//  Created by Galina Abdurashitova on 18.08.2025.
//

import Foundation
import RealmSwift

class DogEntity: Object {
    @Persisted var message: String
    @Persisted var status: String
    @Persisted var saveDate: Date
}
