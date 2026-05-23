//
//  UsersProviderSpy.swift
//  stack-overflow-usersTests
//
//  Created by Ian-Andoni Magarzo Fernandez on 22/5/26.
//

import Foundation
@testable import stack_overflow_users

final class UsersProviderSpy: UsersProviderContract {

    let getUsersResult: Result<[UserModel], Error>
    let toggleFollowResult: Result<UserModel, Error>?

    init(
        getUsersResult: Result<[UserModel], Error>,
        toggleFollowResult: Result<UserModel, Error>? = nil
    ) {
        self.getUsersResult = getUsersResult
        self.toggleFollowResult = toggleFollowResult
    }

    /// Get users
    
    private(set) var lastToggleFollowUser: UserModel?

    func getUsers() async throws -> [UserModel] {
        try getUsersResult.get()
    }

    /// Toggle follow
    
    enum SpyError: Error {
        case toggleFollowNotConfigured
    }

    private(set) var toggleFollowCallCount = 0
    
    func toggleFollow(for user: UserModel) async throws -> UserModel {
        toggleFollowCallCount += 1
        lastToggleFollowUser = user
        guard let toggleFollowResult else {
            throw SpyError.toggleFollowNotConfigured
        }
        return try toggleFollowResult.get()
    }
}
