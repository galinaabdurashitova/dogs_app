//
//  SavedDogsViewController.swift
//  DogsApp
//
//  Created by Galina Abdurashitova on 26.08.2025.
//

import UIKit

final class SavedDogsViewController: UIViewController {
    private let doggyRepo: DogsRepositoryProtocol
    
    init(doggyRepo: DogsRepositoryProtocol = DogsRepository()) {
        self.doggyRepo = doggyRepo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.doggyRepo = DogsRepository()
        super.init(coder: coder)
    }
}
