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
        l.textAlignment = .center
        l.numberOfLines = 1
        return l
    }()
    
    lazy var dogButton: UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.layer.cornerRadius = 12
        b.clipsToBounds = true
        return b
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
//        imageView.clipsToBounds = true
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
        backgroundColor = .clear
        addSubview(label)
        addSubview(dogButton)
        dogButton.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            label.bottomAnchor.constraint(equalTo: dogButton.topAnchor, constant: -12),
            
            dogButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            dogButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            dogButton.heightAnchor.constraint(equalToConstant: 200),
            dogButton.widthAnchor.constraint(equalToConstant: 200),

            
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
