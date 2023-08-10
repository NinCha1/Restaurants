//
//  AddRestaurantViewController.swift
//  Restaurants
//
//  Created by Nina on 7/18/23.
//

import UIKit


final class AddRestaurantViewController: UIViewController {
    
    private let saveButton = UIButton()
    
    var delegate: isAbleToReceiveData!
    
    var nameLabel = makeHeaderLabel(text: "Name")
    var typeLabel = makeHeaderLabel(text: "Type")
    var addressLabel = makeHeaderLabel(text: "Address")
    var descriptionLabel = makeHeaderLabel(text: "Descripton")
    
    lazy var picture = ""
    
    private let nameTextField = makeTextField(placeholder: "Name")
    private let typeTextField = makeTextField(placeholder: "Type")
    private let addressTextField = makeTextField(placeholder: "Address")
    private let descriptionTextField =  makeTextField(placeholder: "Descripton")
    
   lazy var restaurant = RestaurantDTO(name: nameTextField.text ?? "", picture: picture, description: descriptionTextField.text ?? "", type: typeTextField.text ?? "", address: addressTextField.text ?? "")
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.font = Font.headerFont
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
            print("saved")
//            RestaurantDTO.savedRestaurants.append(RestaurantDTO(name: nameTextField.text ?? "", picture: "restaurant1", description: descriptionTextField.text ?? "", type: typeTextField.text ?? "", address: addressTextField.text ?? ""))
            self.dismiss(animated: true, completion: nil)
        } else {
            errorLabel.text = "Anlaki"
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        delegate.pass(restaurant: restaurant)
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
        } else {
            errorLabel.text = "Anlaki"
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
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 5.0
        return textField
    }
    
    private func saveImage(image: UIImage) {


     guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }

        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let result = formatter.string(from: date)
        
        let fileURL = documentsDirectory.appendingPathComponent(result)
        guard let data = image.jpegData(compressionQuality: 1) else { return }

        //Checks if file exists, removes it if so.
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
                print("Removed old image")
            } catch let removeError {
                print("couldn't remove file at path", removeError)
            }

        }

        do {
            try data.write(to: fileURL)
        } catch let error {
            print("error saving file with error", error)
        }

    }

}

extension AddRestaurantViewController:  UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let fileUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL else { return }
        picture = fileUrl.path
        
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        imageAdd.image = image
        
        self.dismiss(animated: true, completion: nil)
    }
    
}
