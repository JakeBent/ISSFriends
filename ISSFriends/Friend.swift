//
//  Friend.swift
//  ISSFriends
//
//  Created by Jacob Benton on 4/7/16.
//  Copyright © 2016 jakebent. All rights reserved.
//

import UIKit
import MapKit

// This is the map annotation/model for friends
class Friend: NSObject, MKAnnotation {

    static var annotationViewIdentifier = "friend"
    let name: String
    var coordinate: CLLocationCoordinate2D

    init(name: String, coordinate: CLLocationCoordinate2D) {
        self.name = name
        self.coordinate = coordinate
        super.init()
    }
}
