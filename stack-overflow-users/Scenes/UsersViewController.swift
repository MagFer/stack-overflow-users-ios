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
        
        var content  = cell.defaultContentConfiguration()
        content.text = "Name \(indexPath.row+1)"
        content.secondaryText = "User \(indexPath.row+1)"
        cell.contentConfiguration = content
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
}

#Preview {
    UINavigationController(
        rootViewController: UsersViewController()
    )
}
