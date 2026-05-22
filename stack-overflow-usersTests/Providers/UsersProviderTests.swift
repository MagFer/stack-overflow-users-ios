//
//  UsersProviderTests.swift
//  stack-overflow-usersTests
//
//  Created by Ian-Andoni Magarzo Fernandez on 22/5/26.
//

import Foundation
import Testing
@testable import stack_overflow_users

struct UsersProviderTests {

    @Test func usersProvider_whenWorkerReturnsItems_mapsToUserModels() async throws {
        let response = UsersResponseJSON(items: [
            UserJSON(userId: 22656, displayName: "Jon Skeet", reputation: 1_527_350, profileImage: "https://example.com/a.png"),
            UserJSON(userId: 6309, displayName: "VonC", reputation: 1_370_686, profileImage: nil)
        ])
        let provider = UsersProvider(worker: UsersWorkerStub(result: .success(response)))

        let models = try await provider.getUsers()

        #expect(models.count == 2)
        #expect(models[0].id == 22656)
        #expect(models[0].displayName == "Jon Skeet")
        #expect(models[0].reputation == 1_527_350)
        #expect(models[0].profileImageURL == URL(string: "https://example.com/a.png"))
        #expect(models[1].id == 6309)
        #expect(models[1].profileImageURL == nil)
    }

    @Test func usersProvider_whenWorkerThrows_propagatesError() async {
        let provider = UsersProvider(worker: UsersWorkerStub(result: .failure(StubError.boom)))

        await #expect(throws: StubError.self) {
            _ = try await provider.getUsers()
        }
    }

    @Test func usersProvider_whenMappingItems_setsIsFollowedToFalse() async throws {
        let response = UsersResponseJSON(items: [
            UserJSON(userId: 1, displayName: "X", reputation: 0, profileImage: nil)
        ])
        let provider = UsersProvider(worker: UsersWorkerStub(result: .success(response)))

        let models = try await provider.getUsers()

        #expect(models.first?.isFollowed == false)
    }
}

// MARK: - Test doubles

private enum StubError: Error { case boom }
