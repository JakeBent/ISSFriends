//
//  FriendInfoViewModelSpec.swift
//  ISSFriends
//
//  Created by Jacob Benton on 4/7/16.
//  Copyright © 2016 jakebent. All rights reserved.
//

import MapKit
import Quick
import Nimble
@testable import ISSFriends

class FriendInfoViewModelSpec: QuickSpec {

    let friendInfoViewModel = FriendInfoViewModel(friend: Friend(name: "Dude", coordinate: CLLocationCoordinate2D(latitude: 45.0, longitude: 45.0)))

    override func spec() {
        describe("height") {
            context("When the view model is expanded") {
                it("should return the expanded view height") {
                    self.friendInfoViewModel.isExpanded = true
                    expect(self.friendInfoViewModel.height()).to(equal(168))

                }
            }

            context("When the view model is not expanded") {
                it("should return the collapsed view height") {
                    self.friendInfoViewModel.isExpanded = false
                    expect(self.friendInfoViewModel.height()).to(equal(40))
                }
            }
        }
    }
}
