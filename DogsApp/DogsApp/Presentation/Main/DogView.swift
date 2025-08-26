//
//  DogView.swift
//  DogsApp
//
//  Created by Galina Abdurashitova on 14.08.2025.
//

import Foundation
import UIKit
import Kingfisher

class DogView: UIView {
    var onTapImage: (() -> Void)?
    var onTapLike: (() -> Void)?
    
    private lazy var dogButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.contentInsets = .zero
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 12
        button.clipsToBounds = true
        button.addAction(UIAction { [weak self] _ in self?.onTapImage?() }, for: .primaryActionTriggered)
        button.accessibilityLabel = "Dog image"
        return button
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var likeButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "heart")
        config.preferredSymbolConfigurationForImage = .init(pointSize: 30, weight: .regular)
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .systemRed
        button.addAction(UIAction { [weak self] _ in self?.onTapLike?() }, for: .primaryActionTriggered)
        button.accessibilityLabel = "Like"
        return button
    }()
    
    private let vstack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .center
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .clear
        addSubview(vstack)
        vstack.addArrangedSubview(dogButton)
        vstack.addArrangedSubview(likeButton)
        dogButton.addSubview(imageView)
        setConstraints()
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            dogButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            dogButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            dogButton.heightAnchor.constraint(equalToConstant: 200),
            dogButton.widthAnchor.constraint(equalToConstant: 200),
            
            imageView.topAnchor.constraint(equalTo: dogButton.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: dogButton.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: dogButton.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: dogButton.bottomAnchor),
            
            likeButton.topAnchor.constraint(equalTo: dogButton.bottomAnchor, constant: 16),
            likeButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            likeButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            likeButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    func apply(_ data: DogViewData) {
        if let url = data.imageURL {
            imageView.kf.indicatorType = .activity
            imageView.kf.setImage(
                with: url,
                placeholder: nil,
                options: [.transition(.fade(0.2)), .cacheOriginalImage]
            )
        } else {
            imageView.image = nil
        }

        setLiked(data.isLiked)
    }

    func setLiked(_ liked: Bool) {
        let name = liked ? "heart.fill" : "heart"
        var config = likeButton.configuration
        config?.image = UIImage(systemName: name)
        likeButton.configuration = config
    }
}
