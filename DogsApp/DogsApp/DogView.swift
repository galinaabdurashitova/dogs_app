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
    let dog: Dog
    
    private lazy var label: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.numberOfLines = 1
        return l
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    init(dog: Dog) {
        self.dog = dog
        super.init(frame: .zero) // или любой нужный frame
        setupView()
        configure(with: dog)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .secondarySystemBackground

        addSubview(label)
        addSubview(imageView)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            imageView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 8),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
//            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
//            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 400),

            imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ])
    }
    
    private func configure(with dog: Dog) {
        label.text = dog.status
        if let url = URL(string: dog.message) {
            imageView.kf.setImage(with: url, options: [.transition(.fade(0.2))])
        } else {
            imageView.image = nil
        }
    }
}
