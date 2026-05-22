//
//  UsersViewController.swift
//  stack-overflow-users
//
//  Created by Ian-Andoni Magarzo Fernandez on 21/5/26.
//

import UIKit
import SwiftUI

//final class UsersPresenter {
//    weak var view: UsersViewController?
//
//    private var users: [UserModel] = [] {
//        didSet {
//            
//        }
//    }
//        
//    var fetchTask: Task<Void, Never>?
//    func viewDidLoad() {
//        fetchTask = Task {
//            
//        }
//    }
//    
//}

final class UsersViewController: UIViewController {

    private let tableView = UITableView()
    private let spinner = UIActivityIndicatorView()
    private let errorLabel = UILabel()
    private let provider: UsersProviderContract

    private var users: [UserModel] = []

    init(provider: UsersProviderContract) {
        self.provider = provider
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Users"

        applyStyling()
        configureTableView()
        configureErrorLabel()

        displayLoadingIndicator()
        Task {
            await loadUsers()
            hideLoadingIndicator()
        }
    }

    private func applyStyling() {
        view.backgroundColor = .systemBackground
    }

    private func configureTableView() {
        addTableView()
        registerCells()
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
        tableView.register(
            UserTableViewCell.nib,
            forCellReuseIdentifier: UserTableViewCell.reuseIdentifier
        )
    }

    private func configureErrorLabel() {
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.textAlignment = .center
        errorLabel.numberOfLines = 0
        errorLabel.textColor = .secondaryLabel
        errorLabel.isHidden = true

        view.addSubview(errorLabel)
        NSLayoutConstraint.activate([
            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            errorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
    }
    
    private func displayLoadingIndicator() {
        tableView.isHidden = true
        errorLabel.isHidden = true
        
        spinner.startAnimating()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(spinner)
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func hideLoadingIndicator() {
        spinner.stopAnimating()
        spinner.removeFromSuperview()
    }

    private func loadUsers() async {
        do {
            users = try await provider.getUsers()
            errorLabel.isHidden = true
            tableView.isHidden = false
            tableView.reloadData()
        } catch {
            users = []
            errorLabel.text = "Couldn't load users. Please check your connection and try again."
            errorLabel.isHidden = false
            tableView.isHidden = true
            tableView.reloadData()
        }
    }
}

extension UsersViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: UserTableViewCell.reuseIdentifier,
            for: indexPath
        ) as? UserTableViewCell else {
            return UITableViewCell()
        }
        let userModel = users[indexPath.row]
        cell.populate(with: .init(from: userModel))
        cell.delegate = self
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
}

extension UsersViewController: UserTableViewCellDelegate {
    
    func didTapFollowButton(forUserWithID userID: Int) {
        print("VC tapped follow for user with ID: \(userID)")
    }
}

#if DEBUG
#Preview("Loaded") {
    UINavigationController(
        rootViewController: UsersViewController(provider: UsersProviderMock(
            result: .success(UserModel.mocks))
        )
    )
}

#Preview("Error") {
    UINavigationController(
        rootViewController: UsersViewController(
            provider: UsersProviderMock(
                result: .failure(UsersProviderMock.MockError.unknown)
            )
        )
    )
}
#endif
