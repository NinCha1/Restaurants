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
    
//    enum CodingKeys: String, CodingKey {
//        case name
//        case picture = "picture_path"
//        case description
//        case type
//        case address
//    }
    
    static let DocumentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentDirectory.appendingPathComponent("restaurants").appendingPathExtension("plist")
    
    static func loadSampleRestaurants() -> [Restaurant] {
        return [
            Restaurant(name: "Aist", picture:  "restaurant2", description: "Refined international dining room with a monochrome color scheme, large windows & a summer terrace.", type: "Italian and Russian cuisines", address: "Malaya Bronnaya St. 8/1, Presnensky"),
            Restaurant(name: "Turandot", picture: "restaurant6", description: "Lavishly done out restaurant with silks & chandeliers, with French, Japanese & Chinese menu.", type: "French, Chinese & Japanese", address: "Tverskoy Blvd, 26"),
            Restaurant(name: "Lou Lou", picture: "restaurant4", description: "Lou Lou is a small France in the very center of Moscow. All the best that we know and imagine about the country of love and gastronomy is intertwined here.", type: "French cuisine", address: "Malaya Bronnaya St, 10"),
            Restaurant(name: "Extra Virgin", picture: "restaurant1", description: "Charcoal grill, natural wood fire pizza oven, our own bread and large full bar are in the center of the restaurant located in historical center of Moscow at the crossroads of old Pokrovka street and Boulevard Ring. We serve contemporary Mediterranean cuisine for you everyday from midday till midnight", type: "Mediterranean Grill & Wine", address: "Pokrovka St, 17"),
            Restaurant(name: "Voskhod", picture: "restaurant5", description: "Restaurant \"Sunrise\" in the park \"Zaryadye\" is a city attraction. The menu cleverly mixes the dishes of the peoples of the former USSR, including the Baltic states, Ukraine and Central Asia: Poltava borsch, salad with Narva lampreys, Kiev cutlet, dumplings and six kinds of pilaf. The theme of space exploration and the slightly naive futurism of the 60s are embodied in the interior. Important details - a spacious veranda with 120 seats and a completely open-air view of the Kremlin and Vasilyevsky Descent.", type: "Seafood", address: "Varvarka St, 6"),
            Restaurant(name: "Birds", picture: "restaurant7", description: "A large-scale project with multimillion-dollar investments united different genres - from theatrical sketches of actors of leading theaters in Moscow to gastronomic performances - to create a fundamentally new format of recreation. A holiday every day that does not need a special occasion and a strict schedule. A holiday that can be afforded at any time and which surrounds from the first step through the threshold, without making you wait for the start of the program.", type: "Bar", address: "Krasnogvardeyskiy Proyezd, 21"),
            Restaurant(name: "Sakhalin", picture: "restaurant8", description: "Sakhalin - project of restaurateur Boris Zarkov and Vladimir Mukhin, a brand-chef of the company White Rabbit Family. A variety of seafood: shells, crabs, shrimps and fish of the Far East of Russia - on the background of a unique 360-degree panoramic view of Moscow. Gastronomy as an art where perfection of performance is achieved under the conductor's stick of taste is Sakhalin. The restaurant, which sounds the music of the seas and oceans.", type: "Seafood", address: "Smolenskaya St, 8"),
            Restaurant(name: "Khoroshaya Devochka", picture: "restaurant3", description: "Polished fine dining restaurant offering elevated pasta & duck dishes, plus soup & desserts.", type: "Casual dining restaurant", address: "Malaya Bronnaya St, 10"),
        ]
    }
    static func saveToFile(restaurants: [RestaurantDTO]) {
        let encoder = PropertyListEncoder()
        
        let codedRestaurants = try? encoder.encode(restaurants)
        try? codedRestaurants?.write(to: ArchiveURL, options: .noFileProtection)
    }
    
    static func loadFromFile() -> [RestaurantDTO]? {
        guard let codedRestaurants = try? Data(contentsOf: ArchiveURL) else {return []}
        let decoder = PropertyListDecoder()
        
        return try? decoder.decode(Array<RestaurantDTO>.self, from: codedRestaurants)
        
    }
}
