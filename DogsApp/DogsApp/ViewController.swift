//
//  ViewController.swift
//  DogsApp
//
//  Created by Galina Abdurashitova on 14.08.2025.
//

import UIKit

class ViewController: UIViewController {
    private let doggyService = DogsService()
    private lazy var dogView: DogView = DogView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        dogView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dogView)
        dogView.dogButton.addTarget(
            self,
            action: #selector(tapDogImage),
            for: .touchUpInside
        )
        
        NSLayoutConstraint.activate([
            dogView.topAnchor.constraint(equalTo: view.topAnchor),
            dogView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            dogView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dogView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        loadDog()
    }
    
    @objc private func tapDogImage() {
        loadDog()
    }
    
    private func loadDog() {
        Task {
            do {
                let dog = try await doggyService.fetchDogs()
                await MainActor.run {
                    print(dog)
                    dogView.configure(with: dog)
                }
            } catch {
                print("error")
            }
        }
    }
}

