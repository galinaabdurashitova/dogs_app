//
//  ViewController.swift
//  DogsApp
//
//  Created by Galina Abdurashitova on 14.08.2025.
//

import UIKit

class ViewController: UIViewController {
    private let doggyService = DogsService()
    private var dogs: [Dog] = []
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var dogStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
//        view.addSubview(scrollView)
        view.addSubview(dogStackView)
        
        NSLayoutConstraint.activate([
            dogStackView.topAnchor.constraint(equalTo: view.topAnchor),
            dogStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            dogStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dogStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor)//,
            
//            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
//            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            
//            dogStackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
//            dogStackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
//            dogStackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
//            dogStackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
//            dogStackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
//            dogStackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -32)
        ])
        
        Task {
            do {
                let dog = try await doggyService.fetchDogs(page: 0, limit: 10)
                await MainActor.run {
//                    for dog in dogs {
                    print(dog)
                    let dogView = DogView(dog: dog)
                    dogStackView.addArrangedSubview(dogView)
//                    }
                }
            } catch {
                print("error")
            }
        }
    }
}

