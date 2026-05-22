//
//  UsersWorker.swift
//  stack-overflow-users
//
//  Created by Ian-Andoni Magarzo Fernandez on 22/5/26.
//

import Foundation

protocol UsersWorkerContract {
    func fetchUsers() async throws -> UsersResponseJSON
}

final class UsersWorker: UsersWorkerContract {

    private static let baseURL = URL(string: "https://api.stackexchange.com")!
    private static let usersPath = "/2.2/users"

    private let session: URLSession
    private let decoder: JSONDecoder

    init(
        session: URLSession = .shared,
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.session = session
        self.decoder = decoder
    }

    func fetchUsers() async throws -> UsersResponseJSON {
        var components = URLComponents(url: Self.baseURL, resolvingAgainstBaseURL: false)!
        components.path = Self.usersPath
        components.queryItems = [
            URLQueryItem(name: "page", value: "1"),
            URLQueryItem(name: "pagesize", value: "20"),
            URLQueryItem(name: "order", value: "desc"),
            URLQueryItem(name: "sort", value: "reputation"),
            URLQueryItem(name: "site", value: "stackoverflow")
        ]
        let (data, _) = try await session.data(from: components.url!)
        return try decoder.decode(UsersResponseJSON.self, from: data)
    }
}
