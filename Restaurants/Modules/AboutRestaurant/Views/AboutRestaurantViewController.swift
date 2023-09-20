//
//  AboutRestaurantViewController.swift
//  Restaurants
//
//  Created by Nina on 7/10/23.
//

import UIKit
import MapKit

final class AboutRestaurantViewController: UIViewController {

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
    
    
//    private let mapView : MKMapView = {
//        mapView.centerToLocation(<#T##CLLocation#>)
//    }()
    
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
        
        if let restaurant = restaurant {
            restaurantImage.image = loadImageFromDiskWith(fileName: restaurant.picture)
            restaurantName.text = restaurant.name
            restaurantAddress.text = restaurant.address
            restaurantType.text = restaurant.type
            restaurantDescription.text = restaurant.description
            
        }
        
        setupUI()
        // Do any additional setup after loading the view.
    }
    
    
    func setupUI() {
        view.backgroundColor = .white
        
        [restaurantImage, restaurantName, restaurantAddress, restaurantAddress, restaurantDescription, addressLabel].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            restaurantImage.heightAnchor.constraint(equalTo: view.heightAnchor,constant: -450),
            restaurantImage.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            restaurantName.bottomAnchor.constraint(equalTo: restaurantImage.bottomAnchor, constant: -20),
            restaurantName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            
            restaurantDescription.topAnchor.constraint(equalTo: restaurantImage.bottomAnchor, constant: 15),
            restaurantDescription.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            restaurantDescription.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            addressLabel.topAnchor.constraint(equalTo: restaurantDescription.bottomAnchor, constant: 20),
            addressLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            
            restaurantAddress.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 10),
            restaurantAddress.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
        ])
    }
}

private extension MKMapView {
    func centerToLocation(
        _ location: CLLocation,
        regionRadius: CLLocationDistance = 1000
    ) {
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius
        )
        setRegion(coordinateRegion, animated: true)
    }
}
