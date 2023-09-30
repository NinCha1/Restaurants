//
//  Restaurant.swift
//  Restaurants
//
//  Created by Nina on 4/1/23.
//

import UIKit
import MapKit


struct Restaurant {
    var name: String
    var picture: String
    var description: String
    var type: String
    var address: String
    //    var coordinates: CLLocation
}

extension Restaurant {
    init(from dto: RestaurantDTO) {
        name = dto.name
        picture = dto.picture
        description = dto.description
        type = dto.type
        address = dto.address
    }
}


