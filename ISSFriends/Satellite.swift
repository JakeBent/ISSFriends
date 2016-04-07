//
//  Satellite.swift
//  ISSFriends
//
//  Created by Jacob Benton on 4/7/16.
//  Copyright © 2016 jakebent. All rights reserved.
//

import Foundation
import MapKit

// This is the map annotation for the ISS
class Satellite: NSObject, MKAnnotation {

    static var annotationViewIdentifier = "satellite"
    var coordinate: CLLocationCoordinate2D

    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        super.init()
    }
}
