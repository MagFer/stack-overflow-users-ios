//
//  UserJSONTests.swift
//  stack-overflow-usersTests
//
//  Created by Ian-Andoni Magarzo Fernandez on 21/5/26.
//

import Foundation
import Testing
@testable import stack_overflow_users

struct UserJSONTests {

    private final class TestBundleAnchor {}
    private static let bundle = Bundle(for: TestBundleAnchor.self)

    @Test func userJSON_whenDecodedFromUsersJSONFile_returnsTwentyUsers() throws {
        let usersResponseJSON = try Self.decodeUsersJSONFile()

        #expect(usersResponseJSON.items.count == 20)
    }

    @Test func userJSON_whenDecodedFromUsersJSONFile_mapsFirstUserFields() throws {
        let usersResponseJSON = try Self.decodeUsersJSONFile()
        let firstUserJSON = try #require(usersResponseJSON.items.first)

        #expect(firstUserJSON.userId == 22656)
        #expect(firstUserJSON.displayName == "Jon Skeet")
        #expect(firstUserJSON.reputation == 1527350)
        #expect(firstUserJSON.profileImage == "https://www.gravatar.com/avatar/6d8ebb117e8d83d74ea95fbdd0f87e13?s=256&d=identicon&r=PG")
    }

    @Test func userJSON_whenProfileImageIsNull_decodesAsNil() throws {
        let userJSON = Data("""
        {
            "user_id": 1,
            "display_name": "Test",
            "reputation": 100,
            "profile_image": null
        }
        """.utf8)

        let userModel = try JSONDecoder().decode(UserJSON.self, from: userJSON)

        #expect(userModel.profileImage == nil)
    }

    @Test func userJSON_whenRequiredFieldIsMissing_throwsDecodingError() {
        let userJSON = Data("""
        {
            "user_id": 1,
            "display_name": "Test"
        }
        """.utf8)

        #expect(throws: DecodingError.self) {
            _ = try JSONDecoder().decode(UserJSON.self, from: userJSON)
        }
    }

    // MARK: - Helpers

    private static func decodeUsersJSONFile() throws -> UsersResponseJSON {
        let urlJSONFile = try #require(
            bundle.url(forResource: "usersJSON", withExtension: "json"),
            "Missing usersJSON.json file in test bundle"
        )
        let usersResponseData = try Data(contentsOf: urlJSONFile)
        return try JSONDecoder().decode(UsersResponseJSON.self, from: usersResponseData)
    }
}
