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

    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 12
        return iv
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.layer.cornerRadius = 12
        contentView.clipsToBounds = true

        contentView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.kf.cancelDownloadTask()
        imageView.image = nil
    }

    func configure(with dog: Dog) {
        if let url = URL(string: dog.message) {
            imageView.kf.indicatorType = .activity
            imageView.kf.setImage(
                with: url,
                options: [.transition(.fade(0.2)), .cacheOriginalImage]
            )
        } else {
            imageView.image = nil
        }
    }
}
