//
//  UsersProvider.swift
//  stack-overflow-users
//
//  Created by Ian-Andoni Magarzo Fernandez on 22/5/26.
//

import Foundation

protocol UsersProviderContract {
    func getUsers() async throws -> [UserModel]
}

final class UsersProvider: UsersProviderContract {

    private let worker: UsersWorkerContract

    init(
        worker: UsersWorkerContract = UsersWorker()
    ) {
        self.worker = worker
    }

    func getUsers() async throws -> [UserModel] {
        let usersResponseJSON = try await worker.fetchUsers()
        return usersResponseJSON.items.map { UserModel(json: $0, isFollowed: false) }
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
}
#endif
