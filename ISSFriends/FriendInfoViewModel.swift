//
//  FriendInfoViewModel.swift
//  ISSFriends
//
//  Created by Jacob Benton on 4/7/16.
//  Copyright © 2016 jakebent. All rights reserved.
//

import UIKit

// View Model for individual friend cells. It holds the Friend model, keeps track of whether the cell is expanded, and calculates the height for the cell.
class FriendInfoViewModel: NSObject {

    static let CELL_HEIGHT: CGFloat = 40

    let friend: Friend
    var isExpanded = false

    init(friend: Friend) {
        self.friend = friend
    }

    func requestPassTimes(completion: ([String]?) -> Void) {
        NetworkService.sharedService.getPassTimes(lat: friend.coordinate.latitude, long: friend.coordinate.longitude) { (response) -> Void in
            guard let
                value = response.result.value as? [String: AnyObject],
                result = value["response"] as? [[String: NSTimeInterval]]
                else { completion(nil); return }

            completion(result.flatMap({ (timeDict) -> String in
                guard let interval = timeDict["risetime"] else { return "" }
                return Utility.stringFromTimeInterval(interval)
            }))
        }
    }

    func height() -> CGFloat {
        if isExpanded {
            return FriendInfoViewModel.CELL_HEIGHT + (FriendInfoViewModel.CELL_HEIGHT * 3) + 8
        }
        return FriendInfoViewModel.CELL_HEIGHT
    }
}
