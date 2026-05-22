//
//  UsersWorkerStub.swift
//  stack-overflow-usersTests
//
//  Created by Ian-Andoni Magarzo Fernandez on 22/5/26.
//

import Foundation
@testable import stack_overflow_users

struct UsersWorkerStub: UsersWorkerContract {

    let result: Result<UsersResponseJSON, Error>

    func fetchUsers() async throws -> UsersResponseJSON {
        try result.get()
    }
}
