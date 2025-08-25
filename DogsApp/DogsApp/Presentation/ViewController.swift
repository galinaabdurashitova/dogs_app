//
//  ViewController.swift
//  DogsApp
//
//  Created by Galina Abdurashitova on 14.08.2025.
//

import UIKit

class ViewController: UIViewController {
    private let doggyRepo: DogsRepositoryProtocol
    private var selectedDog: Dog?
    private var isCurrentLiked = false
    private var loadTask: Task<Void, Never>?
    
    init(doggyRepo: DogsRepositoryProtocol = DogsRepository()) {
        self.doggyRepo = doggyRepo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.doggyRepo = DogsRepository()
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        loadDog()
    }
    
    
    private lazy var dogView: DogView = DogView()
    
    private func setUpUI() {
        view.backgroundColor = .white
        dogView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dogView)
        
        dogView.onTapImage = { [weak self] in
            self?.loadDog()
        }

        dogView.onTapLike = { [weak self] in
            self?.toggleLike()
        }
        
        setConstraints()
    }
    
    deinit {
        loadTask?.cancel()
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            dogView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            dogView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            dogView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            dogView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            dogView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            dogView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func loadDog() {
        loadTask?.cancel()
        loadTask = Task { [weak self] in
            guard let self else { return }
            do {
                let dog = try await doggyRepo.fetchDog()
                self.selectedDog = dog
                self.isCurrentLiked = await self.isFavorite(dog)
                let dogData = DogViewData(
                    imageURL: URL(string: dog.message),
                    isLiked: self.isCurrentLiked
                )
                self.dogView.apply(dogData)
            } catch {
                // TODO: Error handling
                print("Failed to load dog: \(error.localizedDescription)")
            }
        }
    }
    
    private func toggleLike() {
        guard let dog = selectedDog else { return }
        Task {
            do {
                if isCurrentLiked {
                    // TODO: Remove like
                } else {
                    try await doggyRepo.saveDog(dog)
                }
                isCurrentLiked.toggle()
                dogView.setLiked(isCurrentLiked)
            } catch {
                // TODO: Error handling
                print("Failed to like dog: \(error.localizedDescription)")
            }
        }
    }
    
    
    private func isFavorite(_ dog: Dog) async -> Bool {
        guard let all = try? await doggyRepo.fetchSavedDogs() else { return false }
        return all.contains { $0.message == dog.message }
    }
}

