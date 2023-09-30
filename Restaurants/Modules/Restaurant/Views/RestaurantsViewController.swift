//
//  RestaurantsViewController.swift
//  Restaurants
//
//  Created by Nina on 3/12/23.
//

import UIKit

final class RestaurantViewConrtoller: UIViewController, UITableViewDelegate {
    
    private let viewModel = RestaurantViewModel()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(RestaurantTableViewCell.self, forCellReuseIdentifier: RestaurantTableViewCell.identifier)
        return table
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupUI() {
        tableView.frame = view.bounds
        view.backgroundColor = .white
        navigationItem.title = "My Restaurants"
        navigationItem.setHidesBackButton(true, animated: true)
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        
        navigationItem.rightBarButtonItem = addButton    
        
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        
        viewModel.loadRestaurants()
        
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
            return viewModel.numberOfRestaurants()
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RestaurantTableViewCell.identifier, for: indexPath) as? RestaurantTableViewCell else {
            fatalError("Table did not dequeue a Cell")
        }
        
        let restaurant = viewModel.restaurantAtIndex(indexPath.row)
        
        cell.update(with: restaurant)
        cell.showsReorderControl = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let aboutRestaurantViewController = AboutRestaurantViewController()
    
        aboutRestaurantViewController.restaurant = viewModel.restaurantAtIndex(indexPath.row)

        self.present(aboutRestaurantViewController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.deleteRestaurant(indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
}

extension RestaurantViewConrtoller: AddRestaurantDelegate {
    func didAddRestaurant(restaurant: Restaurant) {
        viewModel.addRestaurant(restaurant: restaurant)
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
}
