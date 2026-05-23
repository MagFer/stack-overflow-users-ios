//
//  FollowStore.swift
//  stack-overflow-users
//
//  Created by Ian-Andoni Magarzo Fernandez on 23/5/26.
//

import Foundation

protocol FollowStoreContract: Sendable {
    func followedUserIDs() async -> Set<Int>
    func toggle(userID: Int) async
}

actor FollowStore: FollowStoreContract {

    private static let followedUserIDskey = "followedUserIDs"

    private let defaults: UserDefaults
    private var followedIDs: Set<Int>

    init(
        userDefaults: UserDefaults = .standard
    ) {
        self.defaults = userDefaults
        let savedFollowedUserIDs = userDefaults.array(forKey: Self.followedUserIDskey) as? [Int] ?? []
        self.followedIDs = Set(savedFollowedUserIDs)
    }

    func followedUserIDs() -> Set<Int> {
        followedIDs
    }

    func toggle(userID: Int) {
        if followedIDs.contains(userID) {
            followedIDs.remove(userID)
        } else {
            followedIDs.insert(userID)
        }
        defaults.set(Array(followedIDs), forKey: Self.followedUserIDskey)
    }
}
