//
//  UserJSON.swift
//  stack-overflow-users
//
//  Created by Ian-Andoni Magarzo Fernandez on 21/5/26.
//

import Foundation

struct UserJSON: Decodable {
    let userId: Int
    let displayName: String
    let reputation: Int
    let profileImage: String?

    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case displayName = "display_name"
        case reputation
        case profileImage = "profile_image"
    }
}
