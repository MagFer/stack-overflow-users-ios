//
//  UsersConfigurator.swift
//  stack-overflow-users
//
//  Created by Ian-Andoni Magarzo Fernandez on 22/5/26.
//

import UIKit

enum UsersConfigurator {

    @MainActor
    static func makeVC(
        usersProvider: UsersProviderContract = UsersProvider()
    ) -> UIViewController {
        let router = UsersRouter()
        let presenter = UsersPresenter(
            usersProvider: usersProvider,
            usersRouter: router
        )
        let viewController = UsersViewController(
            usersPresenter: presenter
        )

        presenter.view = viewController
        router.viewController = viewController

        return viewController
    }
}
