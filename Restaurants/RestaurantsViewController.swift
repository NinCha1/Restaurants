//
//  RestaurantsViewController.swift
//  Restaurants
//
//  Created by Nina on 3/12/23.
//

import UIKit

final class RestaurantViewConrtoller: UIViewController, UITableViewDelegate {
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(RestaurantTableViewCell.self, forCellReuseIdentifier: RestaurantTableViewCell.identifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        navigationItem.title = "My Restaurants"
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
    }
}

extension RestaurantViewConrtoller: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return Restaurant.restaurants.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RestaurantTableViewCell.identifier, for: indexPath) as? RestaurantTableViewCell else {
            fatalError("Table did not dequeue a Cell")
        }
        
        let restaurant = Restaurant.restaurants[indexPath.row]
        
        cell.update(with: restaurant)
        cell.showsReorderControl = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let aboutRestaurantViewController = AboutRestaurantViewController()
    
        aboutRestaurantViewController.restaurant = Restaurant.restaurants[indexPath.row]
//        self.navigationController?.pushViewController(aboutRestaurantViewController, animated: false)
        self.present(aboutRestaurantViewController, animated: true, completion: nil)
    }
}
