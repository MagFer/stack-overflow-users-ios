//
//  UsersResponseJSON.swift
//  stack-overflow-users
//
//  Created by Ian-Andoni Magarzo Fernandez on 21/5/26.
//

import Foundation

struct UsersResponseJSON: Decodable {
    let items: [UserJSON]
}
