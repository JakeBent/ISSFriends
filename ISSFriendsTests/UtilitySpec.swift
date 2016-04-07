//
//  UtilitySpec.swift
//  ISSFriends
//
//  Created by Jacob Benton on 4/7/16.
//  Copyright © 2016 jakebent. All rights reserved.
//

import Quick
import Nimble
@testable import ISSFriends

class UtilitySpec: QuickSpec {

    override func spec() {
        describe("+stringFromTimeInterval(interval:)") {
            it("it should return a properly formatted string") {
                let interval = NSTimeInterval(1234567891)
                expect(Utility.stringFromTimeInterval(interval)).to(equal("02/13/2009 @ 18:31:31"))
            }
        }
    }
}