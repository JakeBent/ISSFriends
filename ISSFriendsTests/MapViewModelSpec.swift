//
//  MapViewModelSpec.swift
//  ISSFriends
//
//  Created by Jacob Benton on 4/7/16.
//  Copyright © 2016 jakebent. All rights reserved.
//

import Quick
import Nimble
import Alamofire
import MapKit
@testable import ISSFriends

class MockNetworkService: NetworkService {
    var calledGetCurrentISSLocation = false
    var calledGetPassTimes = false
    var argLat: Double? = nil
    var argLon: Double? = nil
    var argCount: Int? = nil

    override func getCurrentISSLocation(completion: (Response<AnyObject, NSError>) -> Void) {
        calledGetCurrentISSLocation = true
    }

    override func getPassTimes(lat lat: Double, long: Double, count: Int, completion: (Response<AnyObject, NSError>) -> Void) {
        calledGetPassTimes = true
        argLat = lat
        argLon = long
        argCount = count
    }
}

class MapViewModelSpec: QuickSpec {
    let mockNetworkService = MockNetworkService()

    override func spec() {
        let mapViewModel = MapViewModel(networkService: mockNetworkService)

        describe("-requestMyNextPassTime") {
            it("will call the network servce with the correct arguments") {
                mapViewModel.requestMyNextPassTime(CLLocationCoordinate2D(latitude: 45.0, longitude: 54.0))
                expect(self.mockNetworkService.calledGetPassTimes).to(beTrue())
                expect(self.mockNetworkService.argLat).to(equal(45.0))
                expect(self.mockNetworkService.argLon).to(equal(54.0))
                expect(self.mockNetworkService.argCount).to(equal(1))
            }
        }

        describe("-startTimer") {
            it("will eventually make a request to the network service") {
                mapViewModel.startTimer()
                expect(self.mockNetworkService.calledGetCurrentISSLocation).toEventually(beTrue())
            }
        }

    }
}
