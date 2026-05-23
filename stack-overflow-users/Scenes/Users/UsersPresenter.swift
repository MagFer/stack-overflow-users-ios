//
//  UsersPresenter.swift
//  stack-overflow-users
//
//  Created by Ian-Andoni Magarzo Fernandez on 22/5/26.
//

import Foundation

@MainActor
protocol UsersPresenterContract: AnyObject {
    func viewDidLoad()
    func didTapFollowButton(forUserID userID: Int)
}

@MainActor
final class UsersPresenter: UsersPresenterContract {

    weak var view: UsersViewContract?

    private let provider: UsersProviderContract
    private let router: UsersRouterContract

    private var loadUsersTask: Task<Void, Never>?

    init(
        usersProvider: UsersProviderContract,
        usersRouter: UsersRouterContract
    ) {
        self.provider = usersProvider
        self.router = usersRouter
    }

    deinit {
        loadUsersTask?.cancel()
    }

    func viewDidLoad() {
        loadUsersTask?.cancel()
        loadUsersTask = Task { [weak self] in
            await self?.loadUsers()
        }
    }

    private func loadUsers() async {
        view?.displayLoading()
        do {
            let users = try await provider.getUsers()
            let viewModels = users.map { UserTableViewCell.UIModel(from: $0) }
            view?.display(users: viewModels)
        } catch {
            view?.displayError(message: "Couldn't load users. Please check your connection and try again.")
            // TODO: Interecept different kinds of errors and react accordingly.
        }
        view?.hideLoading()
    }

    func didTapFollowButton(forUserID userID: Int) {
        // TODO: Simulat locally follow functionallity
    }
}
