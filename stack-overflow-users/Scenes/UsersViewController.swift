//
//  UsersViewController.swift
//  stack-overflow-users
//
//  Created by Ian-Andoni Magarzo Fernandez on 21/5/26.
//

import UIKit
import SwiftUI

final class UsersViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        title = "Users"
    }
}

#Preview {
    UINavigationController(
        rootViewController: UsersViewController()
    )
}
