//
//  UsersProviderStub.swift
//  stack-overflow-usersTests
//
//  Created by Ian-Andoni Magarzo Fernandez on 22/5/26.
//

import Foundation
@testable import stack_overflow_users

struct UsersProviderStub: UsersProviderContract {

    let result: Result<[UserModel], Error>

    func getUsers() async throws -> [UserModel] {
        try result.get()
    }
}
