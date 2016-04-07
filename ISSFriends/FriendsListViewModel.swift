//
//  FriendsListViewModel.swift
//  ISSFriends
//
//  Created by Jacob Benton on 4/7/16.
//  Copyright © 2016 jakebent. All rights reserved.
//

import UIKit
import Bond

// This view model just takes a list of Friends (Just names and coordinates) and creates view models for the expanding cells 
class FriendsListViewModel: NSObject {

    let viewModels = ObservableArray<FriendInfoViewModel>([])

    init(friends: [Friend]) {
        viewModels.array = friends.flatMap({ FriendInfoViewModel(friend: $0) })
    }
}
