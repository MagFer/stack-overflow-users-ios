//
//  UsersPresenterTests.swift
//  stack-overflow-usersTests
//
//  Created by Ian-Andoni Magarzo Fernandez on 22/5/26.
//

import Foundation
import Testing
@testable import stack_overflow_users

@MainActor
struct UsersPresenterTests {

    @Test func usersPresenter_whenViewDidLoadCalled_displaysLoading() async {
        let viewMock = UsersViewControllerMock()
        let presenter = makePresenter(
            usersProviderResult: .success([]),
            view: viewMock
        )

        presenter.viewDidLoad()
        await viewMock.waitForDisplayLoading()

        #expect(viewMock.displayLoadingTimesCalled == 1)
    }

    @Test func usersPresenter_whenProviderReturnsUsers_displaysMappedUIModels() async {
        let viewMock = UsersViewControllerMock()
        let userModel = UserModel(
            id: 22656,
            displayName: "Jon Skeet",
            reputation: 1_527_350,
            profileImageURL: URL(string: "https://example.com/a.png"),
            isFollowed: true
        )
        let presenter = makePresenter(
            usersProviderResult: .success([userModel]),
            view: viewMock
        )

        presenter.viewDidLoad()
        let displayed = await viewMock.waitForDisplayUsers()

        #expect(viewMock.displayedUsers.count == 1)
        #expect(displayed.count == 1)
        #expect(displayed.first?.userID == 22656)
        #expect(displayed.first?.displayName == "Jon Skeet")
        #expect(displayed.first?.reputation == "1527350")
        #expect(displayed.first?.profileImageURL == URL(string: "https://example.com/a.png"))
        #expect(displayed.first?.followed == true)
    }

    @Test func usersPresenter_whenProviderThrows_displaysError() async {
        let viewMock = UsersViewControllerMock()
        let presenter = makePresenter(
            usersProviderResult: .failure(StubError.boom),
            view: viewMock
        )

        presenter.viewDidLoad()
        let errorMessage = await viewMock.waitForDisplayError()

        #expect(!errorMessage.isEmpty)
        #expect(viewMock.displayedUsers.isEmpty)
    }

    @Test func usersPresenter_whenViewDidLoadSucceeds_hidesLoading() async {
        let viewMock = UsersViewControllerMock()
        let presenter = makePresenter(usersProviderResult: .success([]), view: viewMock)

        presenter.viewDidLoad()
        await viewMock.waitForHideLoading()

        #expect(viewMock.hideLoadingTimesCalled == 1)
    }

    @Test func usersPresenter_whenViewDidLoadFails_stillHidesLoading() async {
        let viewMock = UsersViewControllerMock()
        let presenter = makePresenter(
            usersProviderResult: .failure(StubError.boom),
            view: viewMock
        )

        presenter.viewDidLoad()
        await viewMock.waitForHideLoading()

        #expect(viewMock.hideLoadingTimesCalled == 1)
    }

    // MARK: Helpers

    private func makePresenter(
        usersProviderResult: Result<[UserModel], Error>,
        view: UsersViewControllerMock
    ) -> UsersPresenter {
        let presenter = UsersPresenter(
            usersProvider: UsersProviderStub(result: usersProviderResult),
            usersRouter: UsersRouterStub()
        )
        presenter.view = view
        return presenter
    }
}

private enum StubError: Error { case boom }
