//
//  UsersViewController.swift
//  stack-overflow-users
//
//  Created by Ian-Andoni Magarzo Fernandez on 21/5/26.
//

import UIKit
import SwiftUI

final class UsersViewController: UIViewController {

    private let tableView = UITableView()

    private lazy var users: [UserModel] = (1...20).map { index in
        UserModel(
            id: index,
            displayName: "John",
            reputation: index * 10,
            profileImageURL: nil,
            isFollowed: index % 2 == 0
        )
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Users"

        applyStyling()
        configureTableView()
    }

    private func applyStyling() {
        view.backgroundColor = .red
    }

    private func configureTableView() {
        self.addTableView()
        self.registerCells()
    }
    
    private func addTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func registerCells() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UserCell")
    }
}

extension UsersViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)
        let userModel = users[indexPath.row]

        var content = cell.defaultContentConfiguration()
        content.text = userModel.displayName
        content.secondaryText = "\(userModel.reputation) rep"
        cell.contentConfiguration = content
        cell.accessoryType = userModel.isFollowed ? .checkmark : .none

        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
}

#Preview {
    UINavigationController(
        rootViewController: UsersViewController()
    )
}
