//
//  Utility.swift
//  ISSFriends
//
//  Created by Jacob Benton on 4/7/16.
//  Copyright © 2016 jakebent. All rights reserved.
//

import Foundation

class Utility: NSObject {

    static var currentLocationUrl = "http://api.open-notify.org/iss-now.json"
    static var passTimeUrl = "http://api.open-notify.org/iss-pass.json"

    static let formatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MM/dd/yyyy @ HH:mm:ss"
        return formatter
    }()

    // Format string from time interval for display in an expanded cell inside of the friends list
    static func stringFromTimeInterval(interval: NSTimeInterval) -> String {
        return formatter.stringFromDate(NSDate(timeIntervalSince1970: interval))
    }
}