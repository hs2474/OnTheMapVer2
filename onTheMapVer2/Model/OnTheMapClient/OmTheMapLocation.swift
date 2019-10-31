//
//  OmTheMapLocation.swift
//  onTheMapVer2
//
//  Created by Hema on 10/20/19.
//  Copyright © 2019 Hema. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation
struct MapPosition {
    var firstName: String
    var lastName: String
    var longitude: CLLocationDegrees
    var latitude: CLLocationDegrees
    var mediaURL: String
    var mapString: String
}

var studentPosition = Array<MapPosition>()

struct NewLocation {
    var longitude: CLLocationDegrees
    var latitude: CLLocationDegrees
}
