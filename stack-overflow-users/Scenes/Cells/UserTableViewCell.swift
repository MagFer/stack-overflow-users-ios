//
//  UserTableViewCell.swift
//  stack-overflow-users
//
//  Created by Ian-Andoni Magarzo Fernandez on 22/5/26.
//

import UIKit
import OSLog

protocol UserTableViewCellDelegate: AnyObject {
    func didTapFollowButton(forUserWithID userID: Int)
}

final class UserTableViewCell: UITableViewCell {
    
    struct UIModel {
        let userID: Int
        let displayName: String?
        let reputation: String?
        let profileImageURL: URL?
        let followed: Bool?
        
        init(from model: UserModel) {
            self.userID = model.id
            self.displayName = model.displayName
            self.reputation = "\(model.reputation)"
            self.profileImageURL = model.profileImageURL
            self.followed = model.isFollowed
        }
    }
    
    @IBOutlet private var profileImageView: UIImageView!
    @IBOutlet private var userNameLabel: UILabel!
    @IBOutlet private var reputationLabel: UILabel!
    @IBOutlet private var followButton: UIButton!
    
    weak var delegate: UserTableViewCellDelegate?
    private var viewModel: UIModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageTask?.cancel()
        profileImageView.image = nil
    }
    
    private var uiModel: UIModel?
    func populate(with model: UIModel) {
        self.uiModel = model
        
        self.userNameLabel.text = self.uiModel?.displayName
        self.reputationLabel.text = self.uiModel?.reputation
        self.followButton.setTitle(
            self.uiModel?.followed == true ? "Unfollow" : "Follow",
            for: .normal
        )
        loadProfileImage(from: self.uiModel?.profileImageURL)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private var imageTask: Task<Void, Never>?
    private func loadProfileImage(from url: URL?) {
         imageTask?.cancel()
         profileImageView.image = nil
         guard let url else { return }

         imageTask = Task { [weak self] in
             let image = await ImageWorker.shared.loadImage(from: url)
             guard !Task.isCancelled else { return }
             self?.profileImageView.image = image
         }
     }
    
    // MARK: Actions
    
    @IBAction private func followButtonTapped(_ sender: Any) {
        guard let uiModel = self.uiModel else { return }
        delegate?.didTapFollowButton(forUserWithID: uiModel.userID)
        Logger(
            subsystem: "com.ianmagarzo.stackoverflowusers",
            category: "UserTableViewCell"
        )
        .debug("Follow button tapped \(uiModel.userID)")  
    }
}
