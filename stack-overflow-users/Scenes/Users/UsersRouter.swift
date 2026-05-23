//
//  UsersRouter.swift
//  stack-overflow-users
//
//  Created by Ian-Andoni Magarzo Fernandez on 22/5/26.
//

import UIKit

@MainActor
protocol UsersRouterContract: AnyObject {
    // TODO: Add navigation points in the future
    // Example: goToUserDetail()
}

@MainActor
final class UsersRouter: UsersRouterContract {

    weak var viewController: UIViewController?
}
