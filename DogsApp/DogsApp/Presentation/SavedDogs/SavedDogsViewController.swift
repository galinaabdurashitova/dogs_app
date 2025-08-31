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
    private var deleteMode: Bool = false
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 12

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .systemBackground
        cv.contentInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        cv.dataSource = self
        cv.delegate = self
        cv.register(SavedDogCell.self, forCellWithReuseIdentifier: SavedDogCell.reuseID)
        return cv
    }()
    
    private let emptyLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "No saved dogs yet"
        l.textAlignment = .center
        l.textColor = .secondaryLabel
        l.isHidden = true
        return l
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
        title = "Saved Dogs"
        setUpUI()
        updateNavButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadSavedDogs()
    }
    
    private func setUpUI() {
        view.backgroundColor = .white
        view.addSubview(collectionView)
        view.addSubview(emptyLabel)
        setConstraints()
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    deinit {
        loadTask?.cancel()
    }
    
    private func updateNavButton() {
        let title = deleteMode ? "Done" : "Delete Dogs"
        let color: UIColor = deleteMode ? .systemBlue : .systemRed

        let item = UIBarButtonItem(
            title: title,
            style: .plain,
            target: self,
            action: #selector(switchDogsDeleteMode)
        )
        item.tintColor = color
        navigationItem.rightBarButtonItem = item
    }
    
    @objc private func switchDogsDeleteMode() {
        deleteMode.toggle()
        updateNavButton()
        collectionView.reloadData()
        print("New value: " + (deleteMode ? "true" : "false"))
    }
    
    private func loadSavedDogs() {
        loadTask?.cancel()
        loadTask = Task { [weak self] in
            guard let self else { return }
            do {
                let dogs = try await doggyRepo.fetchSavedDogs()
                await MainActor.run {
                    self.savedDogs = dogs
                    self.collectionView.reloadData()
                    self.emptyLabel.isHidden = !dogs.isEmpty
                }
            } catch {
                await MainActor.run {
                    // TODO: Error handling
                    print("Failed to load saved dogs: \(error.localizedDescription)")
                    self.savedDogs = []
                    self.collectionView.reloadData()
                    self.emptyLabel.isHidden = false
                }
            }
        }
    }
    
    private func deleteDog(_ dog: Dog) {
        Task { [weak self] in
            guard let self else { return }
            do {
                try await doggyRepo.deleteSavedDog(dog)
                if let dogIndex = self.savedDogs.firstIndex(where: { $0.id == dog.id }) {
                    self.savedDogs.remove(at: dogIndex)
                    await MainActor.run {
                        self.collectionView.performBatchUpdates({
                            self.collectionView.deleteItems(at: [IndexPath(item: dogIndex, section: 0)])
                        }, completion: { _ in
                            self.emptyLabel.isHidden = !self.savedDogs.isEmpty
                        })
                    }
                }
            } catch {
                // TODO: Error handling
                print("Delete failed: \(error)")
            }
        }
    }
}

extension SavedDogsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private var columns: CGFloat { 2 }
    private var spacing: CGFloat { 12 }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        savedDogs.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SavedDogCell.reuseID,
            for: indexPath
        ) as! SavedDogCell
        let dog = savedDogs[indexPath.item]
        cell.configure(with: dog)
        cell.setDeleteMode(deleteMode)
        cell.onDeleteTapped = { [weak self] in
            self?.deleteDog(dog)
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let insets = collectionView.contentInset
        let totalSpacing = spacing * (columns - 1) + insets.left + insets.right
        let width = floor((collectionView.bounds.width - totalSpacing) / columns)
        return CGSize(width: width, height: width)
    }
}
