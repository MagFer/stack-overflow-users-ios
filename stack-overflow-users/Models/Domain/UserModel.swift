//
//  UserModel.swift
//  stack-overflow-users
//
//  Created by Ian-Andoni Magarzo Fernandez on 21/5/26.
//

import Foundation

struct UserModel: Hashable, Identifiable {
    let id: Int
    let displayName: String
    let reputation: Int
    let profileImageURL: URL?
    let isFollowed: Bool
}

extension UserModel {
    init(json: UserJSON, isFollowed: Bool) {
        self.id = json.userId
        self.displayName = json.displayName
        self.reputation = json.reputation
        self.profileImageURL = json.profileImage.flatMap(URL.init)
        self.isFollowed = isFollowed
    }

    func with(isFollowed: Bool) -> Self {
        .init(
            id: id,
            displayName: displayName,
            reputation: reputation,
            profileImageURL: profileImageURL,
            isFollowed: isFollowed
        )
    }
}

#if DEBUG
extension UserModel {
    static var mocks: [Self] {
        [
            UserModel(
                json: .init(
                    userId: 22656,
                    displayName: "Jon Skeet", 
                    reputation: 1527350, 
                    profileImage: "https://www.gravatar.com/avatar/6d8ebb117e8d83d74ea95fbdd0f87e13?s=256&d=identicon&r=PG"
                ),
                isFollowed: true
            ),
            UserModel(
                json: .init(
                    userId: 6309,
                    displayName: "VonC",
                    reputation: 1370686,
                    profileImage: "https://i.sstatic.net/I4fiW.jpg?s=256"),
                isFollowed: false
            ),
            UserModel(
                json: .init(
                    userId: 1144035,
                    displayName: "Gordon Linoff", 
                    reputation: 1276832, 
                    profileImage: "https://www.gravatar.com/avatar/e514b017977ebf742a418cac697d8996?s=256&d=identicon&r=PG"
                ),
                isFollowed: false
            ),
            UserModel(
                json: .init(
                    userId: 100297,
                    displayName: "Martijn Pieters", 
                    reputation: 1141895, 
                    profileImage: "https://www.gravatar.com/avatar/24780fb6df85a943c7aea0402c843737?s=256&d=identicon&r=PG"
                ),
                isFollowed: false
            ),
            UserModel(
                json: .init(
                    userId: 157882,
                    displayName: "BalusC", 
                    reputation: 1115679, 
                    profileImage: "https://www.gravatar.com/avatar/89927e2f4bde24991649b353a37678b9?s=256&d=identicon&r=PG"
                ),
                isFollowed: true
            ),
            UserModel(
                json: .init(
                    userId: 157247,
                    displayName: "T.J. Crowder", 
                    reputation: 1083430,
                    profileImage: "https://i.sstatic.net/lUM5Z.jpg?s=256"
                ),
                isFollowed: false
            ),
            UserModel(
                json: .init(
                    userId: 23354,
                    displayName: "Marc Gravell", 
                    reputation: 1072321, 
                    profileImage: "https://i.sstatic.net/CrVFH.png?s=256"
                ),
                isFollowed: false
            ),
            UserModel(
                json: .init(
                    userId: 29407,
                    displayName: "Darin Dimitrov", 
                    reputation: 1042799, 
                    profileImage: "https://www.gravatar.com/avatar/e3a181e9cdd4757a8b416d93878770c5?s=256&d=identicon&r=PG"
                ),
                isFollowed: false
            ),
            UserModel(
                json: .init(
                    userId: 115145,
                    displayName: "CommonsWare", 
                    reputation: 1011892,
                    profileImage: "https://i.sstatic.net/wDnd8.png?s=256"
                ),
                isFollowed: true
            ),
            UserModel(
                json: .init(
                    userId: 893,
                    displayName: "Greg Hewgill", 
                    reputation: 1006407,
                    profileImage: "https://www.gravatar.com/avatar/747ffa5da3538e66840ebc0548b8fd58?s=256&d=identicon&r=PG"
                ),
                isFollowed: false
            ),
            UserModel(
                json: .init(
                    userId: 19068,
                    displayName: "Quentin", 
                    reputation: 949263, 
                    profileImage: "https://www.gravatar.com/avatar/1d2d3229ed1961d2bd81853242493247?s=256&d=identicon&r=PG"
                ),
                isFollowed: false
            ),
            UserModel(
                json: .init(
                    userId: 17034,
                    displayName: "Hans Passant", 
                    reputation: 947695,
                    profileImage: "https://i.sstatic.net/Cii6b.png?s=256"
                ),
                isFollowed: false
            ),
            UserModel(
                json: .init(
                    userId: 34397,
                    displayName: "SLaks", 
                    reputation: 892216,
                    profileImage: "https://www.gravatar.com/avatar/7deca8ec973c3c0875e9a36e1e3e2c44?s=256&d=identicon&r=PG"
                ),
                isFollowed: true
            ),
            UserModel(
                json: .init(
                    userId: 3732271,
                    displayName: "akrun", 
                    reputation: 891687,
                    profileImage: "https://i.sstatic.net/4WkGW.jpg?s=256"
                ),
                isFollowed: false
            ),
            UserModel(
                json: .init(
                    userId: 14860,
                    displayName: "paxdiablo", 
                    reputation: 890704,
                    profileImage: "https://i.sstatic.net/vXG1F.png?s=256"
                ),
                isFollowed: false
            ),
            UserModel(
                json: .init(
                    userId: 95810,
                    displayName: "Alex Martelli", 
                    reputation: 889411,
                    profileImage: "https://www.gravatar.com/avatar/e8d5fe90f1fe2148bf130cccd4dc311c?s=256&d=identicon&r=PG"
                ),
                isFollowed: false
            ),
            UserModel(
                json: .init(
                    userId: 190597,
                    displayName: "unutbu", 
                    reputation: 887953,
                    profileImage: "https://www.gravatar.com/avatar/8f7683207b9fcc8e77120265517f7ce9?s=256&d=identicon&r=PG&f=y&so-version=2"
                ),
                isFollowed: true
            ),
            UserModel(
                json: .init(
                    userId: 2901002,
                    displayName: "jezrael", 
                    reputation: 868739,
                    profileImage: "https://i.sstatic.net/hMDvl.jpg?s=256"
                ),
                isFollowed: false
            ),
            UserModel(
                json: .init(
                    userId: 61974,
                    displayName: "Mark Byers", 
                    reputation: 845120,
                    profileImage: "https://www.gravatar.com/avatar/ad240ed5cc406759f0fd72591dc8ca47?s=256&d=identicon&r=PG"
                ),
                isFollowed: false
            ),
            UserModel(
                json: .init(
                    userId: 5445,
                    displayName: "Christian C. Salvadó", 
                    reputation: 832148,
                    profileImage: "https://www.gravatar.com/avatar/932fb89b9d4049cec5cba357bf0ae388?s=256&d=identicon&r=PG"
                ),
                isFollowed: false
            )
        ]
    }
}
#endif

