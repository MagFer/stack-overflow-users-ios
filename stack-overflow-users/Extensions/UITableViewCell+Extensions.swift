//
//  UITableViewCell+Extensions.swift
//  stack-overflow-users
//
//  Created by Ian-Andoni Magarzo Fernandez on 22/5/26.
//

import UIKit

extension UITableViewCell {
      static var reuseIdentifier: String { String(describing: self) }
      static var nib: UINib { UINib(nibName: String(describing: self), bundle: nil) }
  }
