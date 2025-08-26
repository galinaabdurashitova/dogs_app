//
//  SavedDogsViewController.swift
//  DogsApp
//
//  Created by Galina Abdurashitova on 26.08.2025.
//

import UIKit

final class SavedDogsViewController: UIViewController {
    private let doggyRepo: DogsRepositoryProtocol
    private var savedDogs: [Dog] = []
    private var loadTask: Task<Void, Never>?
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
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
        loadSavedDogs()
    }
    
    private func setUpUI() {
        view.backgroundColor = .white
        view.addSubview(scrollView)
        setConstraints()
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    deinit {
        loadTask?.cancel()
    }
    
    private func loadSavedDogs() {
        loadTask?.cancel()
        loadTask = Task { [weak self] in
            guard let self else { return }
            do {
                savedDogs = try await doggyRepo.fetchSavedDogs()
            } catch {
                // TODO: Error handling
                print("Failed to load saved dogs: \(error.localizedDescription)")
            }
        }
    }
}
