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
                expect(controller).to(beAKindOf(UITabBarController))
            }
        }
    }
}

class ISSFriendsTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
