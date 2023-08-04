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
    
    static var archiveURL: URL {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURL = documentsURL.appendingPathComponent("restaurants").appendingPathExtension("plist")
        
        return archiveURL
    }
    
//    static var savedRestaurants: [RestaurantDTO] {
//        return [
//            RestaurantDTO(name: "Aist", picture:  "restaurant2", description: "Refined international dining room with a monochrome color scheme, large windows & a summer terrace.", type: "Italian and Russian cuisines", address: "Malaya Bronnaya St. 8/1, Presnensky"),
//            RestaurantDTO(name: "Turandot", picture: "restaurant6", description: "Lavishly done out restaurant with silks & chandeliers, with French, Japanese & Chinese menu.", type: "French, Chinese & Japanese", address: "Tverskoy Blvd, 26"),
//            RestaurantDTO(name: "Lou Lou", picture: "restaurant4", description: "Lou Lou is a small France in the very center of Moscow. All the best that we know and imagine about the country of love and gastronomy is intertwined here.", type: "French cuisine", address: "Malaya Bronnaya St, 10"),
//            RestaurantDTO(name: "Extra Virgin", picture: "restaurant1", description: "Charcoal grill, natural wood fire pizza oven, our own bread and large full bar are in the center of the restaurant located in historical center of Moscow at the crossroads of old Pokrovka street and Boulevard Ring. We serve contemporary Mediterranean cuisine for you everyday from midday till midnight", type: "Mediterranean Grill & Wine", address: "Pokrovka St, 17"),
//            RestaurantDTO(name: "Voskhod", picture: "restaurant5", description: "Restaurant \"Sunrise\" in the park \"Zaryadye\" is a city attraction. The menu cleverly mixes the dishes of the peoples of the former USSR, including the Baltic states, Ukraine and Central Asia: Poltava borsch, salad with Narva lampreys, Kiev cutlet, dumplings and six kinds of pilaf. The theme of space exploration and the slightly naive futurism of the 60s are embodied in the interior. Important details - a spacious veranda with 120 seats and a completely open-air view of the Kremlin and Vasilyevsky Descent.", type: "Seafood", address: "Varvarka St, 6"),
//            RestaurantDTO(name: "Birds", picture: "restaurant7", description: "A large-scale project with multimillion-dollar investments united different genres - from theatrical sketches of actors of leading theaters in Moscow to gastronomic performances - to create a fundamentally new format of recreation. A holiday every day that does not need a special occasion and a strict schedule. A holiday that can be afforded at any time and which surrounds from the first step through the threshold, without making you wait for the start of the program.", type: "Bar", address: "Krasnogvardeyskiy Proyezd, 21"),
//            RestaurantDTO(name: "Sakhalin", picture: "restaurant8", description: "Sakhalin - project of restaurateur Boris Zarkov and Vladimir Mukhin, a brand-chef of the company White Rabbit Family. A variety of seafood: shells, crabs, shrimps and fish of the Far East of Russia - on the background of a unique 360-degree panoramic view of Moscow. Gastronomy as an art where perfection of performance is achieved under the conductor's stick of taste is Sakhalin. The restaurant, which sounds the music of the seas and oceans.", type: "Seafood", address: "Smolenskaya St, 8"),
//            RestaurantDTO(name: "Khoroshaya Devochka", picture: "restaurant3", description: "Polished fine dining restaurant offering elevated pasta & duck dishes, plus soup & desserts.", type: "Casual dining restaurant", address: "Malaya Bronnaya St, 10"),
//        ]
//    }
    
    static func saveToFile(restaurants: [RestaurantDTO]) {
        let encoder = PropertyListEncoder()
        do {
            let encodedRestaurants = try encoder.encode(restaurants)
            try encodedRestaurants.write(to: RestaurantDTO.archiveURL)
        } catch {
            print("Error encoding restaurants: \(error)")
        }
    }
    
    static func loadFromFile() -> [RestaurantDTO]? {
        guard let restaurantsData = try? Data(contentsOf: RestaurantDTO.archiveURL) else {
            return nil
        }
        
        do {
            let decoder = PropertyListDecoder()
            let decodedRestaurants = try decoder.decode([RestaurantDTO].self, from: restaurantsData)
            
            return decodedRestaurants
        } catch {
            print("Error decoding restaurants: \(error)")
            return nil
        }
    }
}
