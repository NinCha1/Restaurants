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


final class AddRestaurantViewController: UIViewController, UITextViewDelegate {
    
    private let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    private let saveButton = CustomButton()
    
    weak var delegate: AddRestaurantDelegate?
    
    private let nameLabel = makeHeaderLabel(text: "Name")
    private let typeLabel = makeHeaderLabel(text: "Type")
    private let addressLabel = makeHeaderLabel(text: "Address")
    private let descriptionLabel = makeHeaderLabel(text: "Descripton")
    private let imageLabel = makeHeaderLabel(text: "Image")
    
    lazy var picture = ""
    
    private let nameTextField = makeTextField()
    private let typeTextField = makeTextField()
    private let addressTextField = makeTextField()
    
    
    private let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.layer.borderColor = UIColor.gray.cgColor
        textView.layer.borderWidth = 1.0
        textView.layer.cornerRadius = 5.0
        textView.autocorrectionType = .no
        textView.textColor = .black
        textView.isEditable = true
        textView.font = .systemFont(ofSize: 16)
        return textView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 15
        
        [nameLabel, nameTextField, typeLabel, typeTextField, addressLabel, addressTextField, descriptionLabel, descriptionTextView, imageLabel].forEach {
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
    
    private let scrollView = UIScrollView()
    
    private let contentView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        navigationItem.title = "Add your restaurant"
        
        self.view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        setupTextFields()
        descriptionTextView.delegate = self
        
        let hConst = contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        hConst.isActive = true
        hConst.priority = UILayoutPriority(50)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            
            contentView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
        
        [stackView, imageAdd, saveButton].forEach {
            contentView.addSubview($0)
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
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            descriptionTextView.heightAnchor.constraint(equalToConstant: 100),
        
            imageAdd.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: ScreenDimension.defaultInset),
            imageAdd.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: ScreenDimension.defaultInset),
            imageAdd.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -ScreenDimension.defaultInset),
            imageAdd.heightAnchor.constraint(equalToConstant: 250),
            
            saveButton.topAnchor.constraint(equalTo: imageAdd.bottomAnchor, constant: 30),
            saveButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            saveButton.heightAnchor.constraint(equalToConstant: 48),
            saveButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: ScreenDimension.defaultInset),
            saveButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -ScreenDimension.defaultInset)
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
            let restaurant = Restaurant(name: nameTextField.text!, picture: picture, description: descriptionTextView.text!, type: typeTextField.text!, address: addressTextField.text!)
            delegate?.didAddRestaurant(restaurant: restaurant)
            
            navigationController?.popViewController(animated: true)
        } else {
            saveButton.isEnabled = false
        }
    }
    
    
    private func setupTextFields() {
        nameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        addressTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        typeTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
//        descriptionTextView.addTarget(self, action: #selector(textViewDidChange), for: .editingChanged)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if areTextFieldsValid() {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
    
    private func areTextFieldsValid() -> Bool {
        if nameTextField.text?.isEmpty == true || descriptionTextView.text?.isEmpty == true || addressTextField.text?.isEmpty == true || typeTextField.text?.isEmpty == true {
            return false
        } else {
            return true
        }
    }
    
    @objc private func textFieldDidChange() {
        if areTextFieldsValid() {
            saveButton.isEnabled = true
        } else {
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
    
    private static func makeTextField() -> UITextField {
        let textField = UITextFieldPadding()
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
