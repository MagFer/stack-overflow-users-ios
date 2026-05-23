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

    private var currentUsers: [UserModel] = []
    private var loadUsersTask: Task<Void, Never>?
    private var toggleFollowTask: Task<Void, Never>?

    init(
        usersProvider: UsersProviderContract,
        usersRouter: UsersRouterContract
    ) {
        self.provider = usersProvider
        self.router = usersRouter
    }

    deinit {
        loadUsersTask?.cancel()
        toggleFollowTask?.cancel()
    }
    
    // MARK: Inputs

    func viewDidLoad() {
        loadUsersTask?.cancel()
        loadUsersTask = Task { [weak self] in
            await self?.loadUsers()
        }
    }

    func didTapFollowButton(forUserID userID: Int) {
        guard let user = currentUsers.first(where: { $0.id == userID }) else {
            // TODO: Display unknown error in bottom banner
            return
        }
        toggleFollowTask?.cancel()
        toggleFollowTask = Task { [weak self] in
            await self?.toggleFollow(for: user)
        }
    }
    
    // MARK: Logic
    
    private func loadUsers() async {
        view?.displayLoading()
        do {
            let users = try await provider.getUsers()
            currentUsers = users
            view?.display(users: users.map { UserTableViewCell.UIModel(from: $0) })
        } catch {
            currentUsers = []
            view?.displayError(message: "Couldn't load users. Please check your connection and try again.")
            // TODO: Interecept different kinds of errors and react accordingly.
        }
        view?.hideLoading()
    }

    private func toggleFollow(for user: UserModel) async {
        do {
            let updated = try await provider.toggleFollow(for: user)
            guard let index = currentUsers.firstIndex(where: { $0.id == updated.id }) else { return }
            currentUsers[index] = updated
            view?.display(users: currentUsers.map { UserTableViewCell.UIModel(from: $0) })
        } catch {
            // TODO: Display follow failure as bottom banner once we have a real backend
        }
    }
}
