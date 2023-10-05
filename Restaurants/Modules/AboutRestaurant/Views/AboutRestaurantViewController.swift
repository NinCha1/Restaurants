//
//  AboutRestaurantViewController.swift
//  Restaurants
//
//  Created by Nina on 7/10/23.
//

import UIKit
import MapKit

final class AboutRestaurantViewController: UIViewController, UIScrollViewDelegate {

    var restaurant: Restaurant?
    
    
    private let restaurantImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    private let restaurantName: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.layer.shadowColor = UIColor.gray.cgColor
        label.layer.shadowRadius = 3.0
        label.layer.shadowOpacity = 1.0
        label.layer.shadowOffset = CGSize(width: 4, height: 4)
        label.font = UIFont(name:"HelveticaNeue-Bold", size: 35.0)
        return label
    }()
    
    private let restaurantAddress: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont(name:"HelveticaNeue", size: 16.0)
        return label
    }()
    
    private let restaurantType: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont(name:"HelveticaNeue", size: 16.0)
        return label
    }()
    
    private let restaurantDescription: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 0
        label.font = UIFont(name:"HelveticaNeue-Thin", size: 18.0)
        return label
    }()
    
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name:"HelveticaNeue-Bold", size: 20.0)
        label.text = "Address"
        return label
    }()
    
    private let cancelButton = UIButton()
    
    private let scrollView = UIScrollView()
    
    private let contentView = UIView()
    
    
    private func loadImageFromDiskWith(fileName: String) -> UIImage? {

      let documentDirectory = FileManager.SearchPathDirectory.documentDirectory

        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)

        if let dirPath = paths.first {
            let imageUrl = URL(fileURLWithPath: dirPath).appendingPathComponent(fileName)
            let image = UIImage(contentsOfFile: imageUrl.path)
            return image
        }

        return nil
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        
        if let restaurant = restaurant {
            restaurantImage.image = loadImageFromDiskWith(fileName: restaurant.picture)
            restaurantName.text = restaurant.name
            restaurantAddress.text = restaurant.address
            restaurantType.text = restaurant.type
            restaurantDescription.text = restaurant.description
        }
        
        setupUI()
    }
    
    func setupUI() {
        view.backgroundColor = .white
        scrollView.delegate = self
        
        self.view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        let hConst = contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        hConst.isActive = true
        hConst.priority = UILayoutPriority(50)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            
            contentView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
        cancelButton.backgroundColor = .gray
        cancelButton.setTitle("X", for: .normal)
        cancelButton.setTitleColor(.white, for: .normal)
        cancelButton.layer.cornerRadius = 18.0
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        
        [restaurantImage, cancelButton, restaurantName, restaurantAddress, restaurantAddress, restaurantDescription, addressLabel].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
                                    
        NSLayoutConstraint.activate([
            restaurantImage.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            restaurantImage.heightAnchor.constraint(equalTo: view.heightAnchor, constant: -500),
            restaurantImage.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            
            cancelButton.topAnchor.constraint(equalTo: restaurantImage.topAnchor, constant: 10),
            cancelButton.trailingAnchor.constraint(equalTo: restaurantImage.trailingAnchor, constant: -10),
            
            restaurantName.bottomAnchor.constraint(equalTo: restaurantImage.bottomAnchor, constant: -20),
            restaurantName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            
            restaurantDescription.topAnchor.constraint(equalTo: restaurantImage.bottomAnchor, constant: 15),
            restaurantDescription.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            restaurantDescription.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            addressLabel.topAnchor.constraint(equalTo: restaurantDescription.bottomAnchor, constant: 20),
            addressLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            
            restaurantAddress.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 10),
            restaurantAddress.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
        ])
    }
    
    @objc private func cancelButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
