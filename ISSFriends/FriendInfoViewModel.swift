//
//  FriendInfoViewModel.swift
//  ISSFriends
//
//  Created by Jacob Benton on 4/7/16.
//  Copyright © 2016 jakebent. All rights reserved.
//

import UIKit
import Bond
import Alamofire

// View Model for individual friend cells. It is responsible for making the network request to open-notify to retrieve pass times for the associated friend. It also holds the Friend model, keeps track of whether the cell is expanded, and calculates the height for the cell.
class FriendInfoViewModel: NSObject {

    static let CELL_HEIGHT: CGFloat = 40

    let friend: Observable<Friend>
    let isExpanded = Observable(false)

    init(friend: Friend) {
        self.friend = Observable(friend)
        super.init()
    }

    func requestPassTimes(completion: ([String]?) -> Void) {
        NetworkService.sharedService.getPassTimes(lat: friend.value.coordinate.latitude, lon: friend.value.coordinate.longitude) { (response) -> Void in
            guard let
                value = response.result.value as? [String: AnyObject],
                result = value["response"] as? [[String: NSTimeInterval]]
                else { completion(nil); return }

            let times = result.flatMap({ (timeDict) -> String in
                let interval = timeDict["risetime"] ?? NSDate().timeIntervalSince1970 //if risetime doesn't exist, use today's date
                return Utility.stringFromTimeInterval(interval)
            })

            completion(times)
        }
    }

    func toggle() {
        isExpanded.value = !isExpanded.value
    }

    func height() -> CGFloat {
        if isExpanded.value {
            return FriendInfoViewModel.CELL_HEIGHT + (FriendInfoViewModel.CELL_HEIGHT * 3) + 8
        }
        return FriendInfoViewModel.CELL_HEIGHT
    }
}
