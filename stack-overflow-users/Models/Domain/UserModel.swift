//
//  UserModel.swift
//  stack-overflow-users
//
//  Created by Ian-Andoni Magarzo Fernandez on 21/5/26.
//

import Foundation

struct UserModel: Hashable, Identifiable {
    let id: Int
    let displayName: String
    let reputation: Int
    let profileImageURL: URL?
    let isFollowed: Bool
}

extension UserModel {
    init(json: UserJSON, isFollowed: Bool) {
        self.id = json.userId
        self.displayName = json.displayName
        self.reputation = json.reputation
        self.profileImageURL = json.profileImage.flatMap(URL.init)
        self.isFollowed = isFollowed
    }
}
