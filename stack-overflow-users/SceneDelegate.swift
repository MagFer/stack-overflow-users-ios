//
//  SceneDelegate.swift
//  stack-overflow-users
//
//  Created by Ian-Andoni Magarzo Fernandez on 21/5/26.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }

        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = UINavigationController(
            rootViewController: UsersViewController(provider: UsersProvider())
        )
        window.makeKeyAndVisible()
        self.window = window
    }
}
