//
//  AppCoordinator.swift
//  DogsApp
//
//  Created by Galina Abdurashitova on 26.08.2025.
//

import Foundation
import UIKit

protocol Coordinator {
    func start()
}

final class AppCoordinator: Coordinator {
    private let window: UIWindow
    private let navigationController = UINavigationController()
    private let repo: DogsRepositoryProtocol

    init(window: UIWindow, repo: DogsRepositoryProtocol) {
        self.window = window
        self.repo = repo
    }

    func start() {
        let home = ViewController(doggyRepo: repo)
        home.onShowLibrary = { [weak self] in
            self?.showLibrary()
        }

        navigationController.viewControllers = [home]
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }

    private func showLibrary() {
        let vc = SavedDogsViewController(doggyRepo: repo)
        navigationController.pushViewController(vc, animated: true)
    }
}
