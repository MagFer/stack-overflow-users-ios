//
//  UserModelTests.swift
//  stack-overflow-usersTests
//
//  Created by Ian-Andoni Magarzo Fernandez on 21/5/26.
//

import Foundation
import Testing
@testable import stack_overflow_users

struct UserModelTests {

    private final class TestBundleAnchor {}
    private static let bundle = Bundle(for: TestBundleAnchor.self)

    @Test func userModel_whenMappedFromJSON_preservesAllFields() {
        let userJSON = UserJSON(
            userId: 22656,
            displayName: "Jon Skeet",
            reputation: 1527350,
            profileImage: "https://example.com/avatar.png"
        )

        let userModel = UserModel(json: userJSON, isFollowed: false)

        #expect(userModel.id == 22656)
        #expect(userModel.displayName == "Jon Skeet")
        #expect(userModel.reputation == 1527350)
        #expect(userModel.profileImageURL == URL(string: "https://example.com/avatar.png"))
        #expect(userModel.isFollowed == false)
    }

    @Test func userModel_whenJSONHasNoProfileImage_mapsToNilURL() {
        let userJSON = UserJSON(userId: 1, displayName: "Anon", reputation: 0, profileImage: nil)

        let userModel = UserModel(json: userJSON, isFollowed: false)

        #expect(userModel.profileImageURL == nil)
    }

    @Test func userModel_whenInitialized_preservesIsFollowedFlag() {
        let userJSON = UserJSON(userId: 1, displayName: "Anon", reputation: 0, profileImage: nil)

        let userModelFollowed = UserModel(json: userJSON, isFollowed: true)
        let userModelNotFollowed = UserModel(json: userJSON, isFollowed: false)

        #expect(userModelFollowed.isFollowed == true)
        #expect(userModelNotFollowed.isFollowed == false)
    }

    @Test func userModel_whenMappedFromUsersJSONFile_firstUserPreservesDomainFields() throws {
        let firstUserJSON = try Self.firstUserJSONFromUsersJSONFile()

        let firstUserModel = UserModel(json: firstUserJSON, isFollowed: false)

        #expect(firstUserModel.id == 22656)
        #expect(firstUserModel.displayName == "Jon Skeet")
        #expect(firstUserModel.reputation == 1527350)
        #expect(firstUserModel.profileImageURL == URL(string: "https://www.gravatar.com/avatar/6d8ebb117e8d83d74ea95fbdd0f87e13?s=256&d=identicon&r=PG"))
        #expect(firstUserModel.isFollowed == false)
    }

    @Test func userModel_whenAllFieldsEqual_areEqualAndHashSame() {
        let userModelA = UserModel(id: 1, displayName: "X", reputation: 10, profileImageURL: nil, isFollowed: false)
        let userModelB = UserModel(id: 1, displayName: "X", reputation: 10, profileImageURL: nil, isFollowed: false)

        #expect(userModelA == userModelB)
        #expect(userModelA.hashValue == userModelB.hashValue)
    }

    @Test func userModel_whenIsFollowedDiffers_areNotEqual() {
        let userModelUnfollowed = UserModel(id: 1, displayName: "X", reputation: 10, profileImageURL: nil, isFollowed: false)
        let userModelFollowed = UserModel(id: 1, displayName: "X", reputation: 10, profileImageURL: nil, isFollowed: true)

        #expect(userModelUnfollowed != userModelFollowed)
    }

    // MARK: - Helpers

    private static func firstUserJSONFromUsersJSONFile() throws -> UserJSON {
        let userJSONFileURL = try #require(
            bundle.url(forResource: "usersJSON", withExtension: "json"),
            "Missing usersJSON.json fixture in test bundle"
        )
        let usersData = try Data(contentsOf: userJSONFileURL)
        let usersResponseJSON = try JSONDecoder().decode(UsersResponseJSON.self, from: usersData)
        return try #require(usersResponseJSON.items.first)
    }
}
