//
//  UsersProvider.swift
//  stack-overflow-users
//
//  Created by Ian-Andoni Magarzo Fernandez on 22/5/26.
//

import Foundation

protocol UsersProviderContract {
    func getUsers() async throws -> [UserModel]
    func toggleFollow(for user: UserModel) async throws -> UserModel
}

final class UsersProvider: UsersProviderContract {

    private let worker: UsersWorkerContract
    private let followStore: FollowStoreContract

    init(
        worker: UsersWorkerContract = UsersWorker(),
        followStore: FollowStoreContract = FollowStore()
    ) {
        self.worker = worker
        self.followStore = followStore
    }

    func getUsers() async throws -> [UserModel] {
        async let response = worker.fetchUsers()
        async let followed = followStore.followedUserIDs()
        let (usersResponseJSON, followedUserIDs) = try await (response, followed)

        return usersResponseJSON.items.map {
            UserModel(
                json: $0,
                isFollowed: followedUserIDs.contains($0.userId)
            )
        }
    }

    func toggleFollow(for user: UserModel) async throws -> UserModel {
        try await Task.sleep(for: .seconds(0.3)) // Simulates response delay
        await followStore.toggle(userID: user.id)
        let followedUserIDs = await followStore.followedUserIDs()
        return user.with(isFollowed: followedUserIDs.contains(user.id))
    }
}

#if DEBUG
struct UsersProviderMock: UsersProviderContract {

    enum MockError: Error {
        case errorDescription
        case unknown
    }

    let result: Result<[UserModel], Error>

    init(result: Result<[UserModel], Error>) {
        self.result = result
    }

    func getUsers() async throws -> [UserModel] {
        try await Task.sleep(for: .seconds(2))
        switch result {
        case .success(let success):
            return success
        case .failure(let failure):
            throw failure
        }
    }

    func toggleFollow(for user: UserModel) async throws -> UserModel {
        try await Task.sleep(for: .seconds(0.3)) // Simulates response delay
        return user.with(isFollowed: !user.isFollowed)
    }
}
#endif
