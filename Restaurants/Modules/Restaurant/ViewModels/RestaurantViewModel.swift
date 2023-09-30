//
//  RestaurantViewModel.swift
//  Restaurants
//
//  Created by Nina on 9/14/23.
//

import Foundation

final class RestaurantViewModel {
    private let fileManager = FilesManager()
    private var restaurants: [Restaurant] = []
    
    
    func loadRestaurants() {
        do {
            let data = try fileManager.read(fileNamed: "restaurants")
            let restaurantDTOs = try JSONDecoder().decode([RestaurantDTO].self, from: data)
            restaurants = restaurantDTOs.map { Restaurant(from: $0) }
        }
        catch {
            print("Error loading restaurants: \(error)")
        }
    }
    
    func saveRestaurants() {
        do {
            let restaurantDTOs = restaurants.map { RestaurantDTO(from: $0) }
            let data = try JSONEncoder().encode(restaurantDTOs)
            try fileManager.save(fileNamed: "restaurants", data: data)
        }
        catch {
            print("Error savind restaurants: \(error)")
        }
    }
    
    func addRestaurant(restaurant: Restaurant) {
        restaurants.append(restaurant)
        saveRestaurants()
    }
    
    func numberOfRestaurants() -> Int {
        return restaurants.count
    }
    
    func restaurantAtIndex(_ index: Int) -> Restaurant {
        return restaurants[index]
    }
    
    func deleteRestaurant(_ index: Int) {
        restaurants.remove(at: index)
        saveRestaurants()
    }
}
