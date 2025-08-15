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
    private lazy var label: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.numberOfLines = 1
        return l
    }()
    
    lazy var dogButton: UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
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
        backgroundColor = .secondarySystemBackground
        addSubview(label)
        addSubview(dogButton)
        dogButton.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            label.heightAnchor.constraint(equalToConstant: 20),

            dogButton.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 8),
            dogButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            dogButton.heightAnchor.constraint(equalToConstant: 200),

            dogButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            
            imageView.topAnchor.constraint(equalTo: dogButton.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: dogButton.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: dogButton.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: dogButton.bottomAnchor)
        ])
    }
    
    func configure(with dog: Dog) {
        label.text = dog.status
        if let url = URL(string: dog.message) {
            imageView.kf.setImage(with: url, options: [.transition(.fade(0.2))])
        } else {
            imageView.image = nil
        }
    }
}
