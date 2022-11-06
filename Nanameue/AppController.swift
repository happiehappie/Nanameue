//
//  AppController.swift
//  Nanameue
//
//  Created by Stanley Lim on 28/10/2022.
//

import Foundation
import Firebase

final class AppController {
    static let shared = AppController()
    // swiftlint:disable:next implicitly_unwrapped_optional
    private var window: UIWindow!
    private var rootViewController: UIViewController? {
        didSet {
            window.rootViewController = rootViewController ?? AuthViewController()
        }
    }
    
    init() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleAppState),
            name: .AuthStateDidChange,
            object: nil)
    }
    
    // MARK: - Helpers
    func configureFirebase() {
        FirebaseApp.configure()
    }
    
    func show(in window: UIWindow?) {
        guard let window = window else {
            fatalError("Cannot layout app with a nil window.")
        }
        
        self.window = window
        window.tintColor = .systemCyan
        window.backgroundColor = .white
        
        handleAppState()
        
        window.makeKeyAndVisible()
    }
    
    // MARK: - Notifications
    @objc private func handleAppState() {
        if let user = Auth.auth().currentUser {
            let tweetListViewController = TweetListViewController(currentUser: user)
            rootViewController = UINavigationController(rootViewController: tweetListViewController)
        } else {
            rootViewController = AuthViewController()
        }
    }
}
