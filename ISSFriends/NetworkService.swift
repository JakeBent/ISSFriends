//
//  NetworkService.swift
//  ISSFriends
//
//  Created by Jacob Benton on 4/7/16.
//  Copyright © 2016 jakebent. All rights reserved.
//

import Foundation
import Alamofire

class NetworkService: NSObject {

    static let sharedService = NetworkService()

    func getCurrentISSLocation(completion: (Response<AnyObject, NSError>) -> Void) {
        Alamofire
            .request(.GET, "http://api.open-notify.org/iss-now.json")
            .responseJSON(completionHandler: completion)
    }

    func getPassTimes(lat lat: Double, long: Double, count: Int = 3, completion: (Response<AnyObject, NSError>) -> Void) {
        let params: [String: AnyObject] = [
            "lat": lat,
            "lon": long,
            "n": count
        ]
        Alamofire
            .request(.GET, "http://api.open-notify.org/iss-pass.json", parameters: params)
            .responseJSON(completionHandler: completion)
    }
}
