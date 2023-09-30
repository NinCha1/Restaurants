//
//  AddRestaurantViewController.swift
//  Restaurants
//
//  Created by Nina on 7/18/23.
//

import UIKit

protocol AddRestaurantDelegate: AnyObject {
    func didAddRestaurant(restaurant: Restaurant)
}


final class AddRestaurantViewController: UIViewController {
    
    private let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    private let saveButton = CustomButton()
    
    weak var delegate: AddRestaurantDelegate?
    
    var nameLabel = makeHeaderLabel(text: "Name")
    var typeLabel = makeHeaderLabel(text: "Type")
    var addressLabel = makeHeaderLabel(text: "Address")
    var descriptionLabel = makeHeaderLabel(text: "Descripton")
    
    lazy var picture = ""
    
    private let nameTextField = makeTextField(placeholder: "Name")
    private let typeTextField = makeTextField(placeholder: "Type")
    private let addressTextField = makeTextField(placeholder: "Address")
    private let descriptionTextField =  makeTextField(placeholder: "Descripton")
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.font = UIFont(name:"HelveticaNeue", size: 17.0)
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 15
        
        [nameLabel, nameTextField, typeLabel, typeTextField, addressLabel, addressTextField, descriptionLabel, descriptionTextField].forEach {
            stackView.addArrangedSubview($0)
        }
        return stackView
    }()
    
    private let imageAdd: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .gray
        imageView.layer.cornerRadius = 5.0
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupTextFields()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        navigationItem.title = "Add your restaurant"
        
        [stackView, errorLabel, imageAdd, saveButton].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let tapGestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
        imageAdd.addGestureRecognizer(tapGestureRecogniser)
        
        saveButton.isEnabled = false
        saveButton.backgroundColor = .black
        saveButton.setTitle("Save", for: .normal)
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.layer.cornerRadius = 15.0
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            errorLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: ScreenDimension.defaultInset),
            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            imageAdd.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: ScreenDimension.defaultInset),
            imageAdd.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ScreenDimension.defaultInset),
            imageAdd.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -ScreenDimension.defaultInset),
            imageAdd.heightAnchor.constraint(equalToConstant: 250),
            
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.heightAnchor.constraint(equalToConstant: 48),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ScreenDimension.defaultInset),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -ScreenDimension.defaultInset)
        ])
    }
    
    @objc private func imageViewTapped() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self;
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }
    
    }
    
    
    
    @objc private func saveTapped() {
        if areTextFieldsValid() {
            let restaurant = Restaurant(name: nameTextField.text!, picture: picture, description: descriptionTextField.text!, type: typeTextField.text!, address: addressTextField.text!)
            delegate?.didAddRestaurant(restaurant: restaurant)
            
            self.dismiss(animated: true, completion: nil)
        } else {
            errorLabel.text = "Please fill out everything."
        }
    }
    
    
    private func setupTextFields() {
        nameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        addressTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        descriptionTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    private func areTextFieldsValid() -> Bool {
        if nameTextField.text?.isEmpty == true || descriptionTextField.text?.isEmpty == true || addressTextField.text?.isEmpty == true {
            return false
        } else {
            return true
        }
    }
    
    @objc private func textFieldDidChange() {
        if areTextFieldsValid() {
            errorLabel.text = ""
            saveButton.isEnabled = true
        } else {
            errorLabel.text = "Please fill out everything."
            saveButton.isEnabled = false
        }
    }
    private static func makeHeaderLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = Font.subtitleFont
        label.textColor = .gray
        
        return label
    }
    
    private static func makeTextField(placeholder: String) -> UITextField {
        let textField = UITextFieldPadding()
//        textField.placeholder = placeholder
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 5.0
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        return textField
    }
    
    //MARK: Saving Image Logic
    
    private func saveImageToDocumentDirectory(_ image: UIImage) -> String? {
        let timestamp = Date().timeIntervalSince1970
        let fileName = "\(timestamp).png"
        
        if let data = image.pngData() {
            let fileURL = documentsDirectory.appendingPathComponent(fileName)
            do {
                try data.write(to: fileURL)
                return fileName
            } catch {
                print("Error saving image: \(error)")
                return nil
            }
        }
        
        return nil
    }
}

extension AddRestaurantViewController:  UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        imageAdd.image = image
        
        if let image = image {
            if let path = saveImageToDocumentDirectory(image) {
                picture = path
            }
        }
        
        self.dismiss(animated: true, completion: nil)
    }
}
