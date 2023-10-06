//
//  RestaurantDTO.swift
//  Restaurants
//
//  Created by Nina on 7/30/23.
//

import UIKit

struct RestaurantDTO: Codable {
    var name: String
    var picture: String
    var description: String
    var type: String
    var address: String
}

extension RestaurantDTO {
    init(from data: Restaurant) {
        name = data.name
        picture = data.picture
        description = data.description
        type = data.type
        address = data.address
    }
    
    // Encoding function Restaurant -> JSON data
    func encode() -> Data? {
        let encoder = JSONEncoder()
        return try? encoder.encode(self)
    }
    
    //Decoding function JSON data -> Restaurant
    func decode(from data: Data) -> RestaurantDTO? {
        let decoder = JSONDecoder()
        return try? decoder.decode(RestaurantDTO.self, from: data)
    }
}
