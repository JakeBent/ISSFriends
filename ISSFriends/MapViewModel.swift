//
//  MapViewModel.swift
//  ISSFriends
//
//  Created by Jacob Benton on 4/7/16.
//  Copyright © 2016 jakebent. All rights reserved.
//

import Foundation
import Bond
import MapKit
import Alamofire

// This is the view model for the map controller. It handles the network requests for finding out the location of the ISS as well as storing the list of friends in memory. The list of friends is not currently persisted through sessions. When this model is initialized on start, it creates a dispatch timer to fetch the location of the ISS in the background every five seconds. When the request completes, it updates an observable variable named `issLocation` that the map controller observes.
class MapViewModel: NSObject {

    let networkService: NetworkService
    let issLocation = Observable(CLLocation())
    let myNextPassTime = Observable("")
    var timer: dispatch_source_t!
    var friends = ObservableArray<Friend>()

    init(networkService: NetworkService = NetworkService.sharedService) {
        self.networkService = networkService
        super.init()
        startTimer()
    }

    func requestMyNextPassTime(location: CLLocationCoordinate2D) {
        networkService.getPassTimes(lat: location.latitude, long: location.longitude, count: 1) { [weak self] (response) -> Void in
            guard let
                value = response.result.value as? [String: AnyObject],
                result = value["response"] as? [[String: NSTimeInterval]]
                else { return }

            guard let interval = result[0]["risetime"] else { return }
            self?.myNextPassTime.value = Utility.stringFromTimeInterval(interval)
        }
    }

    func addFriend(friend: Friend) {
        friends.append(friend)
    }

    func startTimer() {
        let queue = dispatch_queue_create("com.jakebent.ISSFriends.timer", nil)
        timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue)
        dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC, 1 * NSEC_PER_SEC) //Poll every 5 seconds
        dispatch_source_set_event_handler(timer) {
            self.networkService.getCurrentISSLocation({ [weak self] (response: Response<AnyObject, NSError>) -> Void in
                guard let
                    value = response.result.value as? [String: AnyObject],
                    location = value["iss_position"] as? [String: Double],
                    lat = location["latitude"],
                    lon = location["longitude"]
                    else { return }
                self?.issLocation.value = CLLocation(latitude: lat, longitude: lon)
            })
        }
        dispatch_resume(timer)
    }

    func stopTimer() {
        dispatch_source_cancel(timer)
        timer = nil
    }

    deinit {
        stopTimer()
    }
}
