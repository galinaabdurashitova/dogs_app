//
//  ViewController.swift
//  DogsApp
//
//  Created by Galina Abdurashitova on 14.08.2025.
//

import UIKit

class ViewController: UIViewController {
    private let doggyRepo: DogsRepositoryProtocol = DogsRepository()
    private lazy var dogView: DogView = DogView()
    private var selectedDog: Dog?
    
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
        dogView.likeButton.addTarget(
            self,
            action: #selector(likeDog),
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
    
    @objc private func likeDog() {
        guard let selectedDog else { return }
        Task {
            do {
                try await doggyRepo.saveDog(selectedDog)
                updateHeartButton()
            } catch {
                print("Unhandled error")
            }
        }
    }
    
    private func updateHeartButton() {
        guard let selectedDog else { return }
        Task {
            let favDogs = try? await doggyRepo.fetchSavedDogs()
            if let favDogs = favDogs, favDogs.contains(where: { $0.message == selectedDog.message }) {
                let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .regular)
                let image = UIImage(systemName: "heart.fill", withConfiguration: config)
                dogView.likeButton.setImage(image, for: .normal)
            } else {
                let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .regular)
                let image = UIImage(systemName: "heart", withConfiguration: config)
                dogView.likeButton.setImage(image, for: .normal)
            }
        }
    }
    
    private func loadDog() {
        Task {
            do {
                let dog = try await doggyRepo.fetchDog()
                selectedDog = dog
                await MainActor.run {
                    print(dog)
                    dogView.configure(with: dog)
                    updateHeartButton()
                }
            } catch {
                print("error: \(error.localizedDescription)")
            }
        }
    }
}

