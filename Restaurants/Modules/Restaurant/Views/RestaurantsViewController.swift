//
//  RestaurantsViewController.swift
//  Restaurants
//
//  Created by Nina on 3/12/23.
//

import UIKit

protocol isAbleToReceiveData {
    func pass(restaurant: RestaurantDTO)
}

final class RestaurantViewConrtoller: UIViewController, UITableViewDelegate, isAbleToReceiveData {
    
    var restaurants: [RestaurantDTO] = [] {
        didSet {
            RestaurantDTO.saveToFile(restaurants: restaurants)
        }
    }
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(RestaurantTableViewCell.self, forCellReuseIdentifier: RestaurantTableViewCell.identifier)
        return table
    }()
    
    func pass(restaurant: RestaurantDTO) {
        let newIndexPath = IndexPath(row: restaurants.count, section: 0)
        restaurants.append(restaurant)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let savedRestaurants = RestaurantDTO.loadFromFile() {
            restaurants = savedRestaurants
        }
//        } else {
//            restaurants = RestaurantDTO.savedRestaurants
//        }
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    private func setupUI() {
        tableView.frame = view.bounds
        view.backgroundColor = .white
        navigationItem.title = "My Restaurants"
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        
        navigationItem.rightBarButtonItem = addButton    
        
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
    }
    
    @objc private func addTapped() {
        let addRestaurantVC = AddRestaurantViewController()
        addRestaurantVC.delegate = self
        self.present(addRestaurantVC, animated: true, completion: nil)
    }
}

extension RestaurantViewConrtoller: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return restaurants.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RestaurantTableViewCell.identifier, for: indexPath) as? RestaurantTableViewCell else {
            fatalError("Table did not dequeue a Cell")
        }
        
        let restaurant = restaurants[indexPath.row]
        
        cell.update(with: restaurant)
        cell.showsReorderControl = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let aboutRestaurantViewController = AboutRestaurantViewController()
    
        aboutRestaurantViewController.restaurant = restaurants[indexPath.row]
//        self.navigationController?.pushViewController(aboutRestaurantViewController, animated: false)
        self.present(aboutRestaurantViewController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            restaurants.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
}
