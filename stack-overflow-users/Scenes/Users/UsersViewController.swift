//
//  UsersViewController.swift
//  stack-overflow-users
//
//  Created by Ian-Andoni Magarzo Fernandez on 21/5/26.
//

import UIKit
import SwiftUI

@MainActor
protocol UsersViewContract: AnyObject {
    func displayLoading()
    func hideLoading()
    func display(users: [UserTableViewCell.UIModel])
    func displayError(message: String)
}

final class UsersViewController: UIViewController {

    private let tableView = UITableView()
    private let spinner = UIActivityIndicatorView()
    private let errorLabel = UILabel()
    private let presenter: UsersPresenterContract

    private var users: [UserTableViewCell.UIModel] = []

    init(
        usersPresenter: UsersPresenterContract
    ) {
        self.presenter = usersPresenter
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

        presenter.viewDidLoad()
    }

    private func applyStyling() {
        view.backgroundColor = .systemBackground
        spinner.color = .accent
    }

    private func configureTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self

        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

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
}

// MARK: UsersViewContract

extension UsersViewController: UsersViewContract {

    func displayLoading() {
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

    func hideLoading() {
        spinner.stopAnimating()
        spinner.removeFromSuperview()
    }

    func display(users: [UserTableViewCell.UIModel]) {
        self.users = users
        errorLabel.isHidden = true
        tableView.isHidden = false
        tableView.reloadData()
    }

    func displayError(message: String) {
        self.users = []
        errorLabel.text = message
        errorLabel.isHidden = false
        tableView.isHidden = true
        tableView.reloadData()
    }
}

// MARK: UITableViewDataSource

extension UsersViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: UserTableViewCell.reuseIdentifier,
            for: indexPath
        ) as? UserTableViewCell else {
            return UITableViewCell()
        }
        cell.populate(with: users[indexPath.row])
        cell.delegate = self
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int { 1 }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        users.count
    }
}

// MARK: UserTableViewCellDelegate

extension UsersViewController: UserTableViewCellDelegate {

    func didTapFollowButton(forUserWithID userID: Int) {
        presenter.didTapFollowButton(forUserID: userID)
    }
}

#if DEBUG
#Preview("Loaded") {
    UINavigationController(
        rootViewController: UsersConfigurator.makeVC(
            usersProvider: UsersProviderMock(result: .success(UserModel.mocks))
        )
    )
}

#Preview("Error") {
    UINavigationController(
        rootViewController: UsersConfigurator.makeVC(
            usersProvider: UsersProviderMock(result: .failure(UsersProviderMock.MockError.unknown))
        )
    )
}
#endif
