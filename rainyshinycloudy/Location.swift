//
//  Location.swift
//  rainyshinycloudy
//
//  Created by Yizhen Shi on 12/18/16.
//  Copyright © 2016 Yizhen Shi. All rights reserved.
//

import CoreLocation

class Location {
    static var sharedInstance = Location()
    private init() {}
    
    var latitude: Double!
    var longitude: Double!
}
