//
//  ViewController.swift
//  DogsApp
//
//  Created by Galina Abdurashitova on 14.08.2025.
//

import UIKit

class ViewController: UIViewController {
    private let doggyService: DogsServiceProtocol = DogsService()
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
            dogView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            dogView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            dogView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            dogView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            dogView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            dogView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
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
                print("error: \(error.localizedDescription)")
            }
        }
    }
}

