//
//  UsersViewMock.swift
//  stack-overflow-usersTests
//
//  Created by Ian-Andoni Magarzo Fernandez on 22/5/26.
//

import Foundation
@testable import stack_overflow_users

@MainActor
final class UsersViewControllerMock: UsersViewContract {

    // MARK: UsersViewContract

    /// Loading

    private var displayLoadingContinuations: [CheckedContinuation<Void, Never>] = []
    private(set) var displayLoadingTimesCalled = 0
    
    func displayLoading() {
        displayLoadingTimesCalled += 1
        displayLoadingContinuations.forEach { $0.resume() }
        displayLoadingContinuations.removeAll()
    }

    private var hideLoadingContinuations: [CheckedContinuation<Void, Never>] = []
    private(set) var hideLoadingTimesCalled = 0
    
    /// Hide loading
    
    func hideLoading() {
        hideLoadingTimesCalled += 1
        hideLoadingContinuations.forEach { $0.resume() }
        hideLoadingContinuations.removeAll()
    }

    /// Display users

    typealias UserCellUIModel = UserTableViewCell.UIModel
    private var displayedUsersContinuations: [CheckedContinuation<[UserCellUIModel], Never>] = []
    private(set) var displayedUsers: [[UserCellUIModel]] = []
    
    func display(users: [UserCellUIModel]) {
        displayedUsers.append(users)
        displayedUsersContinuations.forEach { $0.resume(returning: users) }
        displayedUsersContinuations.removeAll()
    }
    
    /// Display error

    private var displayedErrorContinuations: [CheckedContinuation<String, Never>] = []
    private(set) var displayedErrorMessages: [String] = []

    func displayError(message: String) {
        displayedErrorMessages.append(message)
        displayedErrorContinuations.forEach { $0.resume(returning: message) }
        displayedErrorContinuations.removeAll()
    }

    // MARK: Test observation hooks
    
    func waitForDisplayLoading() async {
        await withCheckedContinuation { continuation in
            displayLoadingContinuations.append(continuation)
        }
    }

    func waitForHideLoading() async {
        await withCheckedContinuation { continuation in
            hideLoadingContinuations.append(continuation)
        }
    }

    func waitForDisplayUsers() async -> [UserCellUIModel] {
        await withCheckedContinuation { continuation in
            displayedUsersContinuations.append(continuation)
        }
    }

    func waitForDisplayError() async -> String {
        await withCheckedContinuation { continuation in
            displayedErrorContinuations.append(continuation)
        }
    }
}
