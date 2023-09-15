//
//  RestaurantTableViewCell.swift
//  Restaurants
//
//  Created by Nina on 4/1/23.
//

import UIKit

final class RestaurantTableViewCell: UITableViewCell {
    static let identifier = "RestaurantTableViewCell"
    
    private let restaurantImage: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 15.0
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    private let restaurantName: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name:"HelveticaNeue-Bold", size: 20.0)
        return label
    }()
    
    private let restaurantAddress: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont(name:"HelveticaNeue", size: 12.0)
        return label
    }()
    
    private let restaurantType: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont(name:"HelveticaNeue", size: 16.0)
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        
        [restaurantName, restaurantType, restaurantAddress].forEach {
            stack.addArrangedSubview($0)
        }
        return stack
    }()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
     
    @available(*,unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupUI() {
        contentView.backgroundColor = .white
    
        
        
        [restaurantImage, stackView].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(equalToConstant: 100),
            
            restaurantImage.heightAnchor.constraint(equalTo: contentView.heightAnchor, constant: -10),
            restaurantImage.widthAnchor.constraint(equalTo: contentView.heightAnchor, constant: -10),
            restaurantImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            restaurantImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            stackView.leadingAnchor.constraint(equalTo: restaurantImage.trailingAnchor, constant: 20),
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

        ])

    }
    
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
    
    func update(with restaurant: Restaurant) {
        
        restaurantType.text = restaurant.type
        restaurantName.text = restaurant.name
        restaurantAddress.text = restaurant.address
        restaurantImage.image = loadImageFromDiskWith(fileName: restaurant.picture)
    }

}
