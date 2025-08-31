//
//  SavedDogCell.swift
//  DogsApp
//
//  Created by Galina Abdurashitova on 28.08.2025.
//

import UIKit
import Kingfisher

final class SavedDogCell: UICollectionViewCell {
    static let reuseID = "SavedDogCell"
    var onDeleteTapped: (() -> Void)?

    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 12
        return iv
    }()
    
    private lazy var deleteButton: UIButton = {
        let b = UIButton(type: .system)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        b.tintColor = .systemRed
        b.backgroundColor = .clear
        b.isHidden = true
        b.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
        b.accessibilityLabel = "Delete dog"
        return b
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    private func setUpUI() {
        contentView.backgroundColor = .secondarySystemBackground
        contentView.layer.cornerRadius = 12
//        imageView.clipsToBounds = true
        contentView.addSubview(imageView)
        contentView.addSubview(deleteButton)
        setConstraints()
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            deleteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: -8),
            deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 8),
            deleteButton.widthAnchor.constraint(equalToConstant: 28),
            deleteButton.heightAnchor.constraint(equalToConstant: 28)
        ])
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.kf.cancelDownloadTask()
        imageView.image = nil
        onDeleteTapped = nil
        setDeleteMode(false)
    }

    @objc private func deleteTapped() {
        onDeleteTapped?()
    }
    
    func configure(with dog: Dog) {
        if let url = URL(string: dog.imageUrl) {
            imageView.kf.indicatorType = .activity
            imageView.kf.setImage(
                with: url,
                options: [.transition(.fade(0.2)), .cacheOriginalImage]
            )
        } else {
            imageView.image = nil
        }
    }
    
    func setDeleteMode(_ enabled: Bool) {
        deleteButton.isHidden = !enabled
    }
}
