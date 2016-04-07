//
//  ISSFriendsTests.swift
//  ISSFriendsTests
//
//  Created by Jacob Benton on 4/7/16.
//  Copyright © 2016 jakebent. All rights reserved.
//

import Quick
import Nimble
@testable import ISSFriends

class AppDelegateSpec: QuickSpec {
    var myWindow : UIWindow?

    override func spec() {
        describe("-didFinishLaunchingWithOptions()") {
            it("it should present a navigation controller with a feedsviewcontroller") {
                let controller = UIApplication.sharedApplication().keyWindow!.rootViewController
                expect(controller).to(beAKindOf(MapViewController))
            }
        }
    }
}